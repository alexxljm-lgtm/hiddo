import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hiddo/features/game/domain/usecases/generate_assignments.dart';
import 'package:hiddo/features/game/presentation/screens/hunt_screen.dart';
import 'package:hiddo/features/game/presentation/screens/list_submission_screen.dart';
import 'package:hiddo/features/game/presentation/screens/results_screen.dart';
import 'package:hiddo/injection_container.dart';
import '../providers/game_provider.dart' hide gameStreamProvider;

class GameLobbyScreen extends ConsumerStatefulWidget {
  final String gameId;
  const GameLobbyScreen({super.key, required this.gameId});

  @override
  ConsumerState<GameLobbyScreen> createState() => _GameLobbyScreenState();
}

class _GameLobbyScreenState extends ConsumerState<GameLobbyScreen> {
  int selectedDurationMinutes = 60; // Estado del dropdown

  @override
  Widget build(BuildContext context) {
    final gameAsync = ref.watch(gameStreamProvider(widget.gameId));

    return Scaffold(
      appBar: AppBar(
        title: Text("Lobby ${widget.gameId}"),
      ),
      body: gameAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (game) {
          // Navegar a HuntScreen si ya empezó la partida
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

            if (game.status == "finished") {
              Future.microtask(() {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResultsScreen(gameId: game.id),
                  ),
                );
              });
            }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Jugadores en la partida ${game.lists.length}/${game.players.length} listas enviadas",
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(height: 20),

                // Lista de jugadores
                Expanded(
                  child: ListView.builder(
                    itemCount: game.players.length,
                    itemBuilder: (context, index) {
                      final playerId = game.players[index];
                      final playerName = game.playerNames[playerId] ?? playerId;
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(playerName),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Selector de duración
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Duración de la partida"),
                    const SizedBox(height: 8),
                    DropdownButton<int>(
                      value: selectedDurationMinutes,
                      items: const [
                        DropdownMenuItem(value: 15, child: Text("15 min")),
                        DropdownMenuItem(value: 30, child: Text("30 min")),
                        DropdownMenuItem(value: 45, child: Text("45 min")),
                        DropdownMenuItem(value: 60, child: Text("1 hora")),
                        DropdownMenuItem(value: 90, child: Text("1 h 30 min")),
                        DropdownMenuItem(value: 120, child: Text("2 horas")),
                        DropdownMenuItem(value: 180, child: Text("3 horas")),
                        DropdownMenuItem(value: 240, child: Text("4 horas")),
                        DropdownMenuItem(value: 300, child: Text("5 horas")),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          selectedDurationMinutes = value;
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Botón Start Game
                ElevatedButton(
                  onPressed: () async {
                    final datasource = ref.read(gameFirestoreDatasourceProvider);
                    final assignments = generateAssignments(game.players);

                    await datasource.startGame(
                      game.id,
                      assignments,
                      selectedDurationMinutes,
                    );
                  },
                  child: const Text("Start Game"),
                ),

                const SizedBox(height: 20),

                // Botón Crear lista
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListSubmissionScreen(gameId: game.id),
                      ),
                    );
                  },
                  child: const Text("Crear mi lista"),
                ),
              ],
            ),
          );
          
        },
        
      ),
    );
  }
}
