import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/game.dart';

final gameStreamProvider = StreamProvider.family<Game, String>((ref, gameId) {

  final datasource = ref.read(gameFirestoreDatasourceProvider);

  return datasource.watchGame(gameId);
});