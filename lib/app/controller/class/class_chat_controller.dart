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

  IO.Socket soc = null;
  RxString roomID = "".obs;
  RxBool dataAvailble = false.obs;
  RxList<ClassChatModel> chatHistory = <ClassChatModel>[].obs;

  Future<void> registerSocket() async {
    soc = await socketting("${roomID.value}");
  }

  void sendMessage(String text) {
    soc.emit("sendMessage", {"content": text});
  }

  Future<IO.Socket> socketting(String roomID) async {
    IO.Socket socket = await IO.io(
        'http://13.209.5.161:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setExtraHeaders({'cookie': Session.headers["Cookie"]})
            .build());

    socket.onConnect((_) {
      socket.emit("joinRoom", [roomID, "fuckfuck"]);
    });

    socket.onConnectError((data) => print(data));

    socket.on("viewRecentMessage", (data) {
      Iterable cc = data;
      chatHistory.value = cc.map((e) => ClassChatModel.fromJson(e)).toList();
    });

    socket.on("newMessage", (data) {
      print(data);
      ClassChatModel chat = ClassChatModel.fromJson(data);
      if ("${chat.CLASS_ID}" == roomID) {
        chatHistory.add(chat);
      } else {
        Get.snackbar("왜 오냐 이건.. ㅅㅂ", "${chat.CLASS_ID}: ${chat.CONTENT}");
      }
    });
    socket.on('event', (data) => print(data));
    socket.onDisconnect((_) => print('disconnect!!!!'));
    socket.on('fromServer', (_) => print(_));

    return socket;
  }

  @override
  void onInit() async {
    roomID.value = Get.arguments["roomID"];
    print(roomID.value);
    await registerSocket();
    print(soc.connected);

    await soc.connect();
    super.onInit();
    dataAvailble.value = true;
  }

  @override
  void onClose() async {
    print("disconnecting...");
    await soc.emit("leaveRoom", roomID.value);

    await soc.disconnect();
    print("disconnect 완료");
    chatHistory.clear();
  }
}
