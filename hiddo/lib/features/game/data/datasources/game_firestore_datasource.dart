import '../../domain/entities/game.dart';

abstract class GameFirestoreDatasource {

  Future<Game> createGame(String hostId);

  Future<void> joinGame(String gameId, String userId);

}