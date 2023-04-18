import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'my_table';

  static const columnId = '_id';
  static const columnName = 'name';
  static const columnAge = 'age';

  late Database _db;

  // esse abre ou cria o database caso ele não exista
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // codigo SQL para criar a tabela da database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnAge INTEGER NOT NULL
          )
          ''');
  }

  // Metódos Helper


  //Insira uma linha dentro da db onde cada chave do Map é nome de uma coluna
  // e o valor é uma valor de uma coluna. O valor retornado é a id da linha 
  // inserida 
  Future<int> insert(Map<String, dynamic> row) async {
    return await _db.insert(table, row);
  }

  //Todas as linhas estão retornando uma lista de mapas, onde cada mapa
  // é um valor-chave da listas de colunas.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.query(table);
  }

  // Todos os métodos (insert, query, update, delete) pode ser usado como raw
  // SQL commands. Esse método usa um raw query para dar a raw count.
  Future<int> queryRowCount() async {
    final results = await _db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  // Estamos assumindo aqui que essa coluna id dentro do map está pronta.
  // As outras colunas de valores serão usadas para o update da linha.
  Future<int> update(Map<String, dynamic> row) async {
    int id = row[columnId];
    return await _db.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Deleta a linha especifica a partir do id. O numero de linhas atingidas é retornado.
  // Isso deve ser 1, desde que a linha exista
  Future<int> delete(int id) async {
    return await _db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}