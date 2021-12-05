import 'package:gematria/gematria.dart';

main() {
  final gm = Gematria(
    limit: 0,        // default
    order: false,    // default
    geresh: true,    // default
    punctuate: true, // default
  );

  final output = [
    gm.gematria(5774), // התשע״ד - ordinary
    gm.gematria(5774, limit: 3), // תשע״ד - cropped to 774
    gm.gematria(5774, limit: 7), // התשע״ד - kept at 5774
    gm.gematria(5774, punctuate: false), // 'התשעד' - removed quotation marks
    gm.gematria(5774, punctuate: true), // 'התשע״ד' - with quotation marks
    gm.gematria(5774, geresh: false), // 'התשע"ד' - with quotation marks
    gm.gematria(5774, punctuate: false, limit: 3), // 'תשעד' - options can be combined
    gm.gematria(3), // 'ג׳' - with the geresh
    gm.gematria(3, geresh: false), // - "ג'" - with the apostrophe
    gm.gematria('התשעד', order: true), // 5774 - treats the characters as an ordered number
    gm.gematria('התשעד', order: false), // 779 - Adds up all the characters
  ];

  print(output);
}
