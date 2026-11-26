// PBKDF2-HMAC-SHA256 in plain Dart, written for speed (SEC-4, ADR-085).
//
// Why it exists: a backup file travels (Drive, WhatsApp, email), so its passphrase must cost
// an attacker as much as the phone can afford. OWASP's floor for PBKDF2-HMAC-SHA256 is 600,000
// rounds. The `cryptography` package's pure-Dart PBKDF2 allocates on every round and needs about
// 5 seconds for 600,000 rounds on a desktop CPU, far longer on a mid-range phone. This version
// pre-computes the two HMAC pad states once and runs each round as exactly two SHA-256
// compressions on fixed buffers, with no allocation inside the loop. The output is the
// standard PBKDF2 (RFC 8018) with the password encoded as UTF-8, byte-for-byte what the
// package produces: test/sec_hardening_test.dart checks it against the package and against
// published test vectors, so backups and PIN hashes written before this file still open.
// Pure Dart, synchronous, no platform code.

import 'dart:convert';
import 'dart:typed_data';

/// SHA-256 output length, in bytes.
const _hashLength = 32;

/// SHA-256 block length, in bytes.
const _blockLength = 64;

const _mask = 0xffffffff;

/// SHA-256 round constants (FIPS 180-4 §4.2.2).
const List<int> _k = [
  0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5, //
  0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
  0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
  0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
  0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
  0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
  0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
  0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
];

/// SHA-256 initial hash value (FIPS 180-4 §5.3.3).
const List<int> _iv = [0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19];

/// Derives [length] bytes from [password] (UTF-8) and [salt] with PBKDF2-HMAC-SHA256 at
/// [iterations] rounds.
///
/// Throws [ArgumentError] when [iterations] or [length] is below 1. Runs synchronously: the
/// caller decides whether to move it off the UI isolate.
Uint8List pbkdf2HmacSha256(String password, List<int> salt, {required int iterations, int length = _hashLength}) {
  if (iterations < 1) throw ArgumentError.value(iterations, 'iterations', 'must be at least 1');
  if (length < 1) throw ArgumentError.value(length, 'length', 'must be at least 1');
  final hmac = _Hmac(utf8.encode(password));
  final out = Uint8List(length);
  final blocks = (length + _hashLength - 1) ~/ _hashLength;
  for (var block = 1; block <= blocks; block += 1) {
    final t = hmac.saltedBlock(salt, block, iterations);
    final offset = (block - 1) * _hashLength;
    for (var i = 0; i < _hashLength && offset + i < length; i += 1) {
      out[offset + i] = t[i];
    }
  }
  return out;
}

/// HMAC-SHA256 with the inner and outer pad states computed once.
class _Hmac {
  _Hmac(List<int> key) {
    var k = key;
    if (k.length > _blockLength) k = _sha256(k);
    final pad = Uint8List(_blockLength)..setRange(0, k.length, k);
    final inner = Uint8List(_blockLength);
    final outer = Uint8List(_blockLength);
    for (var i = 0; i < _blockLength; i += 1) {
      inner[i] = pad[i] ^ 0x36;
      outer[i] = pad[i] ^ 0x5c;
    }
    _innerState.setAll(0, _iv);
    _outerState.setAll(0, _iv);
    _loadBlock(inner, 0);
    _compress(_innerState);
    _loadBlock(outer, 0);
    _compress(_outerState);
  }

  final _innerState = Uint32List(8);
  final _outerState = Uint32List(8);
  // The 64-word message schedule, reused by every compression.
  final _w = Uint32List(64);
  final _scratch = Uint32List(8);

  /// T_block = U_1 xor U_2 xor ... xor U_iterations, as 32 bytes.
  Uint8List saltedBlock(List<int> salt, int block, int iterations) {
    // U_1 = HMAC(salt || INT(block)): a message of any length, so the general path.
    final first = Uint8List(salt.length + 4)
      ..setRange(0, salt.length, salt)
      ..[salt.length] = (block >> 24) & 0xff
      ..[salt.length + 1] = (block >> 16) & 0xff
      ..[salt.length + 2] = (block >> 8) & 0xff
      ..[salt.length + 3] = block & 0xff;
    final innerHash = _sha256(first, state: _innerState, prefixBytes: _blockLength);
    final u = _wordsOf(_sha256(innerHash, state: _outerState, prefixBytes: _blockLength));
    final t = Uint32List.fromList(u);
    // U_2 ... U_c: each message is one 32-byte hash, so each HMAC is exactly two
    // compressions of a block whose padding never changes (length = 64 + 32 bytes).
    for (var i = 1; i < iterations; i += 1) {
      _hashOneDigest(_innerState, u);
      _hashOneDigest(_outerState, u);
      for (var j = 0; j < 8; j += 1) {
        t[j] ^= u[j];
      }
    }
    return _bytesOf(t);
  }

