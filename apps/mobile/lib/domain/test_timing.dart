// When a home pregnancy test is worth taking (MR-21, NHS "Doing a pregnancy test").
//
// Why it exists: testing before the period is missed is the common cause of a false
// negative, so the honest day is the first day of the missed period. With a predicted
// range, that is the end of the window. With irregular cycles no date can be named
// honestly, and the card gives general advice instead. Shared fixture:
// `fixtures/domain/test-timing.json` (twin: `apps/web/src/lib/calculators` test timing).

/// The first honest day for a home test, or null when cycles are irregular and no
/// day can be named. [windowEnd] is the last day of the predicted period window (ISO).
String? pregnancyTestDay({required String windowEnd, required bool irregular}) => irregular ? null : windowEnd;
