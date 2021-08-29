import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';

import 'package:polarstar_flutter/app/data/provider/class/class_provider.dart';

class ClassRepository {
  final ClassApiClient apiClient;

  ClassRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<Map<String, dynamic>> getClassList() async {
    final response = await apiClient.getClassList();

    if (response.statusCode != 200) {
      return {"statusCode": response.statusCode};
    } else {
      // Map List를 Class model List로 만듦
      Iterable jsonResponse = json.decode(response.body);

      List classList = jsonResponse.map((e) => ClassModel.fromJson(e)).toList();

      return {"statusCode": 200, "classList": classList};
    }
  }
}
