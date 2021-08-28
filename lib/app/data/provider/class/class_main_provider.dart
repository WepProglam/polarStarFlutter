import 'dart:convert';

import 'package:polarstar_flutter/app/data/model/class/class_main_model.dart';

import 'package:polarstar_flutter/session.dart';

class ClassMainApiClient {
  Future getClassMain() async {
    final response = await Session().getX('/class');
    if (response.statusCode != 200) {
      return {"statusCode": response.statusCode};
    } else {
      Iterable jsonResponse = json.decode(response.body);

      List classMainList =
          jsonResponse.map((e) => ClassMain.fromJson(e)).toList();

      return {"statusCode": 200, "classMainList": classMainList};
    }
  }
}
