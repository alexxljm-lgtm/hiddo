Map<String, String> generateAssignments(List<String> players) {

  final shuffled = List<String>.from(players)..shuffle();

  final Map<String, String> assignments = {};

  for (int i = 0; i < players.length; i++) {

    final currentPlayer = players[i];
    final targetPlayer = shuffled[i];

    assignments[currentPlayer] = targetPlayer;
  }

  return assignments;
}