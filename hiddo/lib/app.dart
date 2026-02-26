import 'package:flutter/material.dart';

class HiddoApp extends StatelessWidget {
  const HiddoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hiddo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Hiddo🚀'),
        ),
      ),
    );
  }
}