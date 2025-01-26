import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../widgets/add_event_widgets.dart';
import '../widgets/add_notes_widgets.dart';
import '../widgets/add_task_widgets.dart';
import '../widgets/notification_widgets.dart';
import '../widgets/search_bar.dart';

class DashboardScreen extends StatefulWidget {
  final String username;

  const DashboardScreen({super.key, required this.username});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, String>> tasks = [
    {'title': 'Project Presentation', 'subtitle': 'Due in 2 hours'},
    {'title': 'Team Meeting', 'subtitle': '2:00 PM'},
  ];

  List<Map<String, String>> events = [
    {'title': 'Product Launch', 'subtitle': 'Tomorrow, 10:00 AM'},
  ];

  List<Map<String, String>> notes = [
    {'title': 'Meeting Notes', 'subtitle': 'Key points from the meeting'},
  ];

  List<Map<String, String>> searchResults = [];

  void _search(String query) {
    setState(() {
      searchResults = [...tasks, ...events, ...notes]
          .where((item) =>
              item['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _refreshData() async {
    // Simulasi refresh data dari API atau database
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      tasks.add({'title': 'New Task', 'subtitle': 'Just added!'});
    });
  }

  void _editItem(Map<String, String> item) {
    // Handle edit action
    print('Editing: ${item['title']}');
  }

  void _deleteItem(Map<String, String> item) {
    setState(() {
      tasks.remove(item);
      events.remove(item);
      notes.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: AppColors.dblue,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Welcome back, ${widget.username}',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.notifications,
                                color: AppColors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationsScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      CustomSearchBar(
                        onSearch: _search,
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTaskWidget(),
                            ),
                          );
                        },
                        child: const _QuickActionButton(
                            icon: Icons.add_task, label: 'New Task'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEventDialog(),
                            ),
                          );
                        },
                        child: const _QuickActionButton(
                            icon: Icons.event, label: 'New Event'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddNotesWidget(),
                            ),
                          );
                        },
                        child: const _QuickActionButton(
                            icon: Icons.note_add, label: 'New Note'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Results Section
                if (searchResults.isNotEmpty)
                  ...searchResults.map((item) => _buildItemCard(item)),

                // Default Sections
                if (searchResults.isEmpty) ...[
                  const _SectionHeader(
                      title: "Today's Tasks",
                      subtitle: '5 pending',
                      color: Colors.blue),
                  ...tasks.map((task) => _buildItemCard(task)),
                  const SizedBox(height: 16),
                  const _SectionHeader(
                      title: 'Upcoming Events',
                      subtitle: '3 events',
                      color: Colors.orange),
                  ...events.map((event) => _buildItemCard(event)),
                  const SizedBox(height: 16),
                  const _SectionHeader(
                      title: 'Recent Notes',
                      subtitle: '2 new',
                      color: Colors.green),
                  ...notes.map((note) => _buildItemCard(note)),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(Map<String, String> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: const Icon(Icons.label, color: Colors.blue),
          ),
          title: Text(item['title']!),
          subtitle: Text(item['subtitle']!),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _editItem(item);
              } else if (value == 'delete') {
                _deleteItem(item);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickActionButton(
      {required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.lBlue.withOpacity(0.1),
          child: Icon(icon, color: AppColors.lBlue),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const _SectionHeader(
      {required this.title,
      required this.subtitle,
      required this.color,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              subtitle,
              style: TextStyle(color: color, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
