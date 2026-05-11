import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const SensoryApp());
}

class SensoryApp extends StatelessWidget {
  const SensoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kozmos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF4A90E2),
        fontFamily: 'Roboto', 
      ),
      home: const DashboardScreen(),
    );
  }
}