import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/data/model/class/class_chat_model.dart';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';

import 'package:polarstar_flutter/app/data/repository/class/class_repository.dart';
import 'package:polarstar_flutter/main.dart';
import 'package:polarstar_flutter/session.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ClassChatController extends GetxController {
  // final ClassRepository repository;
  // ClassChatController({@required this.repository});

  // final classListAvailable = false.obs;
  // final classList = <ClassModel>[].obs;
  // final reviewList = <ClassRecentReviewModel>[].obs;

  // RxBool dataAvailbale = false.obs;

  // Future<void> refreshPage() async {
  //   await getClassList();
  // }

  // Future getClassList() async {
  //   Map<String, dynamic> jsonResponse = await repository.getRecentClass();

  //   switch (jsonResponse["statusCode"]) {
  //     case 200:
  //       classList(jsonResponse["classList"]);
  //       reviewList(jsonResponse["reviewList"]);
  //       classListAvailable(true);
  //       break;
  //     default:
  //       classListAvailable(false);
  //       printError(info: "Data Fetch ERROR!!");
  //   }
  // }

  // IO.Socket soc = null;
  final box = GetStorage();
  RxString roomID = "".obs;
  RxBool dataAvailble = false.obs;
  RxList<ClassChatModel> chatHistory = <ClassChatModel>[].obs;

  // Future<void> registerSocket() async {
  //   String currentSocketRoom = roomID.value;
  //   print("socketting function start : roomID - ${currentSocketRoom}");
  //   await socketting("${roomID.value}");
  // }

  // Future<void> socketting(String roomID) async {
  //   classChatSocket.onConnectError((data) => print(data));

  //   classChatSocket.on("viewRecentMessage", (data) {
  //     Iterable cc = data;
  //     chatHistory.value = cc.map((e) => ClassChatModel.fromJson(e)).toList();
  //     if (readFirstRecent) {
  //       readFirstRecent = false;
  //       int CHAT_ID = box.read("LastChat_${chatHistory.last.CLASS_ID}");
  //       for (ClassChatModel item in chatHistory) {
  //         if (item.CHAT_ID == CHAT_ID) {}
  //       }
  //       box.write(
  //           "LastChat_${chatHistory.last.CLASS_ID}", chatHistory.last.CHAT_ID);
  //     }
  //   });

  //   classChatSocket.on("newMessage", (data) {
  //     print("newMessage called");
  //     ClassChatModel chat = ClassChatModel.fromJson(data);
  //     print(chat.CLASS_ID);
  //     print("roomID : ${roomID}");
  //     if (chat.CLASS_ID == roomID) {
  //       chatHistory.add(chat);
  //     } else {
  //       Get.snackbar("왜 오냐 이건.. ㅅㅂ", "${chat.CLASS_ID}: ${chat.CONTENT}");
  //     }
  //   });

  //   classChatSocket.on('leaveRoom', (_) {
  //     print("leaveRoom called : roomID - ${roomID}");
  //   });

  //   classChatSocket.on('event', (data) => print(data));
  //   classChatSocket.onDisconnect((_) => print('disconnect!!!!'));
  //   classChatSocket.on('fromServer', (_) => print(_));

  //   // return socket;
  // }

  @override
  void onInit() async {
    // roomID.value = Get.arguments["roomID"];
    // print("controller init : room ID = ${roomID.value}");
    // print("controller init : ${classChatSocket.connected}");

    super.onInit();
    dataAvailble.value = true;
  }

  @override
  void onClose() async {
    // print("contoller close : ${roomID.value}");
    // await classChatSocket.emit("leaveRoom", roomID.value);
    // chatHistory.clear();
  }
}
