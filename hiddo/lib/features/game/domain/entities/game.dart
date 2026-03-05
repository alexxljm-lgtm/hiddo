class Game {
  final String id;
  final List<String> players;
  final Map<String, List<String>> lists;
  final Map<String, String> assignments;
  final String status;

  Game({
    required this.id,
    required this.players,
    required this.lists,
    required this.assignments,
    required this.status,
  });
}