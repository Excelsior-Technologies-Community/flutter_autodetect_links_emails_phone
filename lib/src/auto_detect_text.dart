import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'link_detector.dart';

class AutoDetectText extends StatefulWidget {
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
  State<AutoDetectText> createState() => _AutoDetectTextState();
}

class _AutoDetectTextState extends State<AutoDetectText> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    _clearRecognizers();
    super.dispose();
  }

  void _clearRecognizers() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();
  }

  @override
  Widget build(BuildContext context) {
    _clearRecognizers();

    final links = LinkDetector.detect(widget.text);

    if (links.isEmpty) {
      return Text(
        widget.text,
        style: widget.style,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
      );
    }

    final spans = <TextSpan>[];
    int currentPosition = 0;
    final defaultBaseStyle = widget.style ?? DefaultTextStyle.of(context).style;

    for (final link in links) {
      if (link.start > currentPosition) {
        spans.add(
          TextSpan(
            text: widget.text.substring(currentPosition, link.start),
            style: widget.style,
          ),
        );
      }

      final recognizer = TapGestureRecognizer()
        ..onTap = () => _handleTap(link);
      _recognizers.add(recognizer);

      final combinedLinkStyle = defaultBaseStyle.merge(_styleFor(link));

      spans.add(
        TextSpan(
          text: link.text,
          style: combinedLinkStyle,
          recognizer: recognizer,
        ),
      );

      currentPosition = link.end;
    }

    if (currentPosition < widget.text.length) {
      spans.add(
        TextSpan(
          text: widget.text.substring(currentPosition),
          style: widget.style,
        ),
      );
    }

    return Text.rich(
      TextSpan(children: spans),
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }

  TextStyle _styleFor(DetectedLink link) {
    switch (link.type) {
      case DetectedLinkType.url:
        return widget.linkStyle ?? _defaultLinkStyle;
      case DetectedLinkType.email:
        return widget.emailStyle ?? _defaultEmailStyle;
      case DetectedLinkType.phone:
        return widget.phoneStyle ?? _defaultPhoneStyle;
    }
  }

  static const _defaultLinkStyle = TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

  static const _defaultEmailStyle = TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

  static const _defaultPhoneStyle = TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

  void _handleTap(DetectedLink link) {
    switch (link.type) {
      case DetectedLinkType.url:
        widget.onUrlTap?.call(link.text);
        break;
      case DetectedLinkType.email:
        widget.onEmailTap?.call(link.text);
        break;
      case DetectedLinkType.phone:
        widget.onPhoneTap?.call(link.text);
        break;
    }
  }
}

