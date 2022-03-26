import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/data/model/noti/noti_model.dart';
import 'package:polarstar_flutter/app/modules/noti/noti_controller.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:polarstar_flutter/session.dart';
import 'package:pushy_flutter/pushy_flutter.dart';

final box = GetStorage();

String deviceToken;

class PushyController extends GetxController with WidgetsBindingObserver {
  onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  static Future<int> pushySubscribe(String topic) async {
    try {
      if (await Pushy.isRegistered()) {
        print("subscribe");
        var response = await Session()
            .getX("/notification/push-noti/subscribe/topic/${topic}");
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(await Pushy.subscribe(topic));
          List<dynamic> topicList = await box.read("pushNotiSubscribeList");
          print(topicList);

          if (topicList == null) {
            topicList = [topic];
          } else if (topicList.contains(topic)) {
          } else {
            topicList.add(topic);
          }
          print("??@!!@");
          await box.write("pushNotiSubscribeList", topicList);
          return 200;
        }
      }
    } catch (e) {}
    return 500;
  }

  static Future<int> pushyUnsubscribe(String topic) async {
    try {
      if (await Pushy.isRegistered()) {
        print("????");
        var response = await Session()
            .getX("/notification/push-noti/unsubscribe/topic/${topic}");
        print(response.statusCode);
        if (response.statusCode == 200) {
          await Pushy.unsubscribe(topic);
          List<dynamic> topicList = await box.read("pushNotiSubscribeList");
          if (topicList.contains(topic)) {
            topicList.removeWhere((element) => element == topic);
          } else {}
          await box.write("pushNotiSubscribeList", topicList);
          return 200;
        }
      }
    } catch (e) {
      print(e);
    }
    return 500;
  }

  static Future<bool> checkSubscribe(String topic) async {
    List<dynamic> topicList = await box.read("pushNotiSubscribeList");
    if (topicList == null || topicList.isEmpty) {
      return false;
    } else if (topicList.contains(topic)) {
      return true;
    } else {
      return false;
    }
  }

  static Future refreshDeviceToken() async {
    try {
      print("device token");
      print(deviceToken);
      await Session().postX("/login/deviceToken", {"deviceToken": deviceToken});
      print("sibal");
    } catch (e) {
      print(e);
    }
  }

  Future<void> push_register_total() async {
    print("push register total");
    Pushy.listen();
    Pushy.setNotificationIcon('ic_launcher');

    await pushyRegister();

    Pushy.toggleInAppBanner(false);

    Pushy.setNotificationListener(backgroundNotificationListener);
    pushyClickListener();
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

  Future<void> pushyRegister() async {
    print("pushy Register");
    try {
      print("??????");
      deviceToken = await Pushy.register();
      print("???????");
      print('Device token: $deviceToken');
    } catch (error) {
      print("error");
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
