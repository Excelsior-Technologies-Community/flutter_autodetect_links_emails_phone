enum DetectedLinkType { url, email, phone }

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DetectedLink &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          type == other.type &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => text.hashCode ^ type.hashCode ^ start.hashCode ^ end.hashCode;
}

class LinkDetector {
  static final RegExp _urlRegex = RegExp(
    r'((?:https?:\/\/|www\.)[^\s<>{}\[\]"\\]+)',
    caseSensitive: false,
  );

  static final RegExp _emailRegex = RegExp(
    r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
    caseSensitive: false,
  );

  static final RegExp _phoneRegex = RegExp(
    r'(?:\+\d{1,4}[-.\s]*)?(?:\(\d{1,5}\)[-.\s]*)?\d+(?:[-.\s]\d+)*',
  );

  static List<DetectedLink> detect(String text) {
    if (text.isEmpty) return [];

    final rawMatches = <_RawMatch>[];

    // 1. Find URLs
    for (final match in _urlRegex.allMatches(text)) {
      final raw = match.group(0)!;
      final bounds = _cleanUrlBounds(raw, match.start);
      if (bounds.text.isNotEmpty) {
        rawMatches.add(_RawMatch(
          text: bounds.text,
          type: DetectedLinkType.url,
          start: bounds.start,
          end: bounds.end,
        ));
      }
    }

    // 2. Find Emails
    for (final match in _emailRegex.allMatches(text)) {
      final raw = match.group(0)!;
      final bounds = _trimBounds(raw, match.start);
      if (bounds.text.isNotEmpty) {
        rawMatches.add(_RawMatch(
          text: bounds.text,
          type: DetectedLinkType.email,
          start: bounds.start,
          end: bounds.end,
        ));
      }
    }

    // 3. Find Phone Numbers
    for (final match in _phoneRegex.allMatches(text)) {
      final raw = match.group(0)!;
      final digitCount = raw.replaceAll(RegExp(r'\D'), '').length;
      if (digitCount >= 7 && digitCount <= 15) {
        // Exclude ISO dates (e.g. 2026-08-27)
        if (RegExp(r'^\d{4}[-/.]\d{2}[-/.]\d{2}$').hasMatch(raw)) continue;
        // Exclude version strings (e.g. 1.0.0)
        if (raw.contains('.') && raw.split('.').any((part) => part.length == 1)) continue;

        final bounds = _trimBounds(raw, match.start);
        if (bounds.text.isNotEmpty) {
          rawMatches.add(_RawMatch(
            text: bounds.text,
            type: DetectedLinkType.phone,
            start: bounds.start,
            end: bounds.end,
          ));
        }
      }
    }

    rawMatches.sort((a, b) => a.start.compareTo(b.start));

    final results = <DetectedLink>[];
    int lastEnd = 0;

    for (final match in rawMatches) {
      if (match.start >= lastEnd) {
        results.add(DetectedLink(
          text: match.text,
          type: match.type,
          start: match.start,
          end: match.end,
        ));
        lastEnd = match.end;
      }
    }

    return results;
  }

  static _MatchBounds _cleanUrlBounds(String raw, int matchStart) {
    int endOffset = raw.length;
    while (endOffset > 0 && _isTrailingPunctuation(raw[endOffset - 1])) {
      final substring = raw.substring(0, endOffset);
      if (substring.endsWith(')') && _hasMatchingParen(substring)) break;
      endOffset--;
    }
    final text = raw.substring(0, endOffset);
    return _MatchBounds(text, matchStart, matchStart + endOffset);
  }

  static _MatchBounds _trimBounds(String raw, int matchStart) {
    int startOffset = 0;
    int endOffset = raw.length;

    while (startOffset < endOffset && _isPunctuationOrSpace(raw[startOffset])) {
      startOffset++;
    }

    while (endOffset > startOffset && _isPunctuationOrSpace(raw[endOffset - 1])) {
      endOffset--;
    }

    final text = raw.substring(startOffset, endOffset);
    return _MatchBounds(text, matchStart + startOffset, matchStart + endOffset);
  }

  static bool _isTrailingPunctuation(String char) {
    return char == '.' ||
        char == ',' ||
        char == '!' ||
        char == '?' ||
        char == ':' ||
        char == ';' ||
        char == ')' ||
        char == ']' ||
        char == '"' ||
        char == "'";
  }

  static bool _isPunctuationOrSpace(String char) {
    return char == ' ' ||
        char == '.' ||
        char == ',' ||
        char == '!' ||
        char == '?' ||
        char == ':' ||
        char == ';' ||
        char == ')' ||
        char == '(' ||
        char == ']' ||
        char == '[' ||
        char == '"' ||
        char == "'";
  }

  static bool _hasMatchingParen(String s) {
    int open = 0;
    for (int i = 0; i < s.length; i++) {
      if (s[i] == '(') open++;
      if (s[i] == ')') open--;
    }
    return open == 0;
  }
}

class _MatchBounds {
  final String text;
  final int start;
  final int end;

  _MatchBounds(this.text, this.start, this.end);
}

class _RawMatch {
  final String text;
  final DetectedLinkType type;
  final int start;
  final int end;

  _RawMatch({
    required this.text,
    required this.type,
    required this.start,
    required this.end,
  });
}


