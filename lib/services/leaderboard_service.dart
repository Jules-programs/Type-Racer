import '../models/race_result.dart';

class LeaderboardService {
  // Singleton pattern
  static final LeaderboardService _instance = LeaderboardService._internal();
  factory LeaderboardService() => _instance;
  LeaderboardService._internal();

  final List<RaceResult> _results = [];

  List<RaceResult> get results => List.unmodifiable(_results);

  void addResult(RaceResult result) {
    _results.add(result);
    _results.sort((a, b) => b.wpm.compareTo(a.wpm)); // highest WPM first
    if (_results.length > 10) _results.removeLast(); // keep top 10
  }

  void clear() => _results.clear();
}
