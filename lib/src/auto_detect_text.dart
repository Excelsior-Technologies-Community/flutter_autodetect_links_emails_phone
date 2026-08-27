import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'link_detector.dart';

class AutoDetectText extends StatelessWidget {
  const AutoDetectText(
    this.text, {
    super.key,
    this.style,
    this.linkStyle,
    this.emailStyle,
    this.phoneStyle,
    this.onUrlTap,
    this.onEmailTap,
    this.onPhoneTap,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  });

  final String text;

  final TextStyle? style;

  final TextStyle? linkStyle;
  final TextStyle? emailStyle;
  final TextStyle? phoneStyle;

  final ValueChanged<String>? onUrlTap;
  final ValueChanged<String>? onEmailTap;
  final ValueChanged<String>? onPhoneTap;

  final TextAlign textAlign;

  final int? maxLines;

  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    final links = LinkDetector.detect(text);

    if (links.isEmpty) {
      return Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    final spans = <TextSpan>[];

    int currentPosition = 0;

    for (final link in links) {
      if (link.start > currentPosition) {
        spans.add(
          TextSpan(
            text: text.substring(currentPosition, link.start),
            style: style,
          ),
        );
      }

      spans.add(
        TextSpan(
          text: link.text,
          style: _styleFor(link),
          recognizer: TapGestureRecognizer()..onTap = () => _handleTap(link),
        ),
      );

      currentPosition = link.end;
    }

    if (currentPosition < text.length) {
      spans.add(TextSpan(text: text.substring(currentPosition), style: style));
    }

    return Text.rich(
      TextSpan(children: spans),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle? _styleFor(DetectedLink link) {
    switch (link.type) {
      case DetectedLinkType.url:
        return linkStyle ?? _defaultLinkStyle;

      case DetectedLinkType.email:
        return emailStyle ?? _defaultEmailStyle;

      case DetectedLinkType.phone:
        return phoneStyle ?? _defaultPhoneStyle;
    }
  }

  TextStyle get _defaultLinkStyle {
    return const TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline,
    );
  }

  TextStyle get _defaultEmailStyle {
    return const TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline,
    );
  }

  TextStyle get _defaultPhoneStyle {
    return const TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline,
    );
  }

  void _handleTap(DetectedLink link) {
    switch (link.type) {
      case DetectedLinkType.url:
        onUrlTap?.call(link.text);
        break;

      case DetectedLinkType.email:
        onEmailTap?.call(link.text);
        break;

      case DetectedLinkType.phone:
        onPhoneTap?.call(link.text);
        break;
    }
  }
}
