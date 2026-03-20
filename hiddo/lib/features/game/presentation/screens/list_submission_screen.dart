import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiddo/core/utils/random_list.dart';
import '../../../../injection_container.dart';

class ListSubmissionScreen extends ConsumerStatefulWidget {
  final String gameId;

  const ListSubmissionScreen({
    super.key,
    required this.gameId,
  });

  @override
  ConsumerState<ListSubmissionScreen> createState() =>
      _ListSubmissionScreenState();
}

class _ListSubmissionScreenState extends ConsumerState<ListSubmissionScreen> {
  final List<TextEditingController> controllers = List.generate(
    5,
    (_) => TextEditingController(),
  );

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final datasource = ref.read(gameFirestoreDatasourceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tu lista"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Escribe 5 cosas para que otro jugador las encuentre",
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            // Inputs
            ...controllers.map((controller) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Ej: perro",
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            // 🎲 Lista aleatoria
            ElevatedButton(
              onPressed: () {
                final randomItems = generateRandomItems();

                for (int i = 0; i < controllers.length; i++) {
                  controllers[i].text = randomItems[i];
                }

                setState(() {});
              },
              child: const Text("Lista aleatoria 🎲"),
            ),

            const SizedBox(height: 10),

            // 📤 Enviar lista
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return;

                final items = controllers
                    .map((c) => c.text.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();

                if (items.length < 5) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Debes completar los 5 campos"),
                    ),
                  );
                  return;
                }

                try {
                  await datasource.submitList(
                    widget.gameId,
                    user.uid,
                    items,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Lista enviada"),
                    ),
                  );

                  Navigator.pop(context); // volver al lobby
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error: $e"),
                    ),
                  );
                }
              },
              child: const Text("Enviar lista"),
            ),
          ],
        ),
      ),
    );
  }
}