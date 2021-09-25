import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/data/model/noti/noti_model.dart';
import 'package:polarstar_flutter/app/data/provider/sqflite/database_helper.dart';
import 'package:sqflite/sqflite.dart';

mixin NOTI_DB_HELPER implements DatabaseHelper {
  static final COLUMN_NOTI_ID = 'NOTI_ID';
  static final COLUMN_LOOKUP_DATE = 'LOOKUP_DATE';
  static final table = "NOTI";

  static Future<void> insert(SaveNotiModel noti) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.insert(
      table,
      noti.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> update(SaveNotiModel noti) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.update(
      table,
      noti.toJson(),
      where: '${COLUMN_NOTI_ID} = ? ',
      whereArgs: [noti.NOTI_ID],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<RxList<SaveNotiModel>> queryAllRows() async {
    final Database db = await DatabaseHelper.instance.database;
    Iterable res = await db.query(
      table,
    );
    RxList<SaveNotiModel> listReadNoties =
        res.map((e) => SaveNotiModel.fromJson(e)).toList().obs;
    return listReadNoties;
  }

  static Future<int> delete(int NOTI_ID) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db
        .delete(table, where: '${COLUMN_NOTI_ID} = ?', whereArgs: [NOTI_ID]);
  }
}
