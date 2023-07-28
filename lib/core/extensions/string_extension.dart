extension StringExtension on String {
  String get capitalized => length > 1
      ? "${this[0].toUpperCase()}${substring(1).toLowerCase()}"
      : length == 1
          ? toUpperCase()
          : this;

  String get firstUpper => length > 1
      ? "${this[0].toUpperCase()}${substring(1)}"
      : length == 1
          ? toUpperCase()
          : this;

  String get titleCased => splitMapJoin(RegExp(r' +'),
      onMatch: (_) => ' ', onNonMatch: (sub) => sub.capitalized);

  String get sentenceCased => splitMapJoin(
        RegExp(r'\. +|\n +'),
        onMatch: (p0) => p0.group(0)!,
        onNonMatch: (sub) => sub.firstUpper,
      );
}
