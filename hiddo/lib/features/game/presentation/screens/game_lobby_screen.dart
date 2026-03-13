import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_provider.dart';

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

          return Column(
            children: [

              const SizedBox(height: 20),

              const Text(
                "Jugadores en la partida",
                style: TextStyle(fontSize: 22),
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
                onPressed: () {
                  // luego activaremos startGame aquí
                },
                child: const Text("Start Game"),
              ),

              const SizedBox(height: 20),

            ],
          );
        },
      ),
    );
  }
}