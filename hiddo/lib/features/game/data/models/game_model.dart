// lib/features/game/data/models/game_model.dart

import '../../domain/entities/game.dart';

class GameModel extends Game {
  GameModel({
    required super.id,
    required super.players,
    required super.lists,
    required super.assignments,
    required super.progress,
    required super.status,
    super.durationMinutes,
    super.startedAt,
    super.endsAt,
  });

  factory GameModel.fromFirestore(Map<String, dynamic> data, String id) {
    return GameModel(
      id: id,
      players: List<String>.from(data['players'] ?? []),
      lists: Map<String, dynamic>.from(data['lists'] ?? {}),
      assignments: Map<String, dynamic>.from(data['assignments'] ?? {}),
      progress: Map<String, dynamic>.from(data['progress'] ?? {}),
      status: data['status'] ?? 'waiting',
      durationMinutes: data['durationMinutes'] as int?,
      startedAt: data['startedAt'] as String?,
      endsAt: data['endsAt'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'players': players,
      'lists': lists,
      'assignments': assignments,
      'progress': progress,
      'status': status,
      'durationMinutes': durationMinutes,
      'startedAt': startedAt,
      'endsAt': endsAt,
    };
  }

  factory GameModel.fromEntity(Game game) {
    return GameModel(
      id: game.id,
      players: game.players,
      lists: game.lists,
      assignments: game.assignments,
      progress: game.progress,
      status: game.status,
      durationMinutes: game.durationMinutes,
      startedAt: game.startedAt,
      endsAt: game.endsAt,
    );
  }

  Game toEntity() {
    return Game(
      id: id,
      players: players,
      lists: lists,
      assignments: assignments,
      progress: progress,
      status: status,
      durationMinutes: durationMinutes,
      startedAt: startedAt,
      endsAt: endsAt,
    );
  }
}