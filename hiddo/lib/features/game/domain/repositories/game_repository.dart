import '../entities/game.dart';

abstract class GameRepository {

  Future<Game> createGame(String hostId);

  Future<void> joinGame(String gameId, String userId);

}