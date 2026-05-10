// ignore_for_file: public_member_api_docs, document_ignores, lines_longer_than_80_chars

final _upperAlphaRegex = RegExp('[A-Z]');

const _symbolSet = {' ', '.', '/', '_', r'\', '-'};

List<String> _groupIntoWords(String text) {
  final sb = StringBuffer();
  final words = <String>[];
  final isAllCaps = text.toUpperCase() == text;

  for (var i = 0; i < text.length; i++) {
    final char = text[i];
    final nextChar = i + 1 == text.length ? null : text[i + 1];

    if (_symbolSet.contains(char)) {
      continue;
    }

    sb.write(char);

    final isEndOfWord = nextChar == null ||
        (_upperAlphaRegex.hasMatch(nextChar) && !isAllCaps) ||
        _symbolSet.contains(nextChar);

    if (isEndOfWord) {
      words.add(sb.toString());
      sb.clear();
    }
  }

  return words;
}

String _upperCaseFirstLetter(String word) {
  return '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCase()}';
}

extension StringReCaseExtension on String {
  /// camelCase
  String get camelCase {
    final words = _groupIntoWords(this).map(_upperCaseFirstLetter).toList();
    if (words.isNotEmpty) {
      words[0] = words[0].toLowerCase();
    }
    return words.join();
  }

  /// CONSTANT_CASE
  String get constantCase {
    return _groupIntoWords(this).map((word) => word.toUpperCase()).join('_');
  }

  /// Sentence case
  String get sentenceCase {
    final words = _groupIntoWords(this).map((word) => word.toLowerCase()).toList();
    if (words.isNotEmpty) {
      words[0] = _upperCaseFirstLetter(words[0]);
    }
    return words.join(' ');
  }

  /// snake_case
  String get snakeCase {
    return _groupIntoWords(this).map((word) => word.toLowerCase()).join('_');
  }

  /// dot.case
  String get dotCase {
    return _groupIntoWords(this).map((word) => word.toLowerCase()).join('.');
  }

  /// param-case
  String get paramCase {
    return _groupIntoWords(this).map((word) => word.toLowerCase()).join('-');
  }

  /// path/case
  String get pathCase {
    return _groupIntoWords(this).map((word) => word.toLowerCase()).join('/');
  }

  /// PascalCase
  String get pascalCase {
    return _groupIntoWords(this).map(_upperCaseFirstLetter).join();
  }

  /// Header-Case
  String get headerCase {
    return _groupIntoWords(this).map(_upperCaseFirstLetter).join('-');
  }

  /// Title Case
  String get titleCase {
    return _groupIntoWords(this).map(_upperCaseFirstLetter).join(' ');
  }
}
