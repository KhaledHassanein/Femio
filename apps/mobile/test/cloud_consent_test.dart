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
