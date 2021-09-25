import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/mail/mailBox_model.dart';
import 'package:polarstar_flutter/app/data/provider/sqflite/database_helper.dart';
import 'package:sqflite/sqflite.dart';

mixin MAIL_DB_HELPER implements DatabaseHelper {
  static final COLUMN_MAIL_ID = 'MAIL_ID';
  static final COLUMN_MAIL_BOX_ID = 'MAIL_BOX_ID';
  static final COLUMN_LOOKUP_DATE = 'LOOKUP_DATE';
  static final table = "MAIL";

  static Future<void> insert(SaveMailBoxModel mailBox) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.insert(
      table,
      mailBox.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> update(SaveMailBoxModel mailBox) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.update(
      table,
      mailBox.toJson(),
      where: '${COLUMN_MAIL_BOX_ID} = ? ',
      whereArgs: [mailBox.MAIL_BOX_ID],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<RxList<SaveMailBoxModel>> queryAllRows() async {
    final Database db = await DatabaseHelper.instance.database;
    Iterable res = await db.query(
      table,
    );
    RxList<SaveMailBoxModel> listReadNoties =
        res.map((e) => SaveMailBoxModel.fromJson(e)).toList().obs;
    return listReadNoties;
  }

  static Future<int> delete(int MAIL_BOX_ID) async {
    final Database db = await DatabaseHelper.instance.database;
    return await db.delete(table,
        where: '${COLUMN_MAIL_BOX_ID} = ?', whereArgs: [MAIL_BOX_ID]);
  }
}
