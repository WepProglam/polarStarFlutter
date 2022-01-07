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

  IO.Socket socket;
  RxString roomID = "".obs;
  RxBool dataAvailble = false.obs;
  RxList<ClassChatModel> chatHistory = <ClassChatModel>[].obs;

  Future<void> registerSocket() async {
    socket = await socketting("${roomID.value}");
    socket.connect();
  }

  void sendMessage(String text) {
    socket.emit("sendMessage", text);
  }

  Future<IO.Socket> socketting(String roomID) async {
    final box = GetStorage();
    // * session 달기
    IO.Socket socket = await IO.io(
        'http://13.209.5.161:3000',
        IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
            {'cookie': Session.headers["Cookie"]}).build());

    socket.onConnect((_) {
      print('connect');
      socket.emit("joinRoom", [roomID, "fuckfuck"]);

      // List<dynamic> classSocketList = box.read("classSocket");
      // for (var item in classSocketList) {
      //   print("joining ${item}...");
      // }
    });

    socket.onConnectError((data) => print(data));
    // socket.on(event, (data) => null)
    socket.on("viewRecentMessage", (data) {
      // ClassChatModel.fromJson(data);
      // chatHistory.value = data;
      print(data);
      Iterable cc = data;

      chatHistory.value = cc.map((e) => ClassChatModel.fromJson(e)).toList();
    });

    socket.on("newMessage", (data) {
      ClassChatModel chat = ClassChatModel.fromJson(data);
      chatHistory.add(chat);
      // // print(chat.CLASS_ID);

      // Get.snackbar("${data["USERNAME"]}", "${data["CONTENT"]}");
    });
    socket.on('event', (data) => print(data));
    socket.onDisconnect((_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));

    return socket;
  }

  @override
  void onInit() async {
    // await getClassList();
    roomID.value = Get.arguments["roomID"];
    await registerSocket();
    super.onInit();
    dataAvailble.value = true;
    // dataAvailbale.value = true;
  }
}
