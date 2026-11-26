// Cloud boost consent receipts (ADR-080): specific per purpose, dated, versioned, withdrawable,
// and never carried to a new phone by a restored backup.

import 'package:flutter_test/flutter_test.dart';

import 'package:femio/data/backup.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/domain/assistant/cloud_consent.dart';

void main() {
  const at = '2026-11-24T10:00:00Z';

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
    // Version 2 corrected the redaction sentence (PRIV-1); she must agree again to the new text.
    expect(cloudConsentVersion, 2);
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
