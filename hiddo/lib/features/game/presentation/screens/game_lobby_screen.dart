import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hiddo/features/game/domain/usecases/generate_assignments.dart';
import 'package:hiddo/features/game/presentation/screens/hunt_screen.dart';
import 'package:hiddo/features/game/presentation/screens/list_submission_screen.dart';
import 'package:hiddo/injection_container.dart';
import '../providers/game_provider.dart' hide gameStreamProvider;


class GameLobbyScreen extends ConsumerWidget {

  final String gameId;

  const GameLobbyScreen({
    super.key,
    required this.gameId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final gameAsync = ref.watch(gameStreamProvider(gameId));

    return Scaffold(
      appBar: AppBar(
        title: Text("Lobby $gameId"),
      ),
      body: gameAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(
          child: Text("Error: $e"),
        ),

        data: (game) {
          if (game.status == "playing") {
            Future.microtask(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HuntScreen(gameId: game.id),
                ),
              );
            });
          }

          return Column(
            children: [

              const SizedBox(height: 20),

              Text(
                "Jugadores en la partida ${game.lists.length}/${game.players.length} listas enviadas",
                style: const TextStyle(fontSize: 22),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: game.players.length,
                  itemBuilder: (context, index) {

                    final player = game.players[index];

                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(player),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              

              ElevatedButton(
                onPressed: () async {

                  final datasource = ref.read(gameFirestoreDatasourceProvider);

                  final assignments = generateAssignments(game.players);

                  await datasource.startGame(
                    game.id,
                    assignments,
                  );

                },
                child: const Text("Start Game"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ListSubmissionScreen(
                        gameId: game.id,
                      ),
                    ),
                  );

                },
                child: const Text("Crear mi lista"),
              )

            ],


          );
        },
      ),
    );
  }
}