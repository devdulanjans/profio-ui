import 'package:flutter/material.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final List<Map<String, String>> faqs = [
    {
      'question': 'How do I create a business card?',
      'answer':
      'To create a business card, go to your profile, tap “Create Card”, and fill out your business details.'
    },
    {
      'question': 'Can I share my card with non-app users?',
      'answer':
      'Yes, you can share your digital business card via QR code or a shareable link.'
    },
    {
      'question': 'What languages are supported?',
      'answer':
      'Currently, the app supports English, Spanish, and French. More languages will be added soon.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search FAQs...',
              hintStyle: const TextStyle(color: Colors.black),
              prefixIcon: const Icon(Icons.search, color: Colors.black),
              filled: true,
              fillColor: const Color(0xFFFFFFFF),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 24),

          const Text(
            'Frequently asked questions..',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // FAQ Section
          ...faqs.map((faq) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
              ),
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.black,
                title: Text(
                  faq['question']!,
                  style: const TextStyle(color: Colors.black),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      faq['answer']!,
                      style:
                      const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          const SizedBox(height: 24),

          const Text(
            'Contact Us',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.email, color: Colors.greenAccent),
              ),
              title: const Text(
                'Email Support',
                style: TextStyle(color: Colors.black),
              ),
              subtitle: const Text(
                'support@profio.app',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                // You can add your email intent or support action here
              },
            ),
          ),
        ],
      ),
    );
  }
}
