import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/session.dart';
import 'package:pushy_flutter/pushy_flutter.dart';

final box = GetStorage();

class PuhsyController {
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
    } catch (e) {}
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
}
