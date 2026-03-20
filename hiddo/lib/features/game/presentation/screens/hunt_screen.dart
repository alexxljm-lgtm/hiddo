import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hiddo/core/services/photo_service.dart';
import '../../../../injection_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'results_screen.dart';

class HuntScreen extends ConsumerWidget {
  final String gameId;

  const HuntScreen({
    super.key,
    required this.gameId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameStream = ref.watch(gameStreamProvider(gameId));

    return Scaffold(
      appBar: AppBar(title: const Text("Hiddo - Caza")),
      body: gameStream.when(
        data: (game) {

          final currentUserId = FirebaseAuth.instance.currentUser!.uid; // luego lo ajustamos

          final assignedUserId = game.assignments[currentUserId];


          if (assignedUserId == null) {
            return const Center(child: Text("Sin asignación"));
          }

          final items = game.lists[assignedUserId] ?? [];
          final foundItems = game.progress[currentUserId]?.keys.toList() ?? [];
          final hasWon = items.isNotEmpty && foundItems.length == items.length;

          if (hasWon) {
          Future.microtask(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ResultsScreen(
                  gameId: game.id,
                ),
              ),
            );
          });
        }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, index) {
              final item = items[index];

              final isFound = game.progress[currentUserId]?[item] != null;

              return ListTile(
                title: Text(item),
                trailing: Icon(
                  isFound ? Icons.check_circle : Icons.camera_alt,
                  color: isFound ? Colors.green : null,
                ),
              onTap: () async {
                try {
                  final photoService = PhotoService();
                  final datasource = ref.read(gameFirestoreDatasourceProvider);
                  final userId = FirebaseAuth.instance.currentUser!.uid;

                  final url = await photoService.takePhotoAndUpload(
                    gameId: game.id,
                    userId: userId,
                    item: item,
                  );

                  if (url == null) return;

                  await datasource.markItemFound(
                    gameId: game.id,
                    userId: userId,
                    item: item,
                    photoUrl: url,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Foto subida correctamente")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error subiendo foto: $e")),
                  );
                }
              },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}