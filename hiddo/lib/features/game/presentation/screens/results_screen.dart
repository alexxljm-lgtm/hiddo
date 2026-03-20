import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/game_provider.dart';

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
                                content: Image.network(item.value),
                              ),
                            );
                          },
                        ),
                      );
                    },
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