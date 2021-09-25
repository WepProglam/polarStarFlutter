import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/data/provider/sqflite/database_helper.dart';
import 'package:sqflite/sqflite.dart';

mixin COMMUNITY_DB_HELPER implements DatabaseHelper {
  static final COLUMN_COMMUNITY_ID = 'COMMUNITY_ID';
  static final COLUMN_COMMUNITY_NAME = 'COMMUNITY_NAME';
  static final COLUMN_isFollowed = 'isFollowed';
  static final COLUMN_RECENT_TITLE = 'RECENT_TITLE';
  static final table = "COMMUNITY";

  static Future<void> insert(BoardInfo board) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.insert(
      table,
      board.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Rx<BoardInfo>>> queryAllRows() async {
    final Database db = await DatabaseHelper.instance.database;
    Iterable res =
        await db.query(table, orderBy: "${COLUMN_COMMUNITY_ID} DESC");
    print(res);
    List<Rx<BoardInfo>> listFollwingCommunity =
        res.map((e) => BoardInfo.fromJson(e).obs).toList();
    return listFollwingCommunity;
  }

  static Future<int> delete(int COMMUNITY_ID) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(table,
        where: '${COLUMN_COMMUNITY_ID} = ?', whereArgs: [COMMUNITY_ID]);
  }
}
