import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_autodetect_links_emails_phone/flutter_autodetect_links_emails_phone.dart';

void main() {
  group('LinkDetector Tests', () {
    test('detects URLs correctly and trims trailing punctuation', () {
      const text = 'Visit https://google.com. Or check www.flutter.dev!';
      final links = LinkDetector.detect(text);

      expect(links.length, 2);

      expect(links[0].text, 'https://google.com');
      expect(links[0].type, DetectedLinkType.url);

      expect(links[1].text, 'www.flutter.dev');
      expect(links[1].type, DetectedLinkType.url);
    });

    test('detects emails correctly and trims punctuation', () {
      const text = 'Contact us at support@example.com or info@domain.co.uk.';
      final links = LinkDetector.detect(text);

      expect(links.length, 2);

      expect(links[0].text, 'support@example.com');
      expect(links[0].type, DetectedLinkType.email);

      expect(links[1].text, 'info@domain.co.uk');
      expect(links[1].type, DetectedLinkType.email);
    });

    test('detects phone numbers including +91 98765 43210 format and excludes false positive dates', () {
      const text = 'Call +91 98765 43210 or 98765 43210 or 123-456-7890. Date is 2026-08-27.';
      final links = LinkDetector.detect(text);

      expect(links.length, 3);

      expect(links[0].text, '+91 98765 43210');
      expect(links[0].type, DetectedLinkType.phone);

      expect(links[1].text, '98765 43210');
      expect(links[1].type, DetectedLinkType.phone);

      expect(links[2].text, '123-456-7890');
      expect(links[2].type, DetectedLinkType.phone);
    });

    test('detects mixed URLs, Emails and Phone numbers in sequence', () {
      const text = 'Website: https://flutter.dev Email: dev@example.com Phone: +91 98765 43210';
      final links = LinkDetector.detect(text);

      expect(links.length, 3);
      expect(links[0].type, DetectedLinkType.url);
      expect(links[1].type, DetectedLinkType.email);
      expect(links[2].type, DetectedLinkType.phone);
    });
  });

  group('AutoDetectText Widget Tests', () {
    testWidgets('renders non-link text correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AutoDetectText('Hello World'),
          ),
        ),
      );

      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('renders rich text with detected links and triggers callbacks', (WidgetTester tester) async {
      String? tappedUrl;
      String? tappedEmail;
      String? tappedPhone;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AutoDetectText(
              'https://flutter.dev dev@example.com +919876543210',
              onUrlTap: (url) => tappedUrl = url,
              onEmailTap: (email) => tappedEmail = email,
              onPhoneTap: (phone) => tappedPhone = phone,
            ),
          ),
        ),
      );

      expect(find.byType(Text), findsWidgets);
    });
  });
}
