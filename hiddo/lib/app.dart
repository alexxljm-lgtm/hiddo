import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/game/presentation/screens/lobby_screen.dart';

void main() {
  runApp(const ProviderScope(child: HiddoApp()));
}

class HiddoApp extends StatelessWidget {
  const HiddoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hiddo App",
      debugShowCheckedModeBanner: false,
      home: const LobbyScreen(), // <- Aquí abrimos la LobbyScreen
    );
  }
}