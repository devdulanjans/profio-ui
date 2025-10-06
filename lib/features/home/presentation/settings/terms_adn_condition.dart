import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''
Our Privacy Policy explains how we collect, use, and protect your personal data.
We are committed to ensuring that your information is secure and handled responsibly.

1. Information Collection
We may collect personal information such as your name, email, phone number, and usage data.

2. Data Usage
Your information is used to improve our services, personalize user experience, and ensure system security.

3. Data Protection
We use encryption and access controls to safeguard your data from unauthorized access or disclosure.

4. Contact
If you have questions regarding our privacy practices, please contact us via our support email.
            ''',
            style: TextStyle(fontSize: 16, height: 1.5,color: Colors.black),
          ),
        ),
      );
  }
}
