enum DetectedLinkType {
  url,
  email,
  phone,
}

class DetectedLink {
  const DetectedLink({
    required this.text,
    required this.type,
    required this.start,
    required this.end,
  });

  final String text;
  final DetectedLinkType type;
  final int start;
  final int end;
}

class LinkDetector {
  static final RegExp _pattern = RegExp(
    r'(https?:\/\/[^\s]+|www\.[^\s]+|'
    r'[\w.+-]+@[\w-]+\.[\w.-]+|'
    r'\+?\d[\d\s().-]{7,}\d)',
    caseSensitive: false,
  );

  static List<DetectedLink> detect(String text) {
    final matches = _pattern.allMatches(text);

    final results = <DetectedLink>[];

    for (final match in matches) {
      final value = match.group(0);

      if (value == null || value.isEmpty) {
        continue;
      }

      final type = _detectType(value);

      results.add(
        DetectedLink(
          text: value,
          type: type,
          start: match.start,
          end: match.end,
        ),
      );
    }

    return results;
  }

  static DetectedLinkType _detectType(String value) {
    if (value.startsWith('http://') ||
        value.startsWith('https://') ||
        value.startsWith('www.')) {
      return DetectedLinkType.url;
    }

    if (value.contains('@')) {
      return DetectedLinkType.email;
    }

    return DetectedLinkType.phone;
  }
}