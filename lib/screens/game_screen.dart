import 'dart:async';
import 'package:flutter/material.dart';
import '../models/race_result.dart';
import '../services/race_text_service.dart';
import '../services/leaderboard_service.dart';
import '../widgets/race_text_display.dart';
import '../widgets/progress_bar.dart';

class GameScreen extends StatefulWidget {
  final bool soundEnabled;
  final bool musicEnabled;
  final int numBots;
  final String difficulty;

  // Theme wiring
  final bool isLightTheme;
  final ValueChanged<bool> onThemeChanged;

  const GameScreen({
    super.key,
    required this.soundEnabled,
    required this.musicEnabled,
    required this.numBots,
    required this.difficulty,
    required this.isLightTheme,
    required this.onThemeChanged,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  static const Color carsRed = Color(0xFFD93B3A);
  static const Color carsOrange = Color(0xFFEB793D);
  static const Color carsDark = Color(0xFF2B2622);
  static const Color carsYellow = Color(0xFFFFD700);
  static const Color carsGray = Color(0xFF756A7A);

  int countdown = 3;
  bool raceStarted = false;
  bool raceFinished = false;

  Stopwatch stopwatch = Stopwatch();
  Timer? timer;

  double playerProgress = 0.0;
  String raceText = "";
  bool loadingText = true;
  final TextEditingController inputController = TextEditingController();
  String playerName = "You";

  late List<AnimationController> botControllers;
  late List<Animation<double>> botAnimations;

  List<RaceResult> results = [];

  @override
  void initState() {
    super.initState();
    _promptPlayerName();
  }

  void _promptPlayerName() {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Enter Your Name"),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: "Name"),
            onChanged: (val) => playerName = val,
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (playerName.trim().isEmpty) playerName = "You";
                Navigator.of(context).pop();
                _loadRaceText();
              },
              child: const Text("Start Race"),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _loadRaceText() async {
    final text = await RaceTextService.getRandomRaceText();
    setState(() {
      raceText = text;
      loadingText = false;
    });
    _setupBots();
    startCountdown();
  }

  void _setupBots() {
    botControllers = List.generate(widget.numBots, (index) {
      double speed = 12 + index * 3;
      return AnimationController(
        vsync: this,
        duration: Duration(seconds: speed.toInt()),
      );
    });

    botAnimations = botControllers
        .map((controller) => Tween<double>(begin: 0.0, end: 1.0).animate(controller))
        .toList();
  }

  void startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 1) {
          countdown--;
        } else {
          countdown = 0;
          raceStarted = true;
          startRace();
          timer.cancel();
        }
      });
    });
  }

  void startRace() {
    stopwatch.start();
    for (var controller in botControllers) {
      controller.forward();
    }
    timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() {
        checkRaceCompletion();
      });
    });
  }

  void checkRaceCompletion() {
    bool playerDone = playerProgress >= 1.0;
    bool botsDone = botAnimations.every((a) => a.value >= 1.0);

    if (playerDone && !results.any((r) => r.name == playerName)) {
      RaceResult playerResult = _buildPlayerResult();
      results.add(playerResult);
      LeaderboardService().addResult(playerResult);
    }

    if (playerDone && botsDone && !raceFinished) {
      for (int i = 0; i < widget.numBots; i++) {
        results.add(RaceResult(
          name: "Bot ${i + 1}",
          timeSeconds: botControllers[i].duration!.inSeconds.toDouble(),
          accuracy: 1.0,
          wpm: 50,
        ));
      }
      raceFinished = true;
      stopwatch.stop();
      _showRaceResults();
    }
  }

  RaceResult _buildPlayerResult() {
    double timeSeconds = stopwatch.elapsedMilliseconds / 1000;
    int correctChars = 0;
    for (int i = 0; i < inputController.text.length && i < raceText.length; i++) {
      if (inputController.text[i] == raceText[i]) correctChars++;
    }
    double accuracy = correctChars / raceText.length;
    int wpm = ((inputController.text.length / 5) / (timeSeconds / 60)).round();

    return RaceResult(
      name: playerName,
      timeSeconds: timeSeconds,
      accuracy: accuracy,
      wpm: wpm,
    );
  }

  void _showRaceResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Race Finished!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${playerName} finished with ${_buildPlayerResult().wpm} WPM in ${_buildPlayerResult().timeSeconds.toStringAsFixed(1)}s"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restartRace();
            },
            child: const Text("Play Again"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to home
            },
            child: const Text("Exit"),
          ),
        ],
      ),
    );
  }

  void _restartRace() {
    setState(() {
      countdown = 3;
      raceStarted = false;
      raceFinished = false;
      playerProgress = 0.0;
      inputController.clear();
      results.clear();
      _loadRaceText();
    });
  }

  @override
  void dispose() {
    for (var controller in botControllers) {
      controller.dispose();
    }
    timer?.cancel();
    inputController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    double elapsedSeconds = stopwatch.elapsedMilliseconds / 1000;

    if (loadingText) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: widget.isLightTheme ? null : Colors.black,
      appBar: AppBar(
        title: const Text("Typing Race"),
        backgroundColor: widget.isLightTheme ? carsRed : Colors.black,
        shadowColor: widget.isLightTheme ? carsOrange : carsOrange.withOpacity(0.6),
        centerTitle: true,
      ),
      body: Container(
        decoration: backgroundDecoration(widget.isLightTheme),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.isLightTheme
                  ? (raceStarted ? "$playerName - Time: ${elapsedSeconds.toStringAsFixed(1)}s" : "Race starts in $countdown")
                  : (raceStarted ? "$playerName - Time: ${elapsedSeconds.toStringAsFixed(1)}s" : "Race starts in $countdown"),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: carsYellow,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 3,
              child: ListView.builder(
                itemCount: 1 + widget.numBots,
                itemBuilder: (context, index) {
                  bool isPlayer = index == 0;
                  double progress = isPlayer
                      ? playerProgress
                      : (raceStarted ? botAnimations[index - 1].value : 0.0);
                  String name = isPlayer ? playerName : "Bot ${index}";
                  bool isTop = progress >=
                      [playerProgress, ...botAnimations.map((a) => a.value)]
                          .reduce((a, b) => a > b ? a : b) &&
                      progress > 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ProgressBar(
                      name: name,
                      progress: progress,
                      isTop: isTop,
                      carsGray: carsGray,
                      carsOrange: carsOrange,
                      carsYellow: carsYellow,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.isLightTheme ? carsGray.withOpacity(0.2) : Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: RaceTextDisplay(
                    raceText: raceText,
                    userInput: inputController.text,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (!raceFinished)
              TextField(
                controller: inputController,
                onChanged: (val) {
                  if (!raceStarted) return;
                  setState(() {
                    int correctChars = 0;
                    for (int i = 0; i < val.length && i < raceText.length; i++) {
                      if (val[i] == raceText[i]) {
                        correctChars++;
                      }
                    }
                    playerProgress =
                        (correctChars / raceText.length).clamp(0.0, 1.0);
                  });
                },
                decoration: InputDecoration(
                  hintText: "Type here...",
                  hintStyle: TextStyle(color: widget.isLightTheme ? Colors.black45 : Colors.white54),
                  filled: true,
                  fillColor: widget.isLightTheme ? Colors.white : Colors.black26,
                  border: const OutlineInputBorder(),
                ),
                style: TextStyle(color: widget.isLightTheme ? Colors.black : Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
