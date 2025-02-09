import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: 10, // Ganti dengan jumlah notifikasi yang sebenarnya
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.notifications, color: Colors.blue),
            title: Text('Notification ${index + 1}'),
            subtitle: const Text('This is a notification message'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Aksi saat notifikasi ditekan
              print('Notification $index tapped');
            },
          );
        },
      ),
    );
  }
}
