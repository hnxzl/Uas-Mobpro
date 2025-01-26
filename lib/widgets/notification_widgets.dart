import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Task Deadline',
      'message': 'Project Presentation is due tomorrow',
      'time': '2 hours ago',
      'type': 'warning',
      'icon': Icons.warning_amber_rounded
    },
    {
      'title': 'Meeting Reminder',
      'message': 'Team meeting at 2:00 PM',
      'time': '4 hours ago',
      'type': 'info',
      'icon': Icons.calendar_today
    },
    {
      'title': 'New Note',
      'message': 'Collaborative note added to Project X',
      'time': 'Yesterday',
      'type': 'success',
      'icon': Icons.note_add
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: TextStyle(color: AppColors.dblue)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.dblue),
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: () {
              setState(() {
                _notifications.clear();
              });
            },
          )
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 100, color: Colors.grey),
                  Text('No notifications', style: TextStyle(color: Colors.grey))
                ],
              ),
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return Dismissible(
                  key: Key(notification['title']),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    setState(() {
                      _notifications.removeAt(index);
                    });
                  },
                  child: ListTile(
                    leading: Icon(
                      notification['icon'],
                      color: notification['type'] == 'warning'
                          ? Colors.orange
                          : notification['type'] == 'info'
                              ? Colors.blue
                              : Colors.green,
                    ),
                    title: Text(notification['title']),
                    subtitle: Text(notification['message']),
                    trailing: Text(
                      notification['time'],
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      // Handle notification tap
                    },
                  ),
                );
              },
            ),
    );
  }
}
