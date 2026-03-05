import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/game.dart';
import '../models/game_model.dart';
import 'game_firestore_datasource.dart';

class GameFirestoreDatasourceImpl implements GameFirestoreDatasource {

  final FirebaseFirestore firestore;

  GameFirestoreDatasourceImpl(this.firestore);

  @override
  Future<Game> createGame(String hostId) async {

    final doc = firestore.collection('games').doc();

    final game = GameModel(
      id: doc.id,
      players: [hostId],
      lists: {},
      assignments: {},
      status: 'waiting',
    );

    await doc.set(game.toFirestore());

    return game;
  }

  @override
  Future<void> joinGame(String gameId, String userId) async {

    final doc = firestore.collection('games').doc(gameId);

    await doc.update({
      'players': FieldValue.arrayUnion([userId])
    });

  }

  @override
  Future<void> startGame(String gameId, Map<String, String> assignments) async {

  final doc = firestore.collection('games').doc(gameId);

  await doc.update({
    'assignments': assignments,
    'status': 'playing'
  });

  

}

 @override
Future<void> submitList(
  String gameId,
  String userId,
  List<String> items,
) async {

  final doc = firestore.collection('games').doc(gameId);

  await doc.update({
    'lists.$userId': items
  });

}

  @override
Future<void> markItemFound({
  required String gameId,
  required String userId,
  required String item,
  required String photoUrl,
}) async {

  final doc = firestore.collection('games').doc(gameId);

  await doc.update({
    'progress.$userId.$item': photoUrl
  });

}
}