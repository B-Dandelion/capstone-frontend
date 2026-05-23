class ParsedAddress {
  final String building;
  final String unit;

  const ParsedAddress({
    required this.building,
    required this.unit,
  });

  String get label => '${building}동 ${unit}호';
}

class AddressParser {
  static ParsedAddress? parse(String rawText) {
    final normalized = rawText
        .replaceAll('\n', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final patterns = <RegExp>[
      RegExp(r'(\d{2,4})\s*동\s*(\d{2,4})\s*호'),
      RegExp(r'(\d{3})\s*-\s*(\d{3,4})'),
      RegExp(r'(\d{3})\s+(\d{3,4})'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(normalized);
      if (match != null) {
        final building = match.group(1);
        final unit = match.group(2);

        if (building != null && unit != null) {
          return ParsedAddress(building: building, unit: unit);
        }
      }
    }

    return null;
  }
}