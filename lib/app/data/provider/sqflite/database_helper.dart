import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "info.db";
  static final _databaseVersion = 1;

  static final table = "INFO";

  static final COLUMN_COMMUNITY_ID = 'COMMUNITY_ID';
  static final COLUMN_COMMUNITY_NAME = 'COMMUNITY_NAME';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database _database;
  Future<Database> get database async {
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
      $COLUMN_COMMUNITY_ID INTEGER PRIMARY KEY,
      $COLUMN_COMMUNITY_NAME VARCHAR(50) NOT NULL
    )
  ''');
  }

  Future<void> insert(BoardInfo board) async {
    final Database db = await instance.database;
    await db.insert(
      table,
      board.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Rx<BoardInfo>>> queryAllRows() async {
    Database db = await instance.database;
    Iterable res = await db.query(table, orderBy: "$COLUMN_COMMUNITY_ID DESC");

    List<Rx<BoardInfo>> listFollwingCommunity =
        res.map((e) => BoardInfo.fromJson(e).obs).toList();
    return listFollwingCommunity;
  }

  Future<int> delete(int COMMUNITY_ID) async {
    Database db = await instance.database;
    return await db.delete(table,
        where: '$COLUMN_COMMUNITY_ID = ?', whereArgs: [COMMUNITY_ID]);
  }

  Future<void> clearTable() async {
    Database db = await instance.database;
    return await db.rawQuery("DELETE FROM $table");
  }
}
