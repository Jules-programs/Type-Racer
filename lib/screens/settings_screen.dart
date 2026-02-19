import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final bool isLightTheme;
  final ValueChanged<bool> onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.isLightTheme,
    required this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool soundEnabled = true;
  bool musicEnabled = true;
  late bool isLightThemeLocal;

  static const Color carsRed = Color(0xFFD93B3A);
  static const Color carsOrange = Color(0xFFEB793D);
  static const Color carsDark = Color(0xFF2B2622);
  static const Color carsYellow = Color(0xFFFFD700);
  static const Color carsGray = Color(0xFF756A7A);

  @override
  void initState() {
    super.initState();
    isLightThemeLocal = widget.isLightTheme;
  }

  BoxDecoration backgroundDecoration(bool light) {
    if (light) {
      return const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFD93B3A), Color(0xFFEB793D), Color(0xFF2B2622)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
    } else {
      return const BoxDecoration(color: Color(0xFF000000));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isLightTheme ? null : Colors.black,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: widget.isLightTheme ? carsRed : Colors.black,
        shadowColor: widget.isLightTheme ? carsOrange : carsOrange.withOpacity(0.6),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: backgroundDecoration(widget.isLightTheme),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'Tune your car. Adjust your ride. Get ready to race!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: carsYellow,
                  shadows: const [
                    Shadow(
                      blurRadius: 6,
                      color: Colors.amberAccent,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSwitchTile(
              'Sound Effects',
              soundEnabled,
                  (val) => setState(() => soundEnabled = val),
            ),
            const SizedBox(height: 16),
            _buildSwitchTile(
              'Music',
              musicEnabled,
                  (val) => setState(() => musicEnabled = val),
            ),
            const SizedBox(height: 16),
            _buildSwitchTile(
              'Light Theme',
              isLightThemeLocal,
                  (val) {
                setState(() => isLightThemeLocal = val);
                // Propagate to MyApp
                widget.onThemeChanged(val);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: carsYellow,
          inactiveThumbColor: carsGray,
        ),
      ],
    );
  }
}
