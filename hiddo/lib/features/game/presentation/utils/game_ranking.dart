class PlayerRankingItem {
  final String userId;
  final int found;
  final int total;

  const PlayerRankingItem({
    required this.userId,
    required this.found,
    required this.total,
  });
}

List<PlayerRankingItem> buildRanking({
  required List<String> players,
  required Map<String, dynamic> assignments,
  required Map<String, dynamic> lists,
  required Map<String, dynamic> progress,
}) {
  final ranking = <PlayerRankingItem>[];

  for (final playerId in players) {
    final assignedUserId = assignments[playerId];
    final assignedList = assignedUserId != null
        ? List<String>.from(lists[assignedUserId] ?? [])
        : <String>[];

    final playerProgress =
        Map<String, dynamic>.from(progress[playerId] ?? {});

    ranking.add(
      PlayerRankingItem(
        userId: playerId,
        found: playerProgress.length,
        total: assignedList.length,
      ),
    );
  }

  ranking.sort((a, b) => b.found.compareTo(a.found));
  return ranking;
}