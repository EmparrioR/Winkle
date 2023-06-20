import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "StepCounter.db";
  static final _databaseVersion = 1;

  static final table = 'step_counter';

  static final columnId = '_id';
  static final columnUserId = 'userId';
  static final columnSteps = 'steps';
  static final columnGoal = 'goal';
  static final columnDate = 'date';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnUserId TEXT NOT NULL,
            $columnSteps INTEGER NOT NULL,
            $columnGoal INTEGER NOT NULL,
            $columnDate TEXT NOT NULL
          )
          ''');
  }

  // Helper methods

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.update(table, row,
        where: '$columnUserId = ?', whereArgs: [row[columnUserId]]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>> getRow(String userId) async {
    Database db = await instance.database;
    var res = await db.query(table, where: "$columnUserId = ?", whereArgs: [userId]);
    return res.isNotEmpty ? res.first : {};
  }

  Future<int> getStepCountForDate(String userId, String date) async {
    Database db = await instance.database;
    var res = await db.query(
      table,
      where: "$columnUserId = ? AND date(substr($columnDate, 0, 10)) = ?",
      whereArgs: [userId, date],
    );
    if (res.isNotEmpty) {
      return res.first[columnSteps] as int;
    } else {
      return 0;
    }
  }
}
