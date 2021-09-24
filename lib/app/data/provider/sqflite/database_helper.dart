import 'dart:io';

import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/data/provider/sqflite/src/db_community.dart';
import 'package:polarstar_flutter/app/data/provider/sqflite/src/db_noti.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_migration/sqflite_migration.dart';

class DatabaseHelper {
  static final _databaseName = "info.db";
  static final _databaseVersion = 3;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  final initialScript = [
    '''
    CREATE TABLE INFO (
      ${COMMUNITY_DB_HELPER.COLUMN_COMMUNITY_ID} INTEGER PRIMARY KEY,
      ${COMMUNITY_DB_HELPER.COLUMN_COMMUNITY_NAME} VARCHAR(50) NOT NULL,
      ${COMMUNITY_DB_HELPER.COLUMN_isFollowed} VARCHAR(50),
      ${COMMUNITY_DB_HELPER.COLUMN_RECENT_TITLE} VARCHAR(50)
    );
  '''
  ];

  final migrations = [
    //   '''
    //   CREATE TABLE ${COMMUNITY_DB_HELPER.table} (
    //     ${COMMUNITY_DB_HELPER.COLUMN_COMMUNITY_ID} INTEGER PRIMARY KEY,
    //     ${COMMUNITY_DB_HELPER.COLUMN_COMMUNITY_NAME} VARCHAR(50) NOT NULL,
    //     ${COMMUNITY_DB_HELPER.COLUMN_isFollowed} VARCHAR(50),
    //     ${COMMUNITY_DB_HELPER.COLUMN_RECENT_TITLE} VARCHAR(50)
    //   );
    // ''',
    '''
    ALTER TABLE INFO RENAME TO ${COMMUNITY_DB_HELPER.table} 
  ''',
    '''
    CREATE TABLE ${NOTI_DB_HELPER.table} (
      ${NOTI_DB_HELPER.COLUMN_NOTI_ID} INTEGER PRIMARY KEY,
      ${NOTI_DB_HELPER.COLUMN_LOOKUP_DATE} DATETIME(6)
    );
  '''
  ];

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    final config = MigrationConfig(
        initializationScript: initialScript, migrationScripts: migrations);
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabaseWithMigration(path, config);
    // return await openDatabase(path,
    //     version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    String path = join(await getDatabasesPath(), _databaseName);
    if (newVersion > oldVersion) {
      await File(path).delete();
      await _onCreate(db, newVersion);
      return;
    }
    return await _onCreate(_database, _databaseVersion);
  }

  Future onCreate() async {
    return await _onCreate(_database, _databaseVersion);
  }

  Future _onCreate(Database db, int version) async {}

  Future<void> clearTable(String table) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.rawQuery("DELETE FROM $table");
  }

  Future<void> dropTable(String table) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.rawQuery("DROP TABLE $table");
  }
}
