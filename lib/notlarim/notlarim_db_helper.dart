import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "notes_database.db";
  static final _databaseVersion = 1;

  static final table = 'notes';

  static final columnId = '_id';
  static final columnName = 'note';
  static final columnUserId = 'userId';

  // Veritabanı sınıfını tek bir örnek olarak oluşturmak
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Veritabanına tek bir erişim noktası oluşturmak
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // Veritabanını açmak ya da oluşturmak
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Veritabanını oluşturmak
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnUserId TEXT NOT NULL
          )
          ''');
  }

  // Not eklemek için
  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  // Tüm notları getirmek için
  Future<List<Map<String, dynamic>>> queryAllRows(String userId) async {
    Database? db = await instance.database;
    return await db!
        .query(table, where: '$columnUserId = ?', whereArgs: [userId]);
  }

  // Bir notu güncellemek için
  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!.update(table, row,
        where: '$columnId = ? AND $columnUserId = ?',
        whereArgs: [id, row[columnUserId]]);
  }

  // Bir notu silmek için
  Future<int> delete(int id, String userId) async {
    Database? db = await instance.database;
    return await db!.delete(table,
        where: '$columnId = ? AND $columnUserId = ?', whereArgs: [id, userId]);
  }
}
