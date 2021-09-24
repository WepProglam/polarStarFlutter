import 'dart:convert';

import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/model/mail/mailBox_model.dart';
import 'package:polarstar_flutter/app/data/provider/mail/mail_provider.dart';
import 'package:polarstar_flutter/app/data/provider/noti/noti_provider.dart';

class NotiRepository {
  final NotiApiClient apiClient;

  NotiRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<Map<String, dynamic>> getMailBox() async {
    //쪽지함 보기
    var response = await apiClient.getMailBox();
    if (response.statusCode != 200) {
      return {"status": response.statusCode, "listMailBox": []};
    }

    print(response.statusCode);

    Iterable jsonReponse = jsonDecode(response.body);

    List<Rx<MailBoxModel>> listMailBox =
        jsonReponse.map((model) => MailBoxModel.fromJson(model).obs).toList();

    return {"status": response.statusCode, "listMailBox": listMailBox};
  }
}
