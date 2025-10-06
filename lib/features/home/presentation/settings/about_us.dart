import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),

          // Company Logo
          Center(
            child: Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white24,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image(
                  image: AssetImage('assets/log.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Company Name
          const Text(
            'Orange Hill',
            style: TextStyle(
              color: Colors.orangeAccent,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 10),

          // Tagline or short description
          const Text(
            'Innovating digital solutions for a smarter tomorrow.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          // About Description
          const Text(
            'Orange Hill is a software development company dedicated to creating modern, user-friendly, and efficient digital products. '
                'Our mission is to empower businesses through technology — building web, mobile, and enterprise solutions tailored to your needs.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(),

          // Version info
          const Text(
            'Version 1.0.0',
            style: TextStyle(color: Colors.black, fontSize: 13),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
