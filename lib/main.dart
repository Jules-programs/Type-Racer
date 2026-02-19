import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Default theme = dark (black + gold)
  bool isLightTheme = false;

  void updateTheme(bool isLight) {
    setState(() {
      isLightTheme = isLight;
    });
  }

  // Shared Cars colors
  static const Color carsRed = Color(0xFFD93B3A);
  static const Color carsOrange = Color(0xFFEB793D);
  static const Color carsYellow = Color(0xFFFFD700);
  static const Color carsDark = Color(0xFF2B2622);

  @override
  Widget build(BuildContext context) {
    // Light (Cars) theme
    final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: carsRed,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFD93B3A),
        secondary: Color(0xFFEB793D),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: carsRed,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: carsRed,
          foregroundColor: Colors.white,
        ),
      ),
    );

    // Dark (Black + Gold trim, subtle cars accents)
    final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF000000),
      primaryColor: carsYellow,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFFFD700),
        secondary: Color(0xFFFFC000),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Color(0xFFFFD700),
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: carsYellow,
          foregroundColor: Colors.black,
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Typing Race',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isLightTheme ? ThemeMode.light : ThemeMode.dark,
      home: WelcomeScreen(
        isLightTheme: isLightTheme,
        onThemeChanged: updateTheme,
      ),
    );
  }
}
