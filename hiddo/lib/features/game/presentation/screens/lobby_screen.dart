import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hiddo/injection_container.dart';
import '../../data/datasources/game_firestore_datasource.dart';


class LobbyScreen extends ConsumerWidget {
  const LobbyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final datasource = ref.read(gameFirestoreDatasourceProvider);

    final gameIdController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Hiddo Lobby")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                // Crear partida
                final userId = "uid_demo"; // Aquí usarías tu UID real
                final game = await datasource.createGame(userId);
                // Mostrar gameId
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Partida creada"),
                    content: Text("ID: ${game.id}"),
                  ),
                );
              },
              child: const Text("Crear Partida"),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: gameIdController,
              decoration: const InputDecoration(
                labelText: "ID de partida",
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final userId = "uid_demo"; // Aquí usarías tu UID real
                final gameId = gameIdController.text.trim();
                if (gameId.isEmpty) return;
                await datasource.joinGame(gameId, userId);
                // Confirmación
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Te uniste a la partida")),
                );
              },
              child: const Text("Unirse a Partida"),
            ),
          ],
        ),
      ),
    );
  }
}