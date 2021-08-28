import 'dart:convert';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';

import 'package:polarstar_flutter/session.dart';

class ClassApiClient {
  Future getClassMain() async {
    final response = await Session().getX('/class');
    if (response.statusCode != 200) {
      return {"statusCode": response.statusCode};
    } else {
      Iterable jsonResponse = json.decode(response.body);

      List classList = jsonResponse.map((e) => Class.fromJson(e)).toList();

      return {"statusCode": 200, "classMainList": classList};
    }
  }
}
