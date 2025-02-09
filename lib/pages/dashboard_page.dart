import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  String username = '';
  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> notes = [];
  List<Map<String, dynamic>> events = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchTasks();
    fetchNotes();
    fetchEvents();
  }

  Future<void> fetchUserData() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final response = await supabase
          .from('users')
          .select('username')
          .eq('id', user.id)
          .single();
      setState(() {
        username = response['username'] ?? 'User';
      });
    }
  }

  Future<void> fetchTasks() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final response =
          await supabase.from('tasks').select('*').eq('user_id', user.id);
      setState(() {
        tasks = List<Map<String, dynamic>>.from(response);
      });
    }
  }

  Future<void> fetchNotes() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final response =
          await supabase.from('notes').select('*').eq('user_id', user.id);
      setState(() {
        notes = List<Map<String, dynamic>>.from(response);
      });
    }
  }

  Future<void> fetchEvents() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final response =
          await supabase.from('events').select('*').eq('user_id', user.id);
      setState(() {
        events = List<Map<String, dynamic>>.from(response);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Welcome back, $username',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Search tasks, notes & events...',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Actions
            Text('Quick Actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _quickAction(Icons.add_task, 'New Task', () {
                  print('New Task Clicked');
                }),
                _quickAction(Icons.event, 'New Event', () {
                  print('New Event Clicked');
                }),
                _quickAction(Icons.note, 'New Note', () {
                  print('New Note Clicked');
                }),
              ],
            ),
            const SizedBox(height: 20),

            // Today's Tasks
            _sectionHeader('Today’s Tasks', tasks.length),
            ...tasks.map((task) => _taskItem(task)).toList(),

            const SizedBox(height: 20),
            _sectionHeader('Upcoming Events', events.length),
            ...events.map((event) => _eventItem(event)).toList(),

            const SizedBox(height: 20),
            _sectionHeader('Recent Notes', notes.length),
            ...notes.map((note) => _noteItem(note)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _quickAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[200],
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(height: 5),
          Text(label),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        if (count > 0)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('$count pending', style: TextStyle(color: Colors.blue)),
          ),
      ],
    );
  }

  Widget _taskItem(Map<String, dynamic> task) {
    return Card(
      child: ListTile(
        title:
            Text(task['title'], style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(task['time']),
      ),
    );
  }

  Widget _eventItem(Map<String, dynamic> event) {
    return Card(
      child: ListTile(
        title: Text(event['title']),
        subtitle: Text(event['date'] + ' at ' + event['time']),
      ),
    );
  }

  Widget _noteItem(Map<String, dynamic> note) {
    return Card(
      child: ListTile(
        title:
            Text(note['title'], style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(note['content']),
      ),
    );
  }
}
