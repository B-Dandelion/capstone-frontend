import 'package:flutter/material.dart';

class AppValues {
  // App
  static const String appName = 'JetPace';
  static const String splashTitle = 'Run smarter';
  static const String splashSubtitle = 'AI Running Coach';

  // Colors
  static const Color bg = Color(0xFF0B0B0F);
  static const Color surface = Color(0xFF15151C);
  static const Color border = Color(0xFF24242E);

  static const Color primary = Color(0xFF00E58B); // Jet Green
  static const Color accent = Color(0xFFFF2D75); // Jet Pink

  static const Color textMain = Color(0xFFF5F7FA);
  static const Color textSub = Color(0xFF9AA0AA);

  static const Color warning = Color(0xFFFFB84D);
  static const Color danger = Color(0xFFFF5C7A);
  static const Color good = Color(0xFF00E58B);

  // UI
  static const double screenPadding = 20;
  static const double cardRadius = 18;
  static const double buttonHeight = 54;
  static const double tabIconSize = 24;
  static const double appBarHeight = 64;

  // Detection / Analysis Threshold
  static const double minDetectionConfidence = 0.45;
  static const double minKeypointConfidence = 0.35;
  static const double postureWarningScore = 70.0;
  static const double postureDangerScore = 50.0;

  // Running Analysis
  static const int stableFrameCount = 5;
  static const int feedbackCooldownMs = 3000;
  static const double minRunningSpeed = 1.5;

  // Feedback map
  static const Map<String, String> feedbackMap = {
    'trunk_forward': '상체를 조금 더 세워주세요.',
    'arm_swing_small': '팔 스윙을 조금 더 크게 가져가세요.',
    'knee_drive_low': '무릎을 조금 더 들어 올려보세요.',
    'stride_unbalanced': '좌우 보폭 균형을 맞춰주세요.',
    'good': '좋습니다. 지금 자세를 유지하세요.',
  };

  static ThemeData theme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg,
    fontFamily: 'Pretendard',
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: accent,
      surface: surface,
      error: danger,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: textMain,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: bg,
      elevation: 0,
      centerTitle: false,
      foregroundColor: textMain,
      titleTextStyle: TextStyle(
        color: textMain,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    dividerColor: border,
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
        side: const BorderSide(color: border),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primary,
      unselectedItemColor: textSub,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
  );
}

class AppText {
  static const TextStyle h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppValues.textMain,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppValues.textMain,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppValues.textMain,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppValues.textMain,
  );

  static const TextStyle sub = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppValues.textSub,
  );

  static const TextStyle metric = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppValues.textMain,
  );
}