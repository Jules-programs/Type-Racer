import 'package:flutter/material.dart';

class InstructionScreen extends StatelessWidget {
  final bool isLightTheme;
  final ValueChanged<bool> onThemeChanged;

  const InstructionScreen({
    super.key,
    required this.isLightTheme,
    required this.onThemeChanged,
  });

  // Cars-inspired palette
  static const Color carsRed = Color(0xFFD93B3A);
  static const Color carsOrange = Color(0xFFEB793D);
  static const Color carsBlue = Color(0xFFC5E4E6);
  static const Color carsGray = Color(0xFF756A7A);
  static const Color carsDark = Color(0xFF2B2622);
  static const Color carsYellow = Color(0xFFFFD700);

  BoxDecoration backgroundDecoration(bool light) {
    if (light) {
      return const BoxDecoration(
        gradient: LinearGradient(
          colors: [carsRed, carsOrange, carsDark],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
    } else {
      return const BoxDecoration(color: Colors.black);
    }
  }

  Color titleColor(bool light) => light ? carsYellow : carsYellow;
  Color textColor(bool light) => light ? Colors.white : Colors.white;
  Color textSecondaryColor(bool light) => light ? Colors.white70 : Colors.white70;
  Color tileBackgroundColor(bool light) => light ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.25);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isLightTheme ? carsDark : Colors.black,
      appBar: AppBar(
        backgroundColor: isLightTheme ? carsRed : carsRed,
        title: const Text(
          "How to Play",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ),
      body: Container(
        decoration: backgroundDecoration(isLightTheme),
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            _cinematicHeader(),
            const SizedBox(height: 20),
            _instructionTile(
              icon: Icons.group,
              title: "Choose Your Opponents",
              text:
              "Pick up to 4 AI racers. Each bot has a unique personality and speed — from Rookie to Lightning Bot.",
            ),
            _instructionTile(
              icon: Icons.traffic_outlined,
              title: "Countdown Start",
              text:
              "A traffic-light countdown signals the beginning. Green means GO — hit the gas!",
            ),
            _instructionTile(
              icon: Icons.keyboard,
              title: "Type to Accelerate",
              text:
              "Your car moves only when you type correctly. Mistakes stall your engine until fixed.",
            ),
            _instructionTile(
              icon: Icons.flash_on,
              title: "Race Against Bots",
              text:
              "Bots have variable WPM and accuracy patterns. Some keep steady… others spike into turbo mode.",
            ),
            _instructionTile(
              icon: Icons.emoji_events,
              title: "Reach the Finish Line",
              text:
              "First to complete the sentence wins the race and becomes the Radiator Springs Champion.",
            ),
            const SizedBox(height: 30),
            _closingMessage(),
          ],
        ),
      ),
    );
  }

  Widget _cinematicHeader() {
    return Column(
      children: const [
        Icon(
          Icons.local_fire_department,
          color: carsYellow,
          size: 60,
        ),
        SizedBox(height: 12),
        Text(
          "Welcome to Radiator Springs Speedway",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 12,
                color: Colors.black87,
              ),
            ],
          ),
        ),
        SizedBox(height: 6),
        Text(
          "Where every keystroke burns rubber.",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.white70,
          ),
        )
      ],
    );
  }

  Widget _instructionTile({
    required IconData icon,
    required String title,
    required String text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: carsYellow, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: carsYellow, size: 34),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _closingMessage() {
    return Column(
      children: const [
        SizedBox(height: 10),
        Text(
          "Ka-Chow!",
          style: TextStyle(
            color: carsYellow,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Speed is nothing without precision.\nReady to hit the gas?",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
