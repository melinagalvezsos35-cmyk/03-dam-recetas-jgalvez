// Modelo principal de la receta (proveniente de la API DummyJSON)
class Receta {
  final int id;
  final String nombre;
  final List<String> ingredientes;
  final List<String> instrucciones;
  final int tiempoPreparacion;
  final int tiempoCoccion;
  final int porciones;
  final int calorias;
  final String imagenUrl;
  final double calificacion;
  final String cocina;
  final String dificultad;

  const Receta({
    required this.id,
    required this.nombre,
    required this.ingredientes,
    required this.instrucciones,
    required this.tiempoPreparacion,
    required this.tiempoCoccion,
    required this.porciones,
    required this.calorias,
    required this.imagenUrl,
    required this.calificacion,
    required this.cocina,
    required this.dificultad,
  });

  factory Receta.fromJson(Map<String, dynamic> json) {
    return Receta(
      id: json['id'] ?? 0,
      nombre: json['name'] ?? '',
      ingredientes: json['ingredients'] != null
          ? List<String>.from(json['ingredients'])
          : [],
      instrucciones: json['instructions'] != null
          ? List<String>.from(json['instructions'])
          : [],
      tiempoPreparacion: json['prepTimeMinutes'] ?? 0,
      tiempoCoccion: json['cookMinutes'] ?? 0,
      porciones: json['servings'] ?? 0,
      calorias: json['caloriesPerServing'] ?? 0,
      imagenUrl: json['image'] ?? '',
      calificacion: (json['rating'] as num?)?.toDouble() ?? 0.0,
      cocina: json['cuisine'] ?? '',
      dificultad: json['difficulty'] ?? '',
    );
  }

  int get tiempoTotal => tiempoPreparacion + tiempoCoccion;
}

// Modelo de Comentario/Reseña para la base de datos local SQLite (RecetaDb)
class Comentario {
  final int? id;
  final int recetaId;
  final String texto;
  final String fecha;

  Comentario({
    this.id,
    required this.recetaId,
    required this.texto,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'recetaId': recetaId,
      'texto': texto,
      'fecha': fecha,
    };
  }

  factory Comentario.fromMap(Map<String, dynamic> map) {
    return Comentario(
      id: map['id'] as int?,
      recetaId: map['recetaId'] as int,
      texto: map['texto'] as String,
      fecha: map['fecha'] as String,
    );
  }
}