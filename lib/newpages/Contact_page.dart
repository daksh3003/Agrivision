// contact_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this package to your pubspec.yaml

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  // Function to launch a URL (e.g., phone call or email)
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture and Title
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/support_avatar.png'), // Add a support avatar image
                ),
                const SizedBox(width: 16),
                Text(
                  'Tech Support Team',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Contact Information
            Text(
              'Contact Number:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _launchURL('tel:+1234567890'),
              child: Text(
                '+1 234 567 890',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Email Address:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _launchURL('mailto:support@example.com'),
              child: Text(
                'support@example.com',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tech Support Hours
            Text(
              'Tech Support Hours:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Monday - Friday: 9:00 AM - 6:00 PM\n'
                  'Saturday: 10:00 AM - 4:00 PM\n'
                  'Sunday: Closed',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),

            // Buttons for quick actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _launchURL('tel:+1234567890'),
                    child: const Text('Call Us'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _launchURL('mailto:support@example.com'),
                    child: const Text('Email Us'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
