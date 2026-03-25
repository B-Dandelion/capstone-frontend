import 'package:flutter/material.dart';
import 'package:capstone_frontend/apps/resident/screens/arrived_screen.dart';
import 'package:capstone_frontend/apps/resident/screens/history_screen.dart';
import 'package:capstone_frontend/apps/resident/screens/home_screen.dart';
import 'package:capstone_frontend/apps/resident/screens/profile_screen.dart';
import 'package:capstone_frontend/apps/resident/screens/tracking_screen.dart';
import 'package:capstone_frontend/core/theme/app_theme.dart';
import 'package:capstone_frontend/apps/resident/screens/security_alert_screen.dart';
import 'package:capstone_frontend/apps/resident/screens/security_history_screen.dart';

class ResidentApp extends StatelessWidget {
  const ResidentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.resident(),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/tracking': (_) => const TrackingScreen(),
        '/history': (_) => const HistoryScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/arrived': (_) => const ArrivedScreen(),
        '/security-alert': (_) => const SecurityAlertScreen(),
        '/security-history': (_) => const SecurityHistoryScreen(),
      },
    );
  }
}