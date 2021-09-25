import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/mail/mailBox_model.dart';
import 'package:polarstar_flutter/app/data/model/mail/mailSend_model.dart';

import 'package:polarstar_flutter/session.dart';

class NotiApiClient {
  Future getMailBox() async {
    //쪽지함 보기
    var response = await Session().getX("/message");
    return response;
  }
}
