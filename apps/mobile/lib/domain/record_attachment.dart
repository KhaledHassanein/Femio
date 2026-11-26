// A document or photo she attached to her health record (R11.2, ADR-082 §2).
//
// Why it exists: the record keeps only what describes the file (its id, her name for it, its
// type, its size and when she added it); the bytes live in their own sealed file, named by
// the random id, never by her file name. Keeping the description here, free of any storage
// or UI code, lets the record, the backup and the screens agree on one shape and one set of
// limits.

/// The largest file she can attach: 10 MB (ADR-082 §2).
const maxAttachmentBytes = 10 * 1024 * 1024;

/// The most document bytes one backup file carries: 100 MB (ADR-082 §2).
const maxBackupAttachmentBytes = 100 * 1024 * 1024;

/// The longest name she can give a document, in characters.
const maxAttachmentNameLength = 80;

/// The file types femio accepts: PDF and the photo formats a phone camera or gallery gives.
const attachmentMimeTypes = {
  'pdf': 'application/pdf',
  'jpg': 'image/jpeg',
  'jpeg': 'image/jpeg',
  'png': 'image/png',
  'webp': 'image/webp',
};

/// The MIME type for a file called [fileName], or null when femio does not accept it.
String? attachmentMimeFor(String fileName) {
  final dot = fileName.lastIndexOf('.');
  if (dot < 0) return null;
  return attachmentMimeTypes[fileName.substring(dot + 1).toLowerCase()];
}

/// One attached document: everything about it except its bytes.
class RecordAttachment {
  const RecordAttachment({
    required this.id,
    required this.name,
    required this.mime,
    required this.sizeBytes,
    required this.addedOn,
  });

  /// Random id; also the name of the sealed file that holds the bytes.
  final String id;

  /// Her name for it (the picked file's name, or one she typed). Shown, never used on disk.
  final String name;

  /// One of [attachmentMimeTypes]' values.
  final String mime;

  /// Size of the plain file in bytes.
  final int sizeBytes;

  /// When she added it, as a local ISO timestamp.
  final String addedOn;

  /// True for a photo; false for a PDF.
  bool get isImage => mime.startsWith('image/');

  /// True for a PDF.
  bool get isPdf => mime == 'application/pdf';

  /// A copy with a new name, trimmed and cut to [maxAttachmentNameLength]. A blank name keeps
  /// the old one.
  RecordAttachment renamed(String newName) {
    final clean = newName.trim();
    if (clean.isEmpty) return this;
    final cut = clean.length > maxAttachmentNameLength ? clean.substring(0, maxAttachmentNameLength) : clean;
    return RecordAttachment(id: id, name: cut, mime: mime, sizeBytes: sizeBytes, addedOn: addedOn);
  }

  Map<String, Object?> toJson() => {'id': id, 'name': name, 'mime': mime, 'size': sizeBytes, 'addedOn': addedOn};

  /// Reads one description. Throws [FormatException] when the id, type or size is missing,
  /// because a description that cannot find its file must not be shown as if it could.
  static RecordAttachment fromJson(Map<String, Object?> j) {
    final id = j['id'];
    final mime = j['mime'];
    final size = j['size'];
    if (id is! String || id.isEmpty || mime is! String || size is! int) {
      throw const FormatException('attachment needs an id, a type and a size');
    }
    return RecordAttachment(
      id: id,
      name: (j['name'] as String?) ?? '',
      mime: mime,
      sizeBytes: size,
      addedOn: (j['addedOn'] as String?) ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      other is RecordAttachment &&
      other.id == id &&
      other.name == name &&
      other.mime == mime &&
      other.sizeBytes == sizeBytes &&
      other.addedOn == addedOn;

  @override
  int get hashCode => Object.hash(id, name, mime, sizeBytes, addedOn);
}
