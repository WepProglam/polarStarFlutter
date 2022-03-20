import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/noti/noti_model.dart';
import 'package:polarstar_flutter/app/modules/noti/noti_controller.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:pushy_flutter/pushy_flutter.dart';

String deviceToken;

class PushyController extends GetxController with WidgetsBindingObserver {
  onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> push_register_total() async {
    Pushy.listen();

    await pushyRegister();
    Pushy.setNotificationIcon('ic_launcher');
    Pushy.toggleInAppBanner(false);
    print("toggle app bar");
    // Listen for push notifications received
    Pushy.setNotificationListener(backgroundNotificationListener);
    pushyClickListener();
    Pushy.clearBadge();
  }

  void backgroundNotificationListener(Map<String, dynamic> data) {
    // Print notification payload data
    print('Received notification: $data');

    // Notification title
    String notificationTitle = data['TITLE'];

    // Attempt to extract the "message" property from the payload: {"message":"Hello World!"}
    String notificationText = data['CONTENT'];

    String url = data["URL"];

    if (Get.isRegistered<NotiController>()) {
      print("registered");
      NotiController notiController = Get.find<NotiController>();
      switch (data["NOTI_TYPE"].toString()) {
        // * 커뮤니티
        case "0":
          notiController.noties.insert(0, NotiModel.fromJson(data).obs);
          break;
        // * 개인 공지
        case "3":
          notiController.noties.insert(0, NotiModel.fromJson(data).obs);
          break;
        // * 전체 공지
        case "4":
          notiController.noties.insert(0, NotiModel.fromJson(data).obs);
          break;
        // * 핫보드 알림
        case "8":
          notiController.noties.insert(0, NotiModel.fromJson(data).obs);
          break;
        default:
          break;
      }
    } else {
      print("not registed");
    }

    // if (Platform.isIOS) {
    //   Pushy.notify(notificationTitle, notificationText, data);
    // } else {
    switch (WidgetsBinding.instance.lifecycleState) {
      case AppLifecycleState.resumed:
        break;
      default:
        Pushy.notify(notificationTitle, notificationText, data);
        break;
    }
    // }
  }

  Future pushyRegister() async {
    print("pushy Register");
    try {
      deviceToken = await Pushy.register();

      print('Device token: $deviceToken');
    } on PlatformException catch (error) {
      print(error);
    }
  }

  void pushyClickListener() {
    // Listen for push notification clicked
    Pushy.setNotificationClickListener((Map<String, dynamic> data) {
      // Print notification payload data
      print('Notification clicked: $data');

      switch (data["NOTI_TYPE"].toString()) {
        // * 커뮤니티
        case "0":
          Get.toNamed(Routes.NOTI);
          // Get.toNamed(
          //     "/board/${data["URL"].toString().split("/")[1]}/read/${data["URL"].toString().split("/")[3]}");
          break;
        // * 개인 공지
        case "3":
          Get.toNamed(Routes.NOTI);
          print("??");
          break;
        // * 전체 공지
        case "4":
          Get.toNamed(Routes.NOTI);
          print("??");
          break;
        // * 핫보드 알림
        case "8":
          Get.toNamed(Routes.NOTI);
          // Get.toNamed(
          //     "/board/${data["URL"].toString().split("/")[1]}/read/${data["URL"].toString().split("/")[3]}");
          break;
        default:
          break;
      }
    });
    Pushy.clearBadge();
  }

  onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('state = $state');
  }
}
