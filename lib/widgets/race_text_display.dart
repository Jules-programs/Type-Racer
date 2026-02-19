import 'package:flutter/material.dart';

class RaceTextDisplay extends StatelessWidget {
  final String raceText;
  final String userInput;

  const RaceTextDisplay({
    super.key,
    required this.raceText,
    required this.userInput,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.generate(raceText.length, (i) {
        Color bgColor;
        if (i < userInput.length) {
          bgColor = userInput[i] == raceText[i]
              ? Colors.green.withOpacity(0.6)
              : Colors.red.withOpacity(0.6);
        } else {
          bgColor = Colors.transparent;
        }
        return Container(
          color: bgColor,
          child: Text(
            raceText[i],
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }),
    );
  }
}