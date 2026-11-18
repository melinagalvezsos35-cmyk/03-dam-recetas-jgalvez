import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/receta.dart';

class RecetaDb {
  RecetaDb._();
  static final RecetaDb instancia = RecetaDb._();
  static const _nombreArchivo = 'recetas_comentarios.db';
  static const _tabla = 'comentarios';
  Database? _db;

  // Devuelve la BD abierta (Singleton)
  Future<Database> get _database async {
    _db ??= await _abrir();
    return _db!;
  }

  Future<Database> _abrir() async {
    final ruta = join(await getDatabasesPath(), _nombreArchivo);
    return openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tabla (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            recetaId INTEGER NOT NULL,
            texto TEXT NOT NULL,
            fecha TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Guarda y devuelve el id generado
  Future<int> insert(Comentario comentario) async {
    final db = await _database;
    return db.insert(_tabla, comentario.toMap());
  }

  // Lee todos los comentarios asociados a una receta específica (orden descendente)
  Future<List<Comentario>> obtenerPorReceta(int recetaId) async {
    final db = await _database;
    final filas = await db.query(
      _tabla,
      where: 'recetaId = ?',
      whereArgs: [recetaId],
      orderBy: 'id DESC',
    );
    return filas.map(Comentario.fromMap).toList();
  }

  // Modifica un comentario usando el id
  Future<int> actualizar(Comentario comentario) async {
    final db = await _database;
    return db.update(
      _tabla,
      comentario.toMap(),
      where: 'id = ?',
      whereArgs: [comentario.id],
    );
  }

  // Elimina un comentario por su id
  Future<int> eliminar(int id) async {
    final db = await _database;
    return db.delete(_tabla, where: 'id = ?', whereArgs: [id]);
  }
}