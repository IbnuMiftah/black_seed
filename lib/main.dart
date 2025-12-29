import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const BlackSeedApp());
}

class BlackSeedApp extends StatelessWidget {
  const BlackSeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlackSeed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1D29), // Deep Charcoal
        primaryColor: const Color(0xFF00CBA9), // Calm Teal
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00CBA9), // Calm Teal
          secondary: Color(0xFF5FFFD7), // Mint
          surface: Color(0xFF1E2432), // Deep Charcoal
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
