class ParsedAddress {
  final String? building;
  final String unit;

  const ParsedAddress({
    this.building,
    required this.unit,
  });

  String get label {
    if (building != null && building!.isNotEmpty) {
      return '${building}동 ${unit}호';
    }
    return '${unit}호';
  }

  bool get hasBuilding => building != null && building!.isNotEmpty;
}

class AddressParser {
  static ParsedAddress? parse(
      String rawText, {
        String? defaultBuilding,
      }) {
    final lines = rawText
        .split(RegExp(r'[\r\n]+'))
        .map(_normalizeLine)
        .where((line) => line.isNotEmpty)
        .toList();

    // 1순위: "108동 523호"
    for (final line in lines) {
      if (_isNoiseLine(line)) continue;

      final match = RegExp(
        r'(?<!\d)(\d{2,4})\s*동\s*(\d{2,4})\s*호(?!\d)',
      ).firstMatch(line);

      if (match != null) {
        return ParsedAddress(
          building: match.group(1)!,
          unit: match.group(2)!,
        );
      }
    }

    // 2순위: "523호"만 있는 경우
    for (final line in lines) {
      if (_isNoiseLine(line)) continue;

      final match = RegExp(
        r'(?<!\d)(\d{2,4})\s*호(?!\d)',
      ).firstMatch(line);

      if (match != null) {
        return ParsedAddress(
          building: defaultBuilding,
          unit: match.group(1)!,
        );
      }
    }

    // 3순위: "108-523", "108 523" 같은 느슨한 형식
    if (_hasAddressContext(rawText)) {
      for (final line in lines) {
        if (_isNoiseLine(line)) continue;

        final dashMatch = RegExp(
          r'(?<!\d)(\d{2,4})\s*-\s*(\d{2,4})(?!\d)',
        ).firstMatch(line);

        if (dashMatch != null) {
          return ParsedAddress(
            building: dashMatch.group(1)!,
            unit: dashMatch.group(2)!,
          );
        }

        final spaceMatch = RegExp(
          r'(?<!\d)(\d{2,4})\s+(\d{2,4})(?!\d)',
        ).firstMatch(line);

        if (spaceMatch != null) {
          return ParsedAddress(
            building: spaceMatch.group(1)!,
            unit: spaceMatch.group(2)!,
          );
        }
      }
    }

    return null;
  }

  static String _normalizeLine(String input) {
    return input.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static bool _isNoiseLine(String line) {
    final lower = line.toLowerCase();

    const blockedKeywords = [
      '운송장',
      '운송장번호',
      '송장',
      '송장번호',
      'tracking',
      'invoice',
      '주문번호',
      'barcode',
      '바코드',
    ];

    if (blockedKeywords.any(lower.contains)) {
      return true;
    }

    // 긴 숫자열 제외
    if (RegExp(r'\d{8,}').hasMatch(line)) {
      return true;
    }

    return false;
  }

  static bool _hasAddressContext(String rawText) {
    const addressKeywords = [
      '주소',
      '배송지',
      '상세주소',
      '받는 곳',
      '수취인 주소',
      'recipient address',
      'address',
    ];

    final lower = rawText.toLowerCase();
    return addressKeywords.any(lower.contains);
  }
}