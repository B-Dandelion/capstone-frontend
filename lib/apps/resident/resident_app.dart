import 'package:flutter/material.dart';
import 'package:capstone_frontend/apps/resident/screens/home_screen.dart';
import 'package:capstone_frontend/core/theme/app_theme.dart';

class ResidentApp extends StatelessWidget {
  const ResidentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.resident(),
      home: const HomeScreen(),
    );
  }
}