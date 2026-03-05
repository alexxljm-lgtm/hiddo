import '../../data/datasources/game_firestore_datasource.dart';

class MarkItemFound {

  final GameFirestoreDatasource datasource;

  MarkItemFound(this.datasource);

  Future<void> call({
    required String gameId,
    required String userId,
    required String item,
    required String photoUrl,
  }) {

    return datasource.markItemFound(
      gameId: gameId,
      userId: userId,
      item: item,
      photoUrl: photoUrl,
    );

  }
}