import 'dart:convert';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';

import 'package:polarstar_flutter/session.dart';

class ClassApiClient {
  Future getClassList() async {
    final response = await Session().getX('/class');
    return response;
  }
}
