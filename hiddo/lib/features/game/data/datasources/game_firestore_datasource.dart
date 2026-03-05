import '../../domain/entities/game.dart';

abstract class GameFirestoreDatasource {

  Future<Game> createGame(String hostId);

  Future<void> joinGame(String gameId, String userId);
  Future<void> startGame(String gameId, Map<String, String> assignments);

  Future<void> submitList(
  String gameId,
  String userId,
  List<String> items,
  );

}