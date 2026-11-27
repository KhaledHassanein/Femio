// Cloud boost consent receipts (ADR-080): specific per purpose, dated, versioned, withdrawable,
// and never carried to a new phone by a restored backup.

import 'package:flutter_test/flutter_test.dart';

import 'package:femio/data/backup.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/domain/assistant/cloud_consent.dart';

void main() {
  const at = '2026-11-24T10:00:00Z';

  group('sealed receipts (owner 2026-11-27)', () {
    test('a wizard choice records the AI switch, the purposes and the ticked statements', () {
      final c = const CloudConsent().choose(
        ai: true,
        purposes: {CloudPurpose.questions},
        at: at,
        lang: 'ar',
        acks: const [AiAck.wellness, AiAck.notice, AiAck.cloud],
      );
      final e = c.current!;
      expect(e.ai, isTrue);
      expect(e.acks, [AiAck.wellness, AiAck.notice, AiAck.cloud]);
      expect(c.allows(CloudPurpose.questions), isTrue);
      expect(e.seal, hasLength(64));
      expect(e.prev, isNull);
      expect(c.sealIntact, isTrue);
    });

    test('each receipt names the seal before it, and survives a save and load', () {
      final c = const CloudConsent()
          .choose(ai: true, purposes: const {}, at: at, acks: const [AiAck.wellness, AiAck.notice])
          .choose(ai: false, purposes: const {}, at: '2026-11-25T08:00:00Z');
      expect(c.log[1].prev, c.log[0].seal);
      final back = CloudConsent.fromJson(c.toJson());
      expect(back.sealIntact, isTrue);
      expect(back.log[1].seal, c.log[1].seal);
      expect(back.current!.ai, isFalse);
    });

    test('an edited receipt no longer matches its seal', () {
      final c = const CloudConsent().choose(ai: true, purposes: const {CloudPurpose.tips}, at: at, acks: const [AiAck.cloud]);
      final json = (c.toJson()! as List).cast<Map<String, Object?>>();
      final edited = [
        {...json.single, 'purposes': ['questions', 'tips']},
      ];
      expect(CloudConsent.fromJson(edited).sealIntact, isFalse);
    });

    test('a receipt removed from the middle breaks the chain', () {
      var c = const CloudConsent();
      for (var i = 0; i < 3; i += 1) {
        c = c.choose(ai: i.isEven, purposes: const {}, at: '2026-11-2${i}T08:00:00Z');
      }
      final json = (c.toJson()! as List).cast<Map<String, Object?>>();
      expect(CloudConsent.fromJson([json[0], json[2]]).sealIntact, isFalse);
    });

    test('receipts written before seals existed still read, and the chain starts after them', () {
      final old = CloudConsent.fromJson([
        {'purposes': ['questions'], 'at': at, 'version': 2, 'lang': 'en'},
      ]);
      final c = old.choose(ai: true, purposes: const {}, at: '2026-11-27T09:00:00Z');
      expect(c.log.first.seal, isNull);
      expect(c.log.last.prev, isNull);
      expect(c.sealIntact, isTrue);
    });

    test('the oldest receipts drop off at the limit and the chain still checks', () {
      var c = const CloudConsent();
      for (var i = 0; i < cloudConsentLogLimit + 5; i += 1) {
        c = c.choose(ai: true, purposes: const {}, at: '2026-11-27T09:00:${(i % 60).toString().padLeft(2, '0')}Z');
      }
      expect(c.log, hasLength(cloudConsentLogLimit));
      expect(c.log.first.prev, isNotNull, reason: 'the first kept receipt still names the one before it');
      expect(CloudConsent.fromJson(c.toJson()).sealIntact, isTrue);
    });
  });

  test('no choice means nothing is allowed', () {
    const c = CloudConsent();
    expect(c.any, isFalse);
    expect(c.grantedAt, isNull);
  });

  test('each purpose is agreed to separately, with a dated, versioned receipt', () {
    final c = const CloudConsent().grant({CloudPurpose.tips}, at);
    expect(c.allows(CloudPurpose.tips), isTrue);
    expect(c.allows(CloudPurpose.questions), isFalse);
    expect(c.grantedAt, at);
    expect(c.current!.version, cloudConsentVersion);
  });

  test('a withdrawal is recorded and allows nothing', () {
    final c = const CloudConsent().grant(CloudPurpose.values.toSet(), at).withdraw('2026-11-25T08:00:00Z');
    expect(c.any, isFalse);
    expect(c.log, hasLength(2));
    expect(c.current!.isWithdrawal, isTrue);
  });

  test('consent given on older wording lapses', () {
    final old = CloudConsent.fromJson([
      {'purposes': ['questions', 'tips'], 'at': at, 'version': cloudConsentVersion - 1},
    ]);
    expect(old.any, isFalse);
  });

  test('a consent given on the version 1 text (which promised names were removed) lapses', () {
    // Version 2 corrected the redaction sentence (PRIV-1); version 3 is the one AI wizard. Each
    // time she must agree again to the new text.
    expect(cloudConsentVersion, 3);
    final v1 = CloudConsent.fromJson([
      {'purposes': ['questions', 'tips'], 'at': at, 'version': 1},
    ]);
    expect(v1.allows(CloudPurpose.questions), isFalse);
    expect(v1.allows(CloudPurpose.tips), isFalse);
    expect(v1.log, hasLength(1), reason: 'the old receipt is kept as history, it just no longer counts');
  });

  test('the receipt records the language the consent text was shown in', () {
    final c = const CloudConsent().grant({CloudPurpose.questions}, at, lang: 'ar');
    expect(c.current!.lang, 'ar');
    expect(c.current!.toJson()['lang'], 'ar');
    final back = AppSettings.fromJson(AppSettings(cloud: c).toJson()).cloud;
    expect(back.current!.lang, 'ar');
    expect(back.allows(CloudPurpose.questions), isTrue);
    final off = c.withdraw('2026-11-25T08:00:00Z', lang: 'fr');
    expect(off.current!.lang, 'fr');
  });

  test('receipts written before the language field still parse; a bad language is unknown', () {
    final old = CloudConsent.fromJson([
      {'purposes': ['tips'], 'at': at, 'version': cloudConsentVersion},
    ]);
    expect(old.allows(CloudPurpose.tips), isTrue);
    expect(old.current!.lang, isNull);
    expect(old.current!.toJson().containsKey('lang'), isFalse);
    final odd = CloudConsent.fromJson([
      {'purposes': ['tips'], 'at': at, 'version': cloudConsentVersion, 'lang': 7},
    ]);
    expect(odd.allows(CloudPurpose.tips), isTrue);
    expect(odd.current!.lang, isNull);
  });

  test('a damaged log can only mean no consent', () {
    expect(CloudConsent.fromJson('yes').any, isFalse);
    expect(CloudConsent.fromJson([{'purposes': 'tips', 'at': at, 'version': 1}]).any, isFalse);
    expect(CloudConsent.fromJson(null).any, isFalse);
  });

  test('the bare cloudBoost flag of the hackathon build is not consent', () {
    expect(AppSettings.fromJson({'cloudBoost': true}).cloudBoost, isFalse);
  });

  test('receipts round-trip through the record and the log stays bounded', () {
    var c = const CloudConsent();
    for (var i = 0; i < cloudConsentLogLimit + 5; i++) {
      c = i.isEven ? c.grant({CloudPurpose.questions}, at) : c.withdraw(at);
    }
    expect(c.log, hasLength(cloudConsentLogLimit));
    final back = AppSettings.fromJson(AppSettings(cloud: c).toJson()).cloud;
    expect(back.log, hasLength(cloudConsentLogLimit));
    expect(back.any, c.any);
  });

  test('a restored backup keeps the receipts but asks again', () async {
    final consent = const CloudConsent().grant(CloudPurpose.values.toSet(), at);
    final profile = Profile.fromJson(migrateRecord({'v': 2, 'goal': 'ttc', 'settings': AppSettings(cloud: consent).toJson()}));
    final bytes = await encodeBackup(profile, 'correct horse');
    final restored = await decodeBackup(bytes, 'correct horse');
    expect(restored.settings.cloud.any, isFalse);
    expect(restored.settings.cloud.log.first.at, at);
    expect(restored.settings.cloud.current!.isWithdrawal, isTrue);
  });
}
