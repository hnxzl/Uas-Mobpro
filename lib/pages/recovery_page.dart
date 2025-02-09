import 'package:flutter/material.dart';

class RecoveryPage extends StatefulWidget {
  const RecoveryPage({super.key});

  @override
  _RecoveryPageState createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {
  List<Map<String, String>> deletedItems = [
    {'title': 'Deleted Task 1', 'subtitle': 'Was due yesterday'},
    {'title': 'Deleted Event 1', 'subtitle': 'Was at 2:00 PM yesterday'},
  ];

  void _recoverItem(Map<String, String> item) {
    // Logic to recover item (e.g., move it back to the main list)
    print('Item recovered: ${item['title']}');
    setState(() {
      deletedItems.remove(item);
    });
  }

  void _deletePermanently(Map<String, String> item) {
    // Permanently delete item from the list
    print('Item permanently deleted: ${item['title']}');
    setState(() {
      deletedItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deleted Items'),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: deletedItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(deletedItems[index]['title']!),
            subtitle: Text(deletedItems[index]['subtitle']!),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'recover') {
                  _recoverItem(deletedItems[index]);
                } else if (value == 'delete') {
                  _deletePermanently(deletedItems[index]);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'recover', child: Text('Recover')),
                const PopupMenuItem(
                    value: 'delete', child: Text('Delete Permanently')),
              ],
            ),
          );
        },
      ),
    );
  }
}
