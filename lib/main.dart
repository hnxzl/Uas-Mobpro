import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://xpziiukuryoftcuhbmnm.supabase.co', // Ganti dengan URL Anda
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhwemlpdWt1cnlvZnRjdWhibW5tIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQ0ODQ0NzksImV4cCI6MjA1MDA2MDQ3OX0.OzDAAM0UCAHymmqoXz99Icl_5yFOEjUM9KISKmuDhTg', // Ganti dengan API Key Anda
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODODO',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthScreen(),
    );
  }
}
