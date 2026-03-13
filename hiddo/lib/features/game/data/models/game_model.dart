// lib/features/game/data/models/game_model.dart

import '../../domain/entities/game.dart';

class GameModel extends Game {
  const GameModel({
    required super.id,
    required super.players,
    required super.lists,
    required super.assignments,
    required super.progress,
    required super.status,
  });

  // Crear GameModel desde Firestore (map + id)
  factory GameModel.fromFirestore(Map<String, dynamic> data, String id) {
    return GameModel(
      id: id,
      players: List<String>.from(data['players'] ?? []),
      lists: (data['lists'] as Map<String, dynamic>? ?? {}).map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      ),
      assignments: Map<String, String>.from(data['assignments'] ?? {}),
      progress: (data['progress'] as Map<String, dynamic>? ?? {}).map(
        (playerId, map) => MapEntry(
          playerId,
          Map<String, String>.from(map as Map<String, dynamic>),
        ),
      ),
      status: data['status'] as String? ?? 'waiting',
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

  // Convertir de GameEntity a GameModel
  factory GameModel.fromEntity(Game game) {
    return GameModel(
      id: game.id,
      players: game.players,
      lists: game.lists,
      assignments: game.assignments,
      progress: game.progress,
      status: game.status,
    );
  }

  // Convertir a GameEntity
  Game toEntity() {
    return Game(
      id: id,
      players: players,
      lists: lists,
      assignments: assignments,
      progress: progress,
      status: status,
    );
  }
}