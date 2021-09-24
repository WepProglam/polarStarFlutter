import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/data/provider/sqflite/src/db_community.dart';
import 'package:polarstar_flutter/app/data/provider/sqflite/src/db_noti.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "info.db";
  static final _databaseVersion = 1;

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

  Future onCreate() async {
    return await _onCreate(_database, _databaseVersion);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE ${COMMUNITY_DB_HELPER.table} (
      ${COMMUNITY_DB_HELPER.COLUMN_COMMUNITY_ID} INTEGER PRIMARY KEY,
      ${COMMUNITY_DB_HELPER.COLUMN_COMMUNITY_NAME} VARCHAR(50) NOT NULL,
      ${COMMUNITY_DB_HELPER.COLUMN_isFollowed} VARCHAR(50),
      ${COMMUNITY_DB_HELPER.COLUMN_RECENT_TITLE} VARCHAR(50)
    );
  ''');

    await db.execute('''
    CREATE TABLE ${NOTI_DB_HELPER.table} (
      ${NOTI_DB_HELPER.COLUMN_NOTI_ID} INTEGER PRIMARY KEY,
      ${NOTI_DB_HELPER.COLUMN_LOOKUP_DATE} DATETIME(6)
    );
  ''');
  }

  Future<void> clearTable(String table) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.rawQuery("DELETE FROM $table");
  }

  Future<void> dropTable(String table) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.rawQuery("DROP TABLE $table");
  }
}
