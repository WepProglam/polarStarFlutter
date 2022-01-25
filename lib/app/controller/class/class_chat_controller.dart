import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';
import 'package:polarstar_flutter/app/data/model/noti/noti_model.dart';

import 'package:polarstar_flutter/app/data/repository/class/class_repository.dart';
import 'package:polarstar_flutter/app/ui/android/functions/keyboard_visibility.dart';
import 'package:polarstar_flutter/main.dart';
import 'package:polarstar_flutter/session.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ClassChatController extends GetxController {
  final box = GetStorage();
  RxString roomID = "".obs;
  RxBool dataAvailble = false.obs;
  RxList<ChatModel> chatHistory = <ChatModel>[].obs;

  RxList<Rx<ChatModel>> tempChatHistory = <Rx<ChatModel>>[].obs;

  bool readFirstRecent = true;
  ScrollController chatScrollController;
  RxList<Rx<ChatBoxModel>> classChatBox = <Rx<ChatBoxModel>>[].obs;
  RxList<Rx<ChatBoxModel>> majorChatBox = <Rx<ChatBoxModel>>[].obs;
  RxInt currentClassID = 0.obs;
  RxBool canChatFileShow = false.obs;
  RxBool tapTextField = false.obs;
  final FocusNode chatFocusNode = new FocusNode();

  int findChatHistory() {
    int index = 0;
    for (Rx<ChatBoxModel> item in classChatBox) {
      if (item.value.BOX_ID == currentClassID.value) {
        return index;
      }
      index++;
    }
    return null;
  }

  void countingAmount(int curClassID) {
    int last_cid = box.read("LastChat_${curClassID}");

    // * 최근 메시지가 같이 왔을 때 카운팅
    bool isExist = false;
    for (Rx<ChatBoxModel> item in classChatBox) {
      print("${item.value.BOX_ID} : ${curClassID}");
      if (item.value.BOX_ID == curClassID) {
        int index = item.value.ChatList.length - 1;
        for (Rx<ChatModel> it in item.value.ChatList) {
          if (it.value.CHAT_ID == last_cid) {
            item.update((val) {
              val.AMOUNT = index;
            });
            isExist = true;
            break;
          }
          index--;
        }
      }
    }
    // * 최근 메시지가 없을 때 카운팅
    if (!isExist) {
      for (Rx<ChatBoxModel> item in classChatBox) {
        if (item.value.BOX_ID == curClassID) {
          item.update((val) {
            val.AMOUNT = item.value.ChatList.length > 100
                ? 100
                : item.value.ChatList.length;
          });
          break;
        }
      }
    }
  }

  Future<void> socketting() async {
    classChatSocket.on("viewRecentMessage", (data) {
      Iterable cc = data;
      print(data);
      tempChatHistory.clear();
      tempChatHistory.value = cc.map((e) => ChatModel.fromJson(e).obs).toList();

      // * 서버에서 역순으로 보내므로 다시 정렬
      tempChatHistory.value = tempChatHistory.reversed.toList();
      int curClassID = tempChatHistory[0].value.BOX_ID;
      // * 채팅 박스 모델에 최근 채팅 내역 가져옴
      for (Rx<ChatBoxModel> item in classChatBox) {
        if (item.value.BOX_ID == curClassID) {
          item.update((val) {
            val.ChatList.addAll(tempChatHistory);
          });
        }
      }
      // * 현재 들어가있을때
      if (currentClassID.value == curClassID) {
        box.write("LastChat_${tempChatHistory.last.value.BOX_ID}",
            tempChatHistory.last.value.CHAT_ID);
      }
      // * 안 읽은 개수 체크
      countingAmount(curClassID);
    });

    classChatSocket.on("newMessage", (data) async {
      Rx<ChatModel> chat = ChatModel.fromJson(data).obs;

      for (Rx<ChatBoxModel> item in classChatBox) {
        if (item.value.BOX_ID == chat.value.BOX_ID) {
          item.update((val) {
            // * 채팅방 수정
            val.ChatList.add(chat.value.obs);

            // * 단톡방 미리보기 수정
            val.LAST_CHAT = chat.value.CONTENT;
            val.TIME_LAST_CHAT_SENDED = chat.value.TIME_CREATED;
          });
        }
      }

      // * 현재 들어가있을때
      if (currentClassID.value == chat.value.BOX_ID) {
        await box.write("LastChat_${chat.value.BOX_ID}", chat.value.CHAT_ID);
      }

      // * 안 읽은 개수 체크
      countingAmount(chat.value.BOX_ID);
    });

    classChatSocket.on('leaveRoom', (_) {
      // print("leaveRoom called : roomID - ${roomID}");
    });

    classChatSocket.on('event', (data) => print(data));
    classChatSocket.on('fromServer', (_) => print(_));

    // return socket;
  }

  void sendMessage(String text) {
    print(currentClassID.value);
    classChatSocket
        .emit("sendMessage", {"content": text, "roomId": currentClassID.value});
  }

  Future<void> registerSocket() async {
    await socketting();
  }

  Future<void> getChatBox() async {
    var response = await Session().getX("/chat/chatBox");
    var jsonResponse = jsonDecode(response.body);
    Iterable classChatBoxList = jsonResponse["classChatBox"];
    Iterable majorChatBoxList = jsonResponse["majorChatBox"];
    classChatBox.value =
        classChatBoxList.map((e) => ChatBoxModel.fromJson(e).obs).toList().obs;

    majorChatBox.value =
        majorChatBoxList.map((e) => ChatBoxModel.fromJson(e).obs).toList().obs;

    box.remove("classSocket");
    List<ChatBoxModel> tempClassList = [];
    for (Rx<ChatBoxModel> item in classChatBox) {
      tempClassList.add(item.value);
      classChatSocket.emit("joinRoom", [item.value.BOX_ID, "fuckfuck"]);
      await classChatSocket.emit("getChatLog", [item.value.BOX_ID, 0]);
    }

    tempClassList.clear();
    for (Rx<ChatBoxModel> item in majorChatBox) {
      tempClassList.add(item.value);
      classChatSocket.emit("joinRoom", [item.value.BOX_ID, "fuckfuck"]);
      await classChatSocket.emit("getChatLog", [item.value.BOX_ID, 0]);
    }
    return;
  }

  void setCurrentClassID(int id) {
    currentClassID.value = id;
  }

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

  // Future<void> registerSocket() async {
  //   String currentSocketRoom = roomID.value;
  //   print("socketting function start : roomID - ${currentSocketRoom}");
  //   await socketting("${roomID.value}");
  // }

  // Future<void> socketting(String roomID) async {
  //   classChatSocket.onConnectError((data) => print(data));

  //   classChatSocket.on("viewRecentMessage", (data) {
  //     Iterable cc = data;
  //     chatHistory.value = cc.map((e) => ChatModel.fromJson(e)).toList();
  //     if (readFirstRecent) {
  //       readFirstRecent = false;
  //       int CHAT_ID = box.read("LastChat_${chatHistory.last.BOX_ID}");
  //       for (ChatModel item in chatHistory) {
  //         if (item.CHAT_ID == CHAT_ID) {}
  //       }
  //       box.write(
  //           "LastChat_${chatHistory.last.BOX_ID}", chatHistory.last.CHAT_ID);
  //     }
  //   });

  //   classChatSocket.on("newMessage", (data) {
  //     print("newMessage called");
  //     ChatModel chat = ChatModel.fromJson(data);
  //     print(chat.BOX_ID);
  //     print("roomID : ${roomID}");
  //     if (chat.BOX_ID == roomID) {
  //       chatHistory.add(chat);
  //     } else {
  //       Get.snackbar("왜 오냐 이건.. ㅅㅂ", "${chat.BOX_ID}: ${chat.CONTENT}");
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

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   // Timer(Duration(milliseconds: 1000), () {
    //   //   chatScrollController
    //   //       .jumpTo(chatScrollController.position.maxScrollExtent);
    //   // });
    //   chatScrollController
    //       .jumpTo(chatScrollController.position.maxScrollExtent);
    // });

    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //  chatScrollController
    //       .jumpTo(chatScrollController.position.maxScrollExtent);
    // });

    super.onInit();

    // KeyboardVisibilityNotification().addNewListener(onHide: () {
    //   //키보드가 내려갔을 때
    //   print("!!!!!hide");
    //   Get.snackbar("asdfasdfasdf", "ASfasdfasdf");
    // });
    chatScrollController = ScrollController(initialScrollOffset: 0.0);

    ever(classChatBox, (_) {
      print("char box ${classChatBox}");
    });

    chatFocusNode.addListener(() {
      print("???????!!!!!!!!!!!!!!!!");
      print(chatFocusNode.hasFocus);
    });
    dataAvailble.value = true;
  }

  RxList<Rx<ChatModel>> get getClassHistory {
    print("!!!!");
    print(classChatBox);
    for (Rx<ChatBoxModel> item in classChatBox) {
      print("${item.value.BOX_ID} - ${currentClassID.value}");
      if (item.value.BOX_ID == currentClassID.value) {
        return item.value.ChatList;
      }
    }
  }

  @override
  void onClose() async {
    // print("contoller close : ${roomID.value}");
    // await classChatSocket.emit("leaveRoom", roomID.value);
    // chatHistory.clear();
  }
}
