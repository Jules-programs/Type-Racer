import 'package:flutter/material.dart';
import '../services/leaderboard_service.dart';

class LeaderboardScreen extends StatefulWidget {
  final bool isLightTheme;
  final ValueChanged<bool> onThemeChanged;

  const LeaderboardScreen({
    super.key,
    required this.isLightTheme,
    required this.onThemeChanged,
  });

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  static const Color carsRed = Color(0xFFD93B3A);
  static const Color carsOrange = Color(0xFFEB793D);
  static const Color carsYellow = Color(0xFFFFD700);
  static const Color carsDark = Color(0xFF2B2622);
  static const Color carsGray = Color(0xFF756A7A);

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
      return const BoxDecoration(color: Color(0xFF000000));
    }
  }

  @override
  Widget build(BuildContext context) {
    final leaderboardData = LeaderboardService().results;

    return Scaffold(
      backgroundColor: widget.isLightTheme ? null : Colors.black,
      appBar: AppBar(
        title: const Text('Leaderboard'),
        centerTitle: true,
        backgroundColor: widget.isLightTheme ? carsRed : Colors.black,
        shadowColor:
        widget.isLightTheme ? carsOrange : carsOrange.withOpacity(0.6),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: backgroundDecoration(widget.isLightTheme),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Text(
                '🏁 Race to the Top! Only the Fastest WPM Wins! 🏁',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: carsYellow,
                  shadows: const [
                    Shadow(
                      blurRadius: 8,
                      color: Colors.amberAccent,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(carsGray),
                  columnSpacing: 24,
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  columns: const [
                    DataColumn(label: Text('Rank')),
                    DataColumn(label: Text('Player')),
                    DataColumn(label: Text('WPM')),
                    DataColumn(label: Text('Time')),
                  ],
                  rows: List.generate(
                    leaderboardData.length,
                        (index) {
                      final player = leaderboardData[index];
                      int rank = index + 1;
                      Color? rowColor;
                      Widget leadingIcon = const Icon(Icons.directions_car,
                          color: Colors.white, size: 20);

                      if (rank == 1) {
                        rowColor = const Color(0xFFFFD700).withOpacity(0.3);
                        leadingIcon = const Icon(Icons.emoji_events,
                            color: Color(0xFFFFD700), size: 24);
                      } else if (rank == 2) {
                        rowColor = const Color(0xFFC0C0C0).withOpacity(0.3);
                        leadingIcon = const Icon(Icons.emoji_events,
                            color: Color(0xFFC0C0C0), size: 24);
                      } else if (rank == 3) {
                        rowColor = const Color(0xFFCD7F32).withOpacity(0.3);
                        leadingIcon = const Icon(Icons.emoji_events,
                            color: Color(0xFFCD7F32), size: 24);
                      }

                      return DataRow(
                        color: rowColor != null
                            ? MaterialStateProperty.all(rowColor)
                            : null,
                        cells: [
                          DataCell(Text(rank.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Row(
                            children: [
                              leadingIcon,
                              const SizedBox(width: 6),
                              Text(player.name,
                                  style: const TextStyle(color: Colors.white)),
                            ],
                          )),
                          DataCell(Text(player.wpm.toString(),
                              style: const TextStyle(color: Colors.white))),
                          DataCell(Text(
                              "${player.timeSeconds.toStringAsFixed(1)}s",
                              style: const TextStyle(color: Colors.white))),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
