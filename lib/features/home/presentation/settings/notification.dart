import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example static data for notifications
    final List<Map<String, String>> notifications = [
      {
        'title': 'New Update Available',
        'subtitle': 'Version 2.3 is now live with new features.'
      },
      {
        'title': 'Booking Confirmed',
        'subtitle': 'Your service booking has been successfully confirmed.'
      },
      {
        'title': 'Payment Received',
        'subtitle': 'We have received your payment successfully.'
      },
      {
        'title': 'Maintenance Reminder',
        'subtitle': 'Your scheduled maintenance is due tomorrow.'
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notification',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Notification List
          Expanded(
            child: ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) =>
              const Divider(thickness: 0.0),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Image.asset('assets/log.png'),
                  ),
                  title: Text(item['title'] ?? ''),
                  subtitle: Text(item['subtitle'] ?? ''),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Handle tap action (optional)
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
