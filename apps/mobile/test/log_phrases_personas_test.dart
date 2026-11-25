// Tests for the persona phrase additions to "Say it in your words" (ADR-078, R7.1).
//
// Why it exists: the 73 personas write about period problems, trying to conceive,
// pregnancy, postpartum and menopause in their own words. Each group below proves that
// everyday sentences in the four languages reach the right chips, and that unrelated or
// denied sentences reach none, using the same `draftFromNote` the log screen calls.

import 'package:femio/domain/assistant/log_phrases.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  void expectTerms(String note, List<String> terms) {
    expect(draftFromNote(note).terms, containsAll(terms), reason: note);
  }

  group('period problems', () {
    test('English', () {
      expectTerms('my jawline breakouts are back and I feel faint', [
        'acne',
        'dizziness',
      ]);
      expectTerms('bleeding between periods again', ['spotting']);
    });
    test('Arabic', () {
      expectTerms('مغص من غير نزول دم وراسي بيلف', ['cramps', 'dizziness']);
      expectTerms('نزول دم بين الدورتين', ['spotting']);
    });
    test('French', () {
      expectTerms('saignements entre les regles et boutons sur la machoire', [
        'spotting',
        'acne',
      ]);
      expectTerms('douleur d ovulation hier', ['cramps']);
    });
    test('Spanish', () {
      expectTerms('sangrado entre reglas y granos en la espalda', [
        'spotting',
        'acne',
      ]);
      expectTerms('dolor de ovulacion', ['cramps']);
    });
  });

  group('trying to conceive', () {
    test('English', () {
      expectTerms('cramping after transfer and worried about the scan', [
        'cramps',
        'anxious',
      ]);
      expectTerms('stretchy clear mucus today', ['eggWhite']);
    });
    test('Arabic', () {
      expectTerms('مغص بعد النقل وقلقانه من الانتظار', ['cramps', 'anxious']);
      expectTerms('افرازات زي بياض البيض', ['eggWhite']);
    });
    test('French', () {
      expectTerms('angoissee par l attente et glaire elastique', [
        'anxious',
        'eggWhite',
      ]);
    });
    test('Spanish', () {
      expectTerms('preocupada por el tiempo y moco elastico', [
        'anxious',
        'eggWhite',
      ]);
    });
  });

  group('pregnancy', () {
    test('English', () {
      expectTerms('morning sickness and hip pain, up at 3am', [
        'nausea',
        'jointPain',
        'insomnia',
      ]);
      expectTerms('leak when i sneeze and peeing all the time', [
        'bladderLeaks',
        'bladderUrgency',
      ]);
    });
    test('Arabic', () {
      expectTerms('بستفرغ وبروح الحمام كل شويه', ['nausea', 'bladderUrgency']);
      expectTerms('بول بينزل لما اضحك', ['bladderLeaks']);
    });
    test('French', () {
      expectTerms('nausees matinales et fuites urinaires en riant', [
        'nausea',
        'bladderLeaks',
      ]);
    });
    test('Spanish', () {
      expectTerms('nauseas matutinas y dolor de cadera', [
        'nausea',
        'jointPain',
      ]);
    });
  });

  group('postpartum', () {
    test('English', () {
      expectTerms('postpartum hair loss, so weepy and cracked nipples', [
        'hairThinning',
        'tearfulness',
        'breastTenderness',
      ]);
      expectTerms('afterpains and broken sleep', ['cramps', 'insomnia']);
    });
    test('Arabic', () {
      expectTerms('شعري بيتساقط بعد الولاده وبعيط كل شويه', [
        'hairThinning',
        'tearfulness',
      ]);
      expectTerms('حلماتي بتوجعني ونومي متقطع', [
        'breastTenderness',
        'insomnia',
      ]);
    });
    test('French', () {
      expectTerms('perte de cheveux apres bebe et mamelons douloureux', [
        'hairThinning',
        'breastTenderness',
      ]);
    });
    test('Spanish', () {
      expectTerms('caida de cabello postparto y lloro por todo', [
        'hairThinning',
        'tearfulness',
      ]);
    });
  });

  group('menopause', () {
    test('English', () {
      expectTerms(
        'wake up drenched, pins and needles in hands, ringing in my ears',
        ['nightSweats', 'tingling', 'tinnitus'],
      );
      expectTerms('waves of heat and chemo brain', ['hotFlashes', 'brainFog']);
    });
    test('Arabic', () {
      expectTerms('بصحي غرقانه عرق وطنين في ودني', ['nightSweats', 'tinnitus']);
      expectTerms('موجات سخونيه وتنميل في ايدي', ['hotFlashes', 'tingling']);
    });
    test('French', () {
      expectTerms('chaleur soudaine et fourmillements dans les mains', [
        'hotFlashes',
        'tingling',
      ]);
    });
    test('Spanish', () {
      expectTerms('oleadas de calor y zumbido en los oidos', [
        'hotFlashes',
        'tinnitus',
      ]);
    });
  });

  group('no false matches', () {
    test('a denial is not logged', () {
      expect(
        draftFromNote('no pins and needles and no ringing in my ears').terms,
        isEmpty,
      );
    });
    test('ordinary talk about a baby and a scan is not a symptom', () {
      expect(
        draftFromNote('we saw the baby at the scan today and went for lunch')
            .isEmpty,
        isTrue,
      );
    });
    test('a sexual or contraception sentence stays tap-only', () {
      expect(
        draftFromNote('we had sex last night and I take the pill').isEmpty,
        isTrue,
      );
    });
  });
}
