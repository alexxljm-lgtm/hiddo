import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../injection_container.dart';
import '../../../../core/services/photo_service.dart';
import 'results_screen.dart';

class HuntScreen extends ConsumerWidget {
  final String gameId;

  const HuntScreen({
    super.key,
    required this.gameId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameAsync = ref.watch(gameStreamProvider(gameId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hiddo - Caza"),
      ),
      body: gameAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text("Error: $e"),
        ),
        data: (game) {
          final currentUserId = FirebaseAuth.instance.currentUser!.uid;
          final assignedUserId = game.assignments[currentUserId];

          if (assignedUserId == null) {
            return const Center(
              child: Text("Sin asignación"),
            );
          }

          final items = List<String>.from(game.lists[assignedUserId] ?? []);
          final foundMap =
              Map<String, dynamic>.from(game.progress[currentUserId] ?? {});
          final foundItems = foundMap.keys.toList();

          final hasWon = items.isNotEmpty && foundItems.length == items.length;

          if (hasWon && game.status != 'finished') {
            Future.microtask(() async {
              final datasource = ref.read(gameFirestoreDatasourceProvider);

              await datasource.finishGame(
                game.id,
                winnerId: currentUserId,
              );

              if (!context.mounted) return;

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ResultsScreen(gameId: game.id),
                ),
              );
            });
          }

          return StreamBuilder<int>(
            stream: Stream.periodic(
              const Duration(seconds: 1),
              (x) => x,
            ),
            builder: (context, snapshot) {
              final remaining = getRemainingTime(game.endsAt);
              final isTimeOver = remaining != null && remaining == Duration.zero;

              if (isTimeOver && game.status != 'finished') {
                Future.microtask(() async {
                  final datasource = ref.read(gameFirestoreDatasourceProvider);

                  await datasource.finishGame(game.id);

                  if (!context.mounted) return;

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResultsScreen(gameId: game.id),
                    ),
                  );
                });
              }

              return Column(
                children: [
                  const SizedBox(height: 12),
                  Text(
                    remaining == null
                        ? "Tiempo restante: --:--:--"
                        : "Tiempo restante: ${formatDuration(remaining)}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (_, index) {
                        final item = items[index];
                        final isFound = foundMap[item] != null;

                        return ListTile(
                          title: Text(item),
                          trailing: Icon(
                            isFound ? Icons.check_circle : Icons.camera_alt,
                            color: isFound ? Colors.green : null,
                          ),
                          onTap: isTimeOver || isFound
                              ? null
                              : () async {
                                  try {
                                    final photoService = PhotoService();
                                    final datasource = ref.read(
                                      gameFirestoreDatasourceProvider,
                                    );

                                    final url =
                                        await photoService.takePhotoAndUpload(
                                      gameId: game.id,
                                      userId: currentUserId,
                                      item: item,
                                    );

                                    if (url == null) return;

                                    await datasource.markItemFound(
                                      gameId: game.id,
                                      userId: currentUserId,
                                      item: item,
                                      photoUrl: url,
                                    );

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Foto subida correctamente",
                                          ),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Error subiendo foto: $e",
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

Duration? getRemainingTime(String? endsAt) {
  if (endsAt == null || endsAt.isEmpty) return null;

  final end = DateTime.tryParse(endsAt);
  if (end == null) return null;

  final diff = end.difference(DateTime.now());

  if (diff.isNegative) return Duration.zero;

  return diff;
}

String formatDuration(Duration duration) {
  final hours = duration.inHours.toString().padLeft(2, '0');
  final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
  final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

  return '$hours:$minutes:$seconds';
}