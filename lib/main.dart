// Copyright (c) 2024 Tommy Chin. All rights reserved.
// This code is protected by copyright law. Unauthorized copying, modification,
// or distribution of this software is strictly prohibited.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/language_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageService(),
      child: const LuckyDrawApp(),
    ),
  );
}

class LuckyDrawApp extends StatelessWidget {
  const LuckyDrawApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wulala Lucky Draw',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFE31837), // Traditional Chinese Red
        scaffoldBackgroundColor: const Color(0xFFFDF1DB), // Light Gold
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE31837),
          secondary: const Color(0xFFFFD700), // Gold
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Color(0xFFE31837),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            color: Color(0xFF333333),
            fontSize: 16,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE31837),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}