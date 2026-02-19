import 'package:flutter/material.dart';
import 'instructions_screen.dart';
import 'leaderboard_screen.dart';
import 'settings_screen.dart';
import 'game_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final bool isLightTheme;
  final ValueChanged<bool> onThemeChanged;

  const WelcomeScreen({
    super.key,
    required this.isLightTheme,
    required this.onThemeChanged,
  });

  // Cars colors
  static const Color carsRed = Color(0xFFD93B3A);
  static const Color carsOrange = Color(0xFFEB793D);
  static const Color carsYellow = Color(0xFFFFD700);
  static const Color carsDark = Color(0xFF2B2622);

  BoxDecoration backgroundDecoration(bool light) {
    return light
        ? const BoxDecoration(
      gradient: LinearGradient(
        colors: [carsRed, carsOrange, carsDark],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    )
        : const BoxDecoration(color: Colors.black);
  }

  Color titleColor(bool light) => carsYellow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isLightTheme ? null : Colors.black,
      body: Container(
        decoration: backgroundDecoration(isLightTheme),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const RacingBanner(),
                const SizedBox(height: 20),
                Text(
                  'Typing Race',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: titleColor(isLightTheme),
                    shadows: [
                      Shadow(
                        blurRadius: 16,
                        color: Colors.amberAccent.withOpacity(0.9),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Speed • Precision • Glory',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      _menuButton(context, 'Start Game'),
                      _menuButton(context, 'Instructions'),
                      _menuButton(context, 'Leaderboard'),
                      _menuButton(context, 'Settings'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuButton(BuildContext context, String text) {
    void navigateToScreen() {
      if (text == 'Instructions') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => InstructionScreen(
              isLightTheme: isLightTheme,
              onThemeChanged: onThemeChanged,
            ),
          ),
        );
      } else if (text == 'Leaderboard') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => LeaderboardScreen(
              isLightTheme: isLightTheme,
              onThemeChanged: onThemeChanged,
            ),
          ),
        );
      } else if (text == 'Settings') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => SettingsScreen(
              isLightTheme: isLightTheme,
              onThemeChanged: onThemeChanged,
            ),
          ),
        );
      } else if (text == 'Start Game') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => GameScreen(
              soundEnabled: true,
              musicEnabled: false,
              numBots: 3,
              difficulty: 'Medium',
              isLightTheme: isLightTheme,
              onThemeChanged: onThemeChanged,
            ),
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        onPressed: navigateToScreen,
        style: ElevatedButton.styleFrom(
          backgroundColor: carsRed,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          elevation: 12,
          shadowColor: carsOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Colors.amberAccent, width: 2),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}

class RacingBanner extends StatefulWidget {
  const RacingBanner({super.key});

  @override
  State<RacingBanner> createState() => _RacingBannerState();
}

class _RacingBannerState extends State<RacingBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (ctx, child) {
              return Transform.translate(
                offset: Offset(-40 + (_controller.value * 80), 0),
                child: Opacity(
                  opacity: 0.18,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white30, Colors.transparent],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(0.18 * (0.5 - _controller.value)),
                alignment: Alignment.center,
                child: child,
              );
            },
            child: Image.asset(
              'assets/images/racing_flag.png',
              width: 260,
              height: 160,
              fit: BoxFit.contain,
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (ctx, child) {
              double glow = 14 + (_controller.value * 20);
              return Container(
                margin: const EdgeInsets.only(top: 60),
                child: Icon(
                  Icons.keyboard,
                  size: 95,
                  color: const Color(0xFFFFD700),
                  shadows: [
                    Shadow(
                      blurRadius: glow,
                      color: Colors.amberAccent.withOpacity(0.9),
                    )
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 12,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                double angle = -1.4 + (_controller.value * 3);
                return Transform.rotate(
                  angle: angle * 0.35,
                  child: const Icon(
                    Icons.speed,
                    size: 40,
                    color: Colors.white70,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
