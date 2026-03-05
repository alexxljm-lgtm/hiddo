import '../../domain/entities/game.dart';

class GameModel extends Game {

  GameModel({
    required super.id,
    required super.players,
    required super.lists,
    required super.assignments,
    required super.status,
  });

  factory GameModel.fromFirestore(Map<String, dynamic> json, String id) {

    return GameModel(
      id: id,
      players: List<String>.from(json['players'] ?? []),
      lists: Map<String, List<String>>.from(json['lists'] ?? {}),
      assignments: Map<String, String>.from(json['assignments'] ?? {}),
      status: json['status'] ?? 'waiting',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'players': players,
      'lists': lists,
      'assignments': assignments,
      'status': status,
    };
  }
}