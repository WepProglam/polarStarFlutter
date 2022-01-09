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
  RxString roomID = "".obs;
  RxBool dataAvailble = false.obs;
  RxList<ClassChatModel> chatHistory = <ClassChatModel>[].obs;

  Future<void> registerSocket() async {
    await socketting("${roomID.value}");
  }

  void sendMessage(String text) {
    classChatSocket.emit("sendMessage", {"content": text});
  }

  Future<void> socketting(String roomID) async {
    // IO.Socket socket = await IO.io(
    //     'http://13.209.5.161:3000',
    //     IO.OptionBuilder()
    //         .setTransports(['websocket'])
    //         .disableAutoConnect()
    //         .setExtraHeaders({'cookie': Session.headers["Cookie"]})
    //         .build());

    // classChatSocket.onConnect((_) {
    //   classChatSocket.emit("joinRoom", [roomID, "fuckfuck"]);
    // });

    classChatSocket.emit("joinRoom", [roomID, "fuckfuck"]);

    classChatSocket.onConnectError((data) => print(data));

    classChatSocket.on("viewRecentMessage", (data) {
      Iterable cc = data;
      chatHistory.value = cc.map((e) => ClassChatModel.fromJson(e)).toList();
    });

    classChatSocket.on("newMessage", (data) {
      print(data);
      ClassChatModel chat = ClassChatModel.fromJson(data);
      if ("${chat.CLASS_ID}" == roomID) {
        chatHistory.add(chat);
      } else {
        Get.snackbar("왜 오냐 이건.. ㅅㅂ", "${chat.CLASS_ID}: ${chat.CONTENT}");
      }
    });
    classChatSocket.on('event', (data) => print(data));
    classChatSocket.onDisconnect((_) => print('disconnect!!!!'));
    classChatSocket.on('fromServer', (_) => print(_));

    // return socket;
  }

  @override
  void onInit() async {
    roomID.value = Get.arguments["roomID"];
    print(roomID.value);
    await registerSocket();
    print(classChatSocket.connected);

    super.onInit();
    dataAvailble.value = true;
  }

  @override
  void onClose() async {
    print("leaving...");
    await classChatSocket.emit("leaveRoom", roomID.value);

    // await classChatSocket.disconnect();
    // print("disconnect 완료");
    chatHistory.clear();
  }
}
