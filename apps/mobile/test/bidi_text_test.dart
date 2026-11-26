// The direction rules for text she types (bidi_text.dart).
import 'package:femio/domain/bidi_text.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('numbers and Latin read left to right; Arabic right to left; blank follows the screen', () {
    expect(directionOfText('0.4 - 4.0', TextDirection.rtl), TextDirection.ltr);
    expect(directionOfText('400 mcg', TextDirection.rtl), TextDirection.ltr);
    expect(directionOfText('حمض الفوليك', TextDirection.ltr), TextDirection.rtl);
    expect(directionOfText('  ', TextDirection.rtl), TextDirection.rtl);
  });

  test('isolated text keeps its content and leaves empty text empty', () {
    expect(isolateText(''), '');
    expect(isolateText('0.4 - 4.0'), '\u20680.4 - 4.0\u2069');
  });
}
