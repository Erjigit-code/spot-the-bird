import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static final _databaseName = "MyDatabase.db";

  static final _databaseVersion = 1;

  static final table = "my_table";

  static final columnId = "id";

  static final columnTitle = "birdName";

  static final columnDescription = "birdDescription";

  static final columnUrl = "url";

  static final longitude = 'longitude';
  static final latitude = 'latitude';

  //create a singleton

  DataBaseHelper._privateConstructor();
  static final DataBaseHelper instance = DataBaseHelper._privateConstructor();

  //only one app-wide reference to database
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDataBase();
    return _database;
  }

  Future<Database> _initDataBase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentDirectory.path, _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database database, int version) async {
    await database.execute("""


  CREATE TABLE $table(
  $columnId INTEGER PRIMARY KEY,
  $columnTitle TEXT NOT NULL,
  $columnDescription TEXT NOT NULL,
  $columnUrl TEXT NOT NULL,
  $latitude REAL NOT NULL,
  $longitude REAL NOT NULL)


""");
  }

  Future<int?> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;

    return await db!.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> qureyAllRows() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: "$columnId = ?", whereArgs: [id]);
  }
}