  /// Replaces [digest] with SHA-256(state-prefix || digest), where the prefix is one block.
  void _hashOneDigest(Uint32List state, Uint32List digest) {
    final w = _w;
    for (var j = 0; j < 8; j += 1) {
      w[j] = digest[j];
    }
    w[8] = 0x80000000;
    for (var j = 9; j < 15; j += 1) {
      w[j] = 0;
    }
    w[15] = (_blockLength + _hashLength) * 8;
    _scratch.setAll(0, state);
    _compress(_scratch);
    digest.setAll(0, _scratch);
  }

  void _loadBlock(List<int> bytes, int offset) => _loadWords(_w, bytes, offset);

  void _compress(Uint32List state) => _compressInto(state, _w);
}

/// SHA-256 of [message], optionally continuing from [state] after [prefixBytes] bytes that
/// were already compressed (used for the HMAC pads). Returns the 32-byte digest.
Uint8List _sha256(List<int> message, {Uint32List? state, int prefixBytes = 0}) {
  final h = Uint32List(8)..setAll(0, state ?? _iv);
  final totalBits = (prefixBytes + message.length) * 8;
  final padded = ((message.length + 9 + _blockLength - 1) ~/ _blockLength) * _blockLength;
  final data = Uint8List(padded)
    ..setRange(0, message.length, message)
    ..[message.length] = 0x80;
  // A 64-bit big-endian length; Dart ints are 64-bit on every phone target.
  for (var i = 0; i < 8; i += 1) {
    data[padded - 1 - i] = (totalBits >> (8 * i)) & 0xff;
  }
  final w = Uint32List(64);
  for (var offset = 0; offset < padded; offset += _blockLength) {
    _loadWords(w, data, offset);
    _compressInto(h, w);
  }
  return _bytesOf(h);
}

/// Loads one 64-byte block, big-endian, into the first 16 words of [w].
void _loadWords(Uint32List w, List<int> bytes, int offset) {
  for (var j = 0; j < 16; j += 1) {
    final o = offset + j * 4;
    w[j] = (bytes[o] << 24) | (bytes[o + 1] << 16) | (bytes[o + 2] << 8) | bytes[o + 3];
  }
}

/// One SHA-256 compression of the block in `w[0..15]` into [h] (FIPS 180-4 §6.2.2).
void _compressInto(Uint32List h, Uint32List w) {
  for (var j = 16; j < 64; j += 1) {
    final x = w[j - 15];
    final y = w[j - 2];
    final s0 = ((x >> 7) | (x << 25)) ^ ((x >> 18) | (x << 14)) ^ (x >> 3);
    final s1 = ((y >> 17) | (y << 15)) ^ ((y >> 19) | (y << 13)) ^ (y >> 10);
    w[j] = (w[j - 16] + s0 + w[j - 7] + s1) & _mask;
  }
  var a = h[0], b = h[1], c = h[2], d = h[3], e = h[4], f = h[5], g = h[6], hh = h[7];
  for (var j = 0; j < 64; j += 1) {
    final s1 = (((e >> 6) | (e << 26)) ^ ((e >> 11) | (e << 21)) ^ ((e >> 25) | (e << 7))) & _mask;
    final ch = (e & f) ^ (~e & _mask & g);
    final t1 = (hh + s1 + ch + _k[j] + w[j]) & _mask;
    final s0 = (((a >> 2) | (a << 30)) ^ ((a >> 13) | (a << 19)) ^ ((a >> 22) | (a << 10))) & _mask;
    final maj = (a & b) ^ (a & c) ^ (b & c);
    final t2 = (s0 + maj) & _mask;
    hh = g;
    g = f;
    f = e;
    e = (d + t1) & _mask;
    d = c;
    c = b;
    b = a;
    a = (t1 + t2) & _mask;
  }
  h[0] = (h[0] + a) & _mask;
  h[1] = (h[1] + b) & _mask;
  h[2] = (h[2] + c) & _mask;
  h[3] = (h[3] + d) & _mask;
  h[4] = (h[4] + e) & _mask;
  h[5] = (h[5] + f) & _mask;
  h[6] = (h[6] + g) & _mask;
  h[7] = (h[7] + hh) & _mask;
}

Uint32List _wordsOf(Uint8List bytes) {
  final w = Uint32List(bytes.length ~/ 4);
  _loadWordsN(w, bytes);
  return w;
}

void _loadWordsN(Uint32List w, Uint8List bytes) {
  for (var j = 0; j < w.length; j += 1) {
    final o = j * 4;
    w[j] = (bytes[o] << 24) | (bytes[o + 1] << 16) | (bytes[o + 2] << 8) | bytes[o + 3];
  }
}

Uint8List _bytesOf(Uint32List words) {
  final out = Uint8List(words.length * 4);
  for (var j = 0; j < words.length; j += 1) {
    final v = words[j];
    out[j * 4] = (v >> 24) & 0xff;
    out[j * 4 + 1] = (v >> 16) & 0xff;
    out[j * 4 + 2] = (v >> 8) & 0xff;
    out[j * 4 + 3] = v & 0xff;
  }
  return out;
}
