import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final String name;
  final double progress;
  final bool isTop;
  final Color carsGray;
  final Color carsOrange;
  final Color carsYellow;

  const ProgressBar({
    super.key,
    required this.name,
    required this.progress,
    required this.isTop,
    required this.carsGray,
    required this.carsOrange,
    required this.carsYellow,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            name,
            style: TextStyle(
              color: isTop ? carsYellow : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 24,
                decoration: BoxDecoration(
                  color: carsGray,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: isTop ? carsYellow : carsOrange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}