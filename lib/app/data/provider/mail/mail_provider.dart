import 'dart:convert';

import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/mail/mailBox_model.dart';
import 'package:polarstar_flutter/app/data/model/mail/mailSend_model.dart';

import 'package:polarstar_flutter/session.dart';

class MailApiClient {
  Future<Map<String, dynamic>> sendMailOut(
      int UNIQUE_ID, int COMMUNITY_ID, String content) async {
    Map mailData = {
      "UNIQUE_ID": '$UNIQUE_ID',
      "PROFILE_UNNAMED": '1',
      "CONTENT": '${content.trim()}',
      "COMMUNITY_ID": '$COMMUNITY_ID'
    };

    var response = await Session().postX("/message", mailData);

    return {
      "status": response.statusCode,
      "MAIL_BOX_ID": jsonDecode(response.body)["MAIL_BOX_ID"]
    };
  }

  Future<Map<String, dynamic>> sendMailIn(
      int MAIL_BOX_ID, String content) async {
    Map messageData = {
      "MAIL_BOX_ID": "${MAIL_BOX_ID}",
      'CONTENT': "${content}",
    };
    var response = await Session().postX("/message", messageData);
    return {"status": response.statusCode};
  }

  Future<Map<String, dynamic>> getMail(int MAIL_BOX_ID) async {
    //쪽지 내역 보기
    var response = await Session().getX("/message/${MAIL_BOX_ID}");

    if (response.statusCode != 200) {
      return {"status": response.statusCode, "listMailBox": []};
    }

    Map<String, dynamic> jsonReponse = jsonDecode(response.body);

    Iterable mailHistories = jsonReponse["MAIL"];

    List<MailHistoryModel> listMailHistory =
        mailHistories.map((model) => MailHistoryModel.fromJson(model)).toList();

    MailProfile profile = MailProfile.fromJson(jsonReponse["PROFILE"]);
    MailProfile target_profile =
        MailProfile.fromJson(jsonReponse["TARGET_PROFILE"]);

    return {
      "status": response.statusCode,
      "listMailHistory": listMailHistory,
      "profile": profile,
      "target_profile": target_profile
    };
  }

  Future<Map<String, dynamic>> getMailBox() async {
    //쪽지함 보기
    var response = await Session().getX("/message");

    print("adsfadsf");

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
