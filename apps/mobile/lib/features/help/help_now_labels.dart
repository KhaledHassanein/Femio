// Help now labels: the country name for a slug and the service name for a number id.
//
// Why it exists: `flutter gen-l10n` produces one getter per key and no lookup by name,
// and the Help now screen is data-driven (lib/domain/crisis_numbers.dart). This file is the
// bridge; it is written by the R6.17 generator from the website's list and must list every
// id in crisis_numbers.dart (crisis_numbers_test checks that no id falls through to itself).

import '../../domain/crisis_numbers.dart';
import '../../l10n/app_localizations.dart';

/// The display name of a country slug from `crisisCountries`.
String helpNowCountryName(L10n l, String slug) => switch (slug) {
      'egypt' => l.helpNowCountry_egypt,
      'saudi' => l.helpNowCountry_saudi,
      'uae' => l.helpNowCountry_uae,
      'qatar' => l.helpNowCountry_qatar,
      'kuwait' => l.helpNowCountry_kuwait,
      'bahrain' => l.helpNowCountry_bahrain,
      'oman' => l.helpNowCountry_oman,
      'jordan' => l.helpNowCountry_jordan,
      'lebanon' => l.helpNowCountry_lebanon,
      'morocco' => l.helpNowCountry_morocco,
      'uk' => l.helpNowCountry_uk,
      'france' => l.helpNowCountry_france,
      'spain' => l.helpNowCountry_spain,
      'usa' => l.helpNowCountry_usa,
      'canada' => l.helpNowCountry_canada,
      'mexico' => l.helpNowCountry_mexico,
      _ => slug,
    };

/// The service name for a [CrisisNumber.id].
String helpNowNumberLabel(L10n l, String id) => switch (id) {
      'eg_ambulance' => l.helpNowNumber_eg_ambulance,
      'eg_mental_health' => l.helpNowNumber_eg_mental_health,
      'eg_ncw' => l.helpNowNumber_eg_ncw,
      'sa_srca' => l.helpNowNumber_sa_srca,
      'sa_moh' => l.helpNowNumber_sa_moh,
      'sa_moh_mental' => l.helpNowNumber_sa_moh_mental,
      'sa_hrsd' => l.helpNowNumber_sa_hrsd,
      'ae_ambulance' => l.helpNowNumber_ae_ambulance,
      'qa_emergency' => l.helpNowNumber_qa_emergency,
      'qa_mental' => l.helpNowNumber_qa_mental,
      'kw_emergency' => l.helpNowNumber_kw_emergency,
      'bh_emergency' => l.helpNowNumber_bh_emergency,
      'om_emergency' => l.helpNowNumber_om_emergency,
      'om_dv' => l.helpNowNumber_om_dv,
      'jo_emergency' => l.helpNowNumber_jo_emergency,
      'jo_ambulance' => l.helpNowNumber_jo_ambulance,
      'jo_family' => l.helpNowNumber_jo_family,
      'lb_redcross' => l.helpNowNumber_lb_redcross,
      'lb_lifeline' => l.helpNowNumber_lb_lifeline,
      'ma_samu' => l.helpNowNumber_ma_samu,
      'ma_police' => l.helpNowNumber_ma_police,
      'gb_999' => l.helpNowNumber_gb_999,
      'gb_111' => l.helpNowNumber_gb_111,
      'gb_refuge' => l.helpNowNumber_gb_refuge,
      'fr_samu' => l.helpNowNumber_fr_samu,
      'fr_3114' => l.helpNowNumber_fr_3114,
      'fr_3919' => l.helpNowNumber_fr_3919,
      'es_112' => l.helpNowNumber_es_112,
      'es_024' => l.helpNowNumber_es_024,
      'es_016' => l.helpNowNumber_es_016,
      'us_911' => l.helpNowNumber_us_911,
      'us_988' => l.helpNowNumber_us_988,
      'us_ndvh' => l.helpNowNumber_us_ndvh,
      'ca_911' => l.helpNowNumber_ca_911,
      'ca_988' => l.helpNowNumber_ca_988,
      'mx_911' => l.helpNowNumber_mx_911,
      'mx_vida' => l.helpNowNumber_mx_vida,
      _ => id,
    };
