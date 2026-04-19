// lib/features/game/domain/entities/game.dart

class Game {
  final String id;
  final List<String> players;
  final Map<String, String> playerNames;
  final Map<String, dynamic> lists;
  final Map<String, dynamic> assignments;
  final Map<String, dynamic> progress;
  final String status;
  final int? durationMinutes;
  final String? startedAt;
  final String? endsAt;
  final String? winnerId;
  final String? finishedAt;

  Game({
    required this.id,
    required this.players,
    required this.playerNames,
    required this.lists,
    required this.assignments,
    required this.progress,
    required this.status,
    this.durationMinutes,
    this.startedAt,
    this.endsAt, 
    this.winnerId, 
    this.finishedAt, 
  });

  @override
  List<Object?> get props => [
        id,
        players,
        playerNames,
        lists,
        assignments,
        progress,
        status,
        durationMinutes,
        startedAt,
        endsAt,
      ];

  factory Game.fromFirestore(Map<String, dynamic> data, String id) {
    final players = List<String>.from(data['players'] ?? []);

    final lists = (data['lists'] as Map<String, dynamic>? ?? {}).map(
      (key, value) => MapEntry(key, List<String>.from(value)),
    );

    final assignments = Map<String, String>.from(data['assignments'] ?? {});

    final progress = (data['progress'] as Map<String, dynamic>? ?? {}).map(
      (playerId, map) => MapEntry(
        playerId,
        Map<String, String>.from(map as Map<String, dynamic>),
      ),
    );

    final status = data['status'] as String? ?? 'waiting';
    
    final playerNames = Map<String, String>.from(data['playerNames'] ?? {});
    return Game(
      id: id,
      players: players,
      playerNames: playerNames,
      lists: lists,
      assignments: assignments,
      progress: progress,
      status: status,
      durationMinutes: data['durationMinutes'] as int?,
      startedAt: data['startedAt'] as String?,
      endsAt: data['endsAt'] as String?,
      winnerId: data['winnerId'] as String?,
      finishedAt: data['finishedAt'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'players': players,
      'playerNames': playerNames,
      'lists': lists,
      'assignments': assignments,
      'progress': progress,
      'status': status,
      'durationMinutes': durationMinutes,
      'startedAt': startedAt,
      'endsAt': endsAt,
      'winnerId': winnerId,
      'finishedAt': finishedAt,

    };
  }
}
