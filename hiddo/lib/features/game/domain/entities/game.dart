// lib/features/game/domain/entities/game.dart


class Game {
  final String id; // ID de la partida en Firestore
  final List<String> players; // UIDs de los jugadores
  final Map<String, List<String>> lists; // listas de cada jugador
  final Map<String, String> assignments; // asignaciones jugador->jugador
  final Map<String, Map<String, String>> progress; // progreso jugador->item->photoUrl
  final String status; // waiting, started, finished

  const Game({
    required this.id,
    required this.players,
    required this.lists,
    required this.assignments,
    required this.progress,
    required this.status,
  });

  @override
  List<Object?> get props => [id, players, lists, assignments, progress, status];

  // Convertir de Firestore a Game
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

    return Game(
      id: id,
      players: players,
      lists: lists,
      assignments: assignments,
      progress: progress,
      status: status,
    );
  }

  // Convertir a Map para subir a Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'players': players,
      'lists': lists,
      'assignments': assignments,
      'progress': progress,
      'status': status,
    };
  }
}