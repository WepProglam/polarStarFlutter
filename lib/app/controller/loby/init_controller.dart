import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:polarstar_flutter/app/controller/class/class_chat_controller.dart';

import 'package:polarstar_flutter/app/data/model/login_model.dart';
import 'package:polarstar_flutter/app/data/model/noti/noti_model.dart';
import 'package:polarstar_flutter/app/data/repository/login_repository.dart';
import 'package:meta/meta.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:polarstar_flutter/main.dart';
import 'package:polarstar_flutter/session.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class InitController extends GetxController {
  final LoginRepository repository;
  final box = GetStorage();

  InitController({@required this.repository}) : assert(repository != null);

  RxInt mainPageIndex = 0.obs;

  Future<String> checkFcmToken() async {
    String FcmToken;
    await FirebaseMessaging.instance.getToken().then((token) {
      FcmToken = token;
    });
    return FcmToken;
  }

  bool needRefreshToken(String curFcmToken) {
    String oldFcmToken = box.read("FcmToken");
    //print(curFcmToken);
    //print(oldFcmToken);
    return (oldFcmToken != curFcmToken);
  }

  Future<void> tokenRefresh(String FcmToken) async {
    Map<String, String> data = {"FcmToken": FcmToken};
    //print(data);
    final int response = await repository.tokenRefresh(data);
    switch (response) {
      case 200:
        break;
      default:
    }
    box.write("FcmToken", FcmToken);

    //print("fcm return : ${response}");
    return;
  }

  @override
  void onInit() async {
    super.onInit();

    // box.remove("alreadyRunned");
  }

  // @override
  // void onReady() async {
  //   print("onready");
  // }

}

class ManagePermission {
  static Future<bool> getPermission() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.storage, Permission.camera].request();

    PermissionStatus permissionStorage = statuses[Permission.storage];
    // PermissionStatus permissionCamera = statuses[Permission.camera];
    // print(permissionStorage.toString());
    // print(permissionStorage.isGranted);
    if (permissionStorage.isGranted) {
      // print("????");
      return true;
    } else {
      openAppSettings();
      return false;
    }
  }
}
