import 'package:flutter/material.dart';
import 'package:flutter_autodetect_links_emails_phone/flutter_autodetect_links_emails_phone.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auto Detect Links',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auto Detect Links')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: AutoDetectText(
          '''
Visit https://google.com

Our website is www.example.com

Email: hello@example.com

Call: +91 98765 43210

All detected values are automatically tappable.
''',
          style: const TextStyle(fontSize: 17, height: 1.7),
          linkStyle: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          emailStyle: const TextStyle(
            color: Colors.green,
            decoration: TextDecoration.underline,
          ),
          phoneStyle: const TextStyle(
            color: Colors.orange,
            decoration: TextDecoration.underline,
          ),
          onUrlTap: (url) {
            debugPrint('URL tapped: $url');
          },
          onEmailTap: (email) {
            debugPrint('Email tapped: $email');
          },
          onPhoneTap: (phone) {
            debugPrint('Phone tapped: $phone');
          },
        ),
      ),
    );
  }
}
