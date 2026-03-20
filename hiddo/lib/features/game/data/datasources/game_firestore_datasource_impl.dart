import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/game.dart';
import '../models/game_model.dart';
import 'game_firestore_datasource.dart';

class GameFirestoreDatasourceImpl implements GameFirestoreDatasource {

  final FirebaseFirestore firestore;

  GameFirestoreDatasourceImpl(this.firestore);

Future<Game> createGame(String userId) async {

  print("CREATE GAME START");

  final docRef = firestore.collection('games').doc();

  final gameModel = GameModel(
    id: docRef.id,
    players: [userId],
    lists: const {},
    assignments: const {},
    progress: const {},
    status: 'waiting',
  );

  await docRef.set(gameModel.toFirestore());

  print("GAME CREATED: ${docRef.id}");

  return gameModel;
}

  @override
  Future<void> joinGame(String gameId, String userId) async {
    final docRef = firestore.collection('games').doc(gameId);
    await docRef.update({
      "players": FieldValue.arrayUnion([userId])
    });
  }

    @override
    Future<void> startGame(String gameId, Map<String, String> assignments) async {

      // ignore: avoid_print
      print("START GAME CALLED");
      print("GameId: $gameId");
      print("Assignments: $assignments");

      final doc = firestore.collection('games').doc(gameId);

      await doc.update({
        'assignments': assignments,
        'status': 'playing'
      });

      print("FIRESTORE UPDATED");
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

  @override
Stream<Game> watchGame(String gameId) {
  final doc = firestore.collection('games').doc(gameId);

  return doc.snapshots().map((snapshot) {
    final data = snapshot.data()!;
    return GameModel.fromFirestore(data, snapshot.id);
  });
}
}