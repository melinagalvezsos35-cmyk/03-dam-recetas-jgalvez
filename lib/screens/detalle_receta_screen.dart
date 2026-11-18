import 'package:flutter/material.dart';
import 'package:recetas_app/models/receta.dart';

import 'package:recetas_app/data/receta_db.dart';

class DetalleRecetaScreen extends StatefulWidget {
  final Receta receta;

  const DetalleRecetaScreen({super.key, required this.receta});

  @override
  State<DetalleRecetaScreen> createState() => _DetalleRecetaScreenState();
}

class _DetalleRecetaScreenState extends State<DetalleRecetaScreen> {
  final TextEditingController _comentarioController = TextEditingController();
  List<Comentario> _comentarios = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarComentarios();
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _cargarComentarios() async {
    final comentarios = await RecetaDb.instancia.obtenerPorReceta(widget.receta.id);
    setState(() {
      _comentarios = comentarios;
      _cargando = false;
    });
  }

  Future<void> _agregarComentario() async {
    final texto = _comentarioController.text.trim();
    if (texto.isEmpty) return;

    final nuevoComentario = Comentario(
      recetaId: widget.receta.id,
      texto: texto,
      fecha: DateTime.now().toString().split('.')[0],
    );

    await RecetaDb.instancia.insert(nuevoComentario);
    _comentarioController.clear();
    await _cargarComentarios();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Comentario guardado en SQLite!')),
      );
    }
  }

  Future<void> _eliminarComentario(int id) async {
    await RecetaDb.instancia.eliminar(id);
    await _cargarComentarios();
  }

  @override
  Widget build(BuildContext context) {
    final receta = widget.receta;
    return Scaffold(
      appBar: AppBar(title: const Text("Detalle de la receta")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              receta.imagenUrl,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Image.asset(
                "assets/images/plato-placeholder.jpg",
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
         ChipTheme(
  data: ChipThemeData(
    backgroundColor: Colors.teal.shade100, // Fondo para todos
    labelStyle: TextStyle(
      color: Colors.teal.shade900, // Texto para todos
      fontWeight: FontWeight.bold,
    ),
    side: BorderSide.none, // Opcional: quita el borde gris por defecto en Material 3
  ),
  child: Wrap(
    spacing: 10,
    children: [
      Chip(label: Text('${receta.tiempoTotal} min')),
      Chip(label: Text(receta.dificultad)),
      Chip(label: Text(receta.cocina)),
      Chip(label: Text('${receta.calorias} kcal')),
    ],
  ),
),
          const SizedBox(height: 8),
          const Text(
            "Ingredientes: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...receta.ingredientes.map(
            (ingrediente) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 6, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(child: Text(ingrediente)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Preparación: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...receta.instrucciones.asMap().entries.map(
            (entrada) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: const Color.fromARGB(255, 47, 99, 19),
                    child: Text(
                      '${entrada.key + 1}',
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(entrada.value)),
                ],
              ),
            ),
          ),

          const Divider(height: 40, thickness: 1),

          // --- SECCIÓN DE COMENTARIOS ---
          const Text(
            "Deja tu comentario",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _comentarioController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Escribe tu opinión sobre esta receta...",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: _agregarComentario,
              icon: const Icon(Icons.send),
              label: const Text("Publicar Comentario"),
              style: ElevatedButton.styleFrom(
                backgroundColor:  const Color.fromARGB(255, 47, 99, 19),
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            "Comentarios de la comunidad",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          if (_cargando)
            const Center(child: CircularProgressIndicator())
          else if (_comentarios.isEmpty)
            const Text(
              "Aún no hay comentarios guardados para esta receta.",
              style: TextStyle(color: Colors.grey),
            )
          else
            ..._comentarios.map(
              (comentario) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: const Icon(Icons.comment, color: Colors.deepOrange),
                  title: Text(comentario.texto),
                  subtitle: Text(
                    comentario.fecha,
                    style: const TextStyle(fontSize: 11),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Color.fromARGB(255, 25, 41, 101)),
                    onPressed: () => _eliminarComentario(comentario.id!),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}