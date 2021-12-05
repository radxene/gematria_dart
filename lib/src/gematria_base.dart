import 'dart:math' as math;

/// gematria for Dart
/// Author: Radu Ene
/// Released under MIT License.
///
class Gematria {
  static final Map<String, int> numbers = _makeGematriaNumbers();

  static final Map<int, String> letters = {
    for (var e in numbers.entries) e.value: e.key
  };

  int limit;
  bool order;
  bool geresh;
  bool punctuate;

  bool _isStrNumber = false;

  List<String> _parts = [];

  Gematria({
    this.limit = 0,
    this.order = false,
    this.geresh = true,
    this.punctuate = true,
  });

  Object gematria(
    Object number, {
    int? limit,
    bool? order,
    bool? geresh,
    bool? punctuate,
  }) {
    final numberType = number.runtimeType;

    if (numberType == int || numberType == String) {
      final opts = [this.limit, this.order, this.geresh, this.punctuate];

      this.limit = limit ?? this.limit;
      this.order = order ?? this.order;
      this.geresh = geresh ?? this.geresh;
      this.punctuate = punctuate ?? this.punctuate;

      _parts = number.toString().split('').reversed.toList();

      switch (numberType) {
        case int:
          return _fromInt(() => _resetOptions(opts));
        case String:
          return _fromString(() => _resetOptions(opts));
      }
    }
    return '';
  }

  String _fromInt(void Function() callback) {
    _isStrNumber = false;

    if (limit != 0) {
      _parts = _parts.sublist(0, math.min(limit, _parts.length));
    }

    var objList = _parts.asMap().entries.map(_applyGematria).toList();

    objList = objList.reversed
        .join('')
        .replaceAll(RegExp(r'יה'), 'טו')
        .replaceAll(RegExp(r'יו'), 'טז')
        .split('')
        .toList();

    if (punctuate) {
      if (objList.length == 1) {
        objList.add(geresh ? '׳' : "'");
      } else if (objList.length > 1) {
        objList.insert(objList.length - 1, geresh ? '״' : '"');
      }
    }

    callback();

    return objList.join('');
  }

  int _fromString(void Function() callback) {
    _isStrNumber = true;
    _parts.removeWhere((item) => ['"', "'"].contains(item));

    var objList = _parts.asMap().entries.map(_applyGematria).toList();

    callback();

    return objList.reduce((val, elem) {
      return int.parse(val.toString()) + int.parse(elem.toString());
    }) as int;
  }

  Object _applyGematria(MapEntry<int, String> entry) {
    if (_isStrNumber) {
      final curNum = numbers[entry.value] ?? 0;
      if (order) {
        final prevPart = _parts[entry.key > 0 ? entry.key - 1 : 0];
        final prevNum = numbers[prevPart] ?? 0;
        if (curNum < prevNum && curNum < 100) return curNum * 1000;
      }
      return curNum;
    } else {
      final powNum = int.parse(entry.value) * math.pow(10, entry.key);
      if (powNum > 1000) {
        return _applyGematria(MapEntry(entry.key - 3, entry.value));
      }
      return letters[powNum] ?? 0;
    }
  }

  void _resetOptions(List<Object> opts) {
    limit = opts[0] as int;
    order = opts[1] as bool;
    geresh = opts[2] as bool;
    punctuate = opts[3] as bool;
  }
}

Map<String, int> _makeGematriaNumbers() {
  final keys = ['א', 'ב', 'ג', 'ד', 'ה', 'ו', 'ז', 'ח', 'ט', 'י', 'כ', 'ל', 'מ', 'נ', 'ס', 'ע', 'פ', 'צ', 'ק', 'ר', 'ש', 'ת', 'תק', 'תר', 'תש', 'תת', 'תתק', 'תתר'];
  final values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000];

  Map<String, int> numbers = {'': 0};
  numbers.addAll({ for (var e in keys.asMap().entries) e.value: values[e.key] });

  return numbers;
}
