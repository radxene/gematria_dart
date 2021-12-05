import 'package:gematria/gematria.dart';
import 'package:test/test.dart';

void main() {
  group('Gematria:', () {
    final gm = Gematria();

    test('Ordinary results', () {
      expect(gm.gematria(5774), 'התשע״ד');
    });

    test('Cropped to 774', () {
      expect(gm.gematria(5774, limit: 3), 'תשע״ד');
    });

    test('Kept at 5774', () {
      expect(gm.gematria(5774, limit: 7), 'התשע״ד');
    });

    test('Removed quotation marks', () {
      expect(gm.gematria(5774, punctuate: false), 'התשעד');
    });

    test('With quotation marks', () {
      expect(gm.gematria(5774, punctuate: true), 'התשע״ד');
    });

    test('Combined multiple options', () {
      expect(gm.gematria(5774, punctuate: false, limit: 3), 'תשעד');
    });

    test('Cantillation mark - geresh', () {
      if (gm.geresh) {
        expect(gm.gematria(3), 'ג׳');
      }
      expect(gm.gematria(3, geresh: true), 'ג׳');
    });

    test('Cantillation mark - apostrophe', () {
      expect(gm.gematria(3, geresh: false), "ג'");
    });

    test('Treats the characters as an ordered number', () {
      expect(gm.gematria('התשעד', order: true), 5774);
    });

    test('Adds up all the characters', () {
      expect(gm.gematria('התשעד', order: false), 779);
    });
  });
}
