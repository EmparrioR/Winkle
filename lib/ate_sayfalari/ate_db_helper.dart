import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final _databaseName = "habits_database.db";
  static final _databaseVersion = 1;

  static final table = 'habits';

  static final columnId = '_id';
  static final columnName = 'habit';
  static final columnColor = 'color';
  static final columnDateTime = 'dateTime';
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
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnColor INTEGER NOT NULL,
            $columnDateTime TEXT NOT NULL,
            $columnUserId TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String userId) async {
    Database? db = await instance.database;
    return await db!.query(table, where: '$columnUserId = ?', whereArgs: [userId]);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!.update(table, row, where: '$columnId = ? AND $columnUserId = ?', whereArgs: [id, row[columnUserId]]);
  }

  Future<int> delete(int id, String userId) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$columnId = ? AND $columnUserId = ?', whereArgs: [id, userId]);
  }
}