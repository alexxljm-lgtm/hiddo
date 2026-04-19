import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/game_provider.dart';
import '../utils/game_ranking.dart';
import '../utils/player_name_resolver.dart';


class ResultsScreen extends ConsumerWidget {
  final String gameId;

  const ResultsScreen({
    super.key,
    required this.gameId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameAsync = ref.watch(gameStreamProvider(gameId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
      ),
      body: gameAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (game) {
          final currentUserId = FirebaseAuth.instance.currentUser!.uid;
          final progress = game.progress[currentUserId] ?? {};
          final entries = progress.entries.toList();
          final ranking = buildRanking(
            players: game.players,
            assignments: game.assignments,
            lists: game.lists,
            progress: game.progress,
            playerNames: game.playerNames,
          );
          final winnerId = game.winnerId;
          final isCurrentUserWinner = winnerId == currentUserId;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  '¡Has completado tu lista!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text('Objetos encontrados: ${entries.length}'),
                const SizedBox(height: 20),
                    const SizedBox(height: 24),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Ranking',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        itemCount: ranking.length,
                        itemBuilder: (context, index) {
                          final player = ranking[index];

                          return Card(
                            child: ListTile(
                              leading: Text('#${index + 1}'),
                              title: FutureBuilder<String>(
                                future: PlayerNameResolver.resolve(player.userId),
                                builder: (context, snapshot) {
                                  return Text(snapshot.data ?? player.userId);
                                },
                              ),
                              subtitle: Text(
                                '${player.found}/${player.total} objetos encontrados',
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                Expanded(
                  child: ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final item = entries[index];

                      return Card(
                        child: ListTile(
                          title: Text(item.key),
                          subtitle: const Text('Foto subida'),
                          leading: const Icon(Icons.check_circle),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                content: Image.network(
                                    item.value,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text('No se pudo cargar la imagen'),
                                      );
                                    },
                                  ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),

                if (winnerId != null)
                FutureBuilder<String>(
                  future: winnerId == null
                      ? Future.value('')
                      : PlayerNameResolver.resolve(winnerId),
                  builder: (context, snapshot) {
                    final winnerLabel = snapshot.data ?? winnerId;
                    return Text(
                      isCurrentUserWinner
                          ? '¡Has ganado!'
                          : 'Ganador: $winnerLabel',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                )
              else
                const Text(
                  'Tiempo terminado',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
