// Which pregnancy tool comes first, and from which week (MR-31, A-06).
//
// Why it exists: "the contraction timer is listed first from week 36" is a medical
// rule (ADR-070), not a layout choice, so it lives here with a fixture shared with
// the website (`fixtures/domain/pregnancy-tools.json`) and never inside a widget.
// Every tool is always listed (rule 2: emphasis changes, access does not).

/// From this week the contraction timer is listed before the movement log (MR-31).
const contractionsFirstFromWeek = 36;

/// The pregnancy tools, by stable id, in the order Today lists them. [weeks] is the
/// current gestational week, or null while the due date is unknown (default order).
List<String> pregnancyToolOrder(int? weeks) {
  final late = weeks != null && weeks >= contractionsFirstFromWeek;
  return [if (late) 'contractions', 'movements', if (!late) 'contractions', 'appointments', 'weight'];
}
