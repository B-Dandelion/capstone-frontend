import 'package:flutter/material.dart';
import 'package:capstone_frontend/apps/courier/screens/courier_dashboard_screen.dart';
import 'package:capstone_frontend/core/theme/app_theme.dart';

class CourierApp extends StatelessWidget {
  const CourierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.courier(),
      home: const CourierDashboardScreen(),
    );
  }
}