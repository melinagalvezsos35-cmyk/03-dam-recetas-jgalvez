import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recetas del Mayab'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('Pantalla Principal de Recetas'),
      ),
    );
  }
}