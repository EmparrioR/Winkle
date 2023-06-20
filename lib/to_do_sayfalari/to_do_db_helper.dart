import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'to_do.dart';

class DatabaseHelper {
  static final _databaseVersion = 1;

  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnIsDone = 'isDone';
  static final columnUserId = 'userId';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'todos_database.db');
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {

  }

  Future<int> insert(Todo todo, String table) async {
    Database? db = await instance.database;
    return await db!.insert(table, todo.toMap());
  }

  Future<List<Todo>> queryRowsByUserId(String userId, String table) async {
    Database? db = await instance.database;
    var res = await db!.query(table, where: '$columnUserId = ?', whereArgs: [userId]);
    return res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];
  }

  Future<List<Todo>> getAllTodos(String table) async {
    Database? db = await instance.database;
    var res = await db!.query(table);
    return res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];
  }

  Future<int> update(Todo todo, String table) async {
    Database? db = await instance.database;
    int id = todo.toMap()['id'];
    return await db!.update(table, todo.toMap(), where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id, String table) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<void> createTable(String tableName, Database db) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $tableName (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnIsDone BOOLEAN NOT NULL,
            $columnUserId TEXT NOT NULL
          )
          ''');
  }
}
