import 'package:flutter/material.dart';
import 'package:flutter_autodetect_links_emails_phone/flutter_autodetect_links_emails_phone.dart';

void main() {
  runApp(const AutoDetectLinksExample());
}

class AutoDetectLinksExample extends StatelessWidget {
  const AutoDetectLinksExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auto Detect Links',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showMessage(BuildContext context,
      String title,
      String value,) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title: $value'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            const Text(
              'Auto Detect Links',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'URLs, emails and phone numbers are automatically detected and made tappable.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              '1. Basic Detection',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            const AutoDetectText(
              'Visit https://google.com or www.example.com '
                  'for more information. '
                  'You can also contact hello@example.com '
                  'or call +91 98765 43210.',
              style: TextStyle(
                fontSize: 17,
                height: 1.7,
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              '2. Callbacks',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            AutoDetectText(
              'Website: https://example.com\n'
                  'Email: support@example.com\n'
                  'Phone: +91 98765 43210',
              style: const TextStyle(
                fontSize: 17,
                height: 1.8,
              ),
              onUrlTap: (url) {
                _showMessage(
                  context,
                  'URL tapped',
                  url,
                );
              },
              onEmailTap: (email) {
                _showMessage(
                  context,
                  'Email tapped',
                  email,
                );
              },
              onPhoneTap: (phone) {
                _showMessage(
                  context,
                  'Phone tapped',
                  phone,
                );
              },
            ),

            const SizedBox(height: 32),

            const Text(
              '3. Custom Styles',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            AutoDetectText(
              'Website: https://flutter.dev\n'
                  'Email: developer@example.com\n'
                  'Phone: +91 98765 43210',
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black87,
                height: 1.8,
              ),
              linkStyle: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              emailStyle: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              phoneStyle: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              onUrlTap: (url) {
                _showMessage(
                  context,
                  'Website',
                  url,
                );
              },
              onEmailTap: (email) {
                _showMessage(
                  context,
                  'Email',
                  email,
                );
              },
              onPhoneTap: (phone) {
                _showMessage(
                  context,
                  'Phone',
                  phone,
                );
              },
            ),

            const SizedBox(height: 32),

            // --------------------------------------------------
            // MULTIPLE LINKS
            // --------------------------------------------------

            const Text(
              '4. Multiple Values',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            AutoDetectText(
              'Useful websites: https://google.com, '
                  'https://flutter.dev and www.github.com.\n\n'
                  'Emails: one@example.com, two@example.com.\n\n'
                  'Phones: +91 98765 43210 and +91 99999 88888.',
              style: const TextStyle(
                fontSize: 16,
                height: 1.8,
              ),
              linkStyle: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              emailStyle: const TextStyle(
                color: Colors.green,
                decoration: TextDecoration.underline,
              ),
              phoneStyle: const TextStyle(
                color: Colors.deepOrange,
                decoration: TextDecoration.underline,
              ),
              onUrlTap: (url) {
                debugPrint('URL: $url');
              },
              onEmailTap: (email) {
                debugPrint('Email: $email');
              },
              onPhoneTap: (phone) {
                debugPrint('Phone: $phone');
              },
            ),

            const SizedBox(height: 32),

            // --------------------------------------------------
            // LONG TEXT
            // --------------------------------------------------

            const Text(
              '5. Long Text',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            const AutoDetectText(
              'Flutter is a UI toolkit for building beautiful '
                  'applications. Visit https://flutter.dev to learn '
                  'more. If you need help, send an email to '
                  'help@example.com or call +91 98765 43210. '
                  'You can also visit www.example.com for additional '
                  'information.',
              style: TextStyle(
                fontSize: 16,
                height: 1.7,
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              '6. Normal Text',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            const AutoDetectText(
              'This text contains no links, emails or phone numbers.',
              style: TextStyle(
                fontSize: 16,
                height: 1.7,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}