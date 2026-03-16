import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../injection_container.dart';

class ListSubmissionScreen extends ConsumerStatefulWidget {

  final String gameId;

  const ListSubmissionScreen({
    super.key,
    required this.gameId,
  });

  @override
  ConsumerState<ListSubmissionScreen> createState() => _ListSubmissionScreenState();
}

class _ListSubmissionScreenState extends ConsumerState<ListSubmissionScreen> {

  final List<TextEditingController> controllers = List.generate(
    5,
    (_) => TextEditingController(),
  );

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

            ElevatedButton(
              onPressed: () async {

                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return;

                final items = controllers
                    .map((c) => c.text.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();

                if (items.isEmpty) return;

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
              },
              child: const Text("Enviar lista"),
            )

          ],
        ),
      ),
    );
  }
}