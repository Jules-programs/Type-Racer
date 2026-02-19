import 'package:flutter/material.dart';
import '../models/race_result.dart';

class ResultPopup {
  static void show(
      BuildContext context,
      List<RaceResult> results, {
        VoidCallback? onPlayAgain,
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: const Text(
            'Race Results',
            style: TextStyle(color: Colors.yellow),
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: results.length,
              itemBuilder: (context, index) {
                final r = results[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '${index + 1}. ${r.name} - WPM: ${r.wpm} - Accuracy: ${(r.accuracy * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                onPlayAgain?.call(); // Start new game
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
              ),
              child: const Text("Play Again"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to home
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Exit"),
            ),
          ],
        );
      },
    );
  }
}
