import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

class RaceTextService {
  static Future<String> getRandomRaceText() async {
    final dbRef = FirebaseDatabase.instance.ref("raceTexts");
    final snapshot = await dbRef.get();

    if (!snapshot.exists) {
      throw Exception("No race texts found");
    }

    final texts = snapshot.children.map((child) {
      return child.child("text").value.toString();
    }).toList();

    final randomIndex = Random().nextInt(texts.length);
    return texts[randomIndex];
  }
}