import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hiddo/features/game/presentation/screens/game_lobby_screen.dart';
import 'package:hiddo/injection_container.dart';
import '../../data/datasources/game_firestore_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LobbyScreen extends ConsumerStatefulWidget {
  const LobbyScreen({super.key});

  @override
  ConsumerState<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends ConsumerState<LobbyScreen> {
  int selectedDurationMinutes = 60;

  @override
  Widget build(BuildContext context) {
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
                try {
                  // Crear usuario anónimo si no hay
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    final cred = await FirebaseAuth.instance.signInAnonymously();
                    user = cred.user;
                  }
                  final game = await datasource.createGame(user!.uid);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GameLobbyScreen(gameId: game.id),
                    ),
                  );
                  print("Game created: ${game.id}");
                  
                  // Mostrar gameId
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Partida creada"),
                      content: Text("ID: ${game.id}"),
                    ),
                  );
                } on FirebaseException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error al crear partida: ${e.message}")),
                    
                  );
                }
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
                final gameId = gameIdController.text.trim();
                if (gameId.isEmpty) return;

                try {
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    final cred = await FirebaseAuth.instance.signInAnonymously();
                    user = cred.user;
                  }

                  await datasource.joinGame(gameId, user!.uid);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GameLobbyScreen(gameId: gameId),
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Te uniste a la partida")),
                  );
                } on FirebaseException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error al unirse: ${e.message}")),
                  );
                }
              },
              child: const Text("Unirse a Partida"),
              
            ),
          

          ],
        ),
      ),
    );
    
  }
}