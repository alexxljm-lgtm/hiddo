import '../../domain/entities/game.dart';

abstract class GameFirestoreDatasource {

  Future<Game> createGame(String hostId);

  Future<void> joinGame(String gameId, String userId);
  Future<void> startGame(String gameId,Map<String, String> assignments,int durationMinutes,);
  Stream<Game> watchGame(String gameId);

  Future<void> submitList(
  String gameId,
  String userId,
  List<String> items,
  );
  Future<void> markItemFound({
    required String gameId,
    required String userId,
    required String item,
    required String photoUrl,
  });
  Future<void> finishGame(String gameId, {String? winnerId});
}