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