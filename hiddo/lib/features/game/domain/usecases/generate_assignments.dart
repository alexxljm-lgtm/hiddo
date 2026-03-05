import 'dart:math';

Map<String, String> generateAssignments(List<String> players) {

  final shuffled = List<String>.from(players);

  shuffled.shuffle(Random());

  for (int i = 0; i < players.length; i++) {

    if (players[i] == shuffled[i]) {
      return generateAssignments(players);
    }

  }

  final Map<String, String> assignments = {};

  for (int i = 0; i < players.length; i++) {
    assignments[players[i]] = shuffled[i];
  }

  return assignments;
}