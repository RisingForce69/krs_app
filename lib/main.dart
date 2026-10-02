import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const KrsApp());
}

/// Widget akar aplikasi KRS.
class KrsApp extends StatelessWidget {
  const KrsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KRS Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
