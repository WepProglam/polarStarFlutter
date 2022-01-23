import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/controller/class/class_chat_controller.dart';
import 'package:polarstar_flutter/app/data/model/class/class_chat_model.dart';

import 'package:polarstar_flutter/app/data/model/login_model.dart';
import 'package:polarstar_flutter/app/data/model/noti/noti_model.dart';
import 'package:polarstar_flutter/app/data/repository/login_repository.dart';
import 'package:meta/meta.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:polarstar_flutter/main.dart';
import 'package:polarstar_flutter/session.dart';

class InitController extends GetxController {
  final LoginRepository repository;
  final box = GetStorage();

  InitController({@required this.repository}) : assert(repository != null);

  RxInt mainPageIndex = 0.obs;
  RxList<Rx<ChatBoxModel>> chatBox = <Rx<ChatBoxModel>>[].obs;
  RxInt currentClassID = 0.obs;
  RxBool canChatFileShow = false.obs;
  RxBool tapTextField = false.obs;
  final FocusNode chatFocusNode = new FocusNode();

  ScrollController chatScrollController;

  Future<String> checkFcmToken() async {
    String FcmToken;
    await FirebaseMessaging.instance.getToken().then((token) {
      FcmToken = token;
    });
    return FcmToken;
  }

  bool needRefreshToken(String curFcmToken) {
    String oldFcmToken = box.read("FcmToken");
    print(curFcmToken);
    print(oldFcmToken);
    return (oldFcmToken != curFcmToken);
  }

  Future<void> tokenRefresh(String FcmToken) async {
    Map<String, String> data = {"FcmToken": FcmToken};
    print(data);
    final int response = await repository.tokenRefresh(data);
    switch (response) {
      case 200:
        break;
      default:
    }
    box.write("FcmToken", FcmToken);

    print("fcm return : ${response}");
    return;
  }

  RxList<Rx<ClassChatModel>> tempChatHistory = <Rx<ClassChatModel>>[].obs;

  bool readFirstRecent = true;

  int findChatHistory() {
    int index = 0;
    for (Rx<ChatBoxModel> item in chatBox) {
      if (item.value.CLASS_ID == currentClassID.value) {
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
    for (Rx<ChatBoxModel> item in chatBox) {
      print("${item.value.CLASS_ID} : ${curClassID}");
      if (item.value.CLASS_ID == curClassID) {
        int index = item.value.ClassChatList.length - 1;
        for (Rx<ClassChatModel> it in item.value.ClassChatList) {
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
      for (Rx<ChatBoxModel> item in chatBox) {
        if (item.value.CLASS_ID == curClassID) {
          item.update((val) {
            val.AMOUNT = item.value.ClassChatList.length > 100
                ? 100
                : item.value.ClassChatList.length;
          });
          break;
        }
      }
    }
  }

  Future<void> socketting() async {
    // classChatSocket.onConnectError((data) => print(data));

    classChatSocket.on("viewRecentMessage", (data) {
      Iterable cc = data;
      print(data);
      tempChatHistory.clear();
      tempChatHistory.value =
          cc.map((e) => ClassChatModel.fromJson(e).obs).toList();

      // * 서버에서 역순으로 보내므로 다시 정렬
      tempChatHistory.value = tempChatHistory.reversed.toList();
      int curClassID = tempChatHistory[0].value.CLASS_ID;
      // * 채팅 박스 모델에 최근 채팅 내역 가져옴
      for (Rx<ChatBoxModel> item in chatBox) {
        if (item.value.CLASS_ID == curClassID) {
          item.update((val) {
            val.ClassChatList.addAll(tempChatHistory);
          });
        }
      }

      // * 현재 들어가있을때
      if (currentClassID.value == curClassID) {
        box.write("LastChat_${tempChatHistory.last.value.CLASS_ID}",
            tempChatHistory.last.value.CHAT_ID);
      }

      // * 안 읽은 개수 체크
      countingAmount(curClassID);
    });

    classChatSocket.on("newMessage", (data) async {
      Rx<ClassChatModel> chat = ClassChatModel.fromJson(data).obs;

      for (Rx<ChatBoxModel> item in chatBox) {
        if (item.value.CLASS_ID == chat.value.CLASS_ID) {
          item.update((val) {
            // * 채팅방 수정
            val.ClassChatList.add(chat.value.obs);

            // * 단톡방 미리보기 수정
            val.LAST_CHAT = chat.value.CONTENT;
            val.TIME_LAST_CHAT_SENDED = chat.value.TIME_CREATED;
          });
        }
      }

      // * 현재 들어가있을때
      if (currentClassID.value == chat.value.CLASS_ID) {
        await box.write("LastChat_${chat.value.CLASS_ID}", chat.value.CHAT_ID);
      }

      // * 안 읽은 개수 체크
      countingAmount(chat.value.CLASS_ID);
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
    Iterable chatBoxList = jsonResponse["classChatBox"];
    chatBox.value =
        chatBoxList.map((e) => ChatBoxModel.fromJson(e).obs).toList().obs;
    box.remove("classSocket");
    List<ChatBoxModel> tempClassList = [];
    for (Rx<ChatBoxModel> item in chatBox) {
      tempClassList.add(item.value);
      classChatSocket.emit("joinRoom", [item.value.CLASS_ID, "fuckfuck"]);
      print("CLASS ID : ${item.value.CLASS_ID}");
      await classChatSocket.emit("getChatLog", [item.value.CLASS_ID, 0]);
    }
    return;
  }

  Future autoLogin(String id, String pw) async {
    String user_id = id;
    String user_pw = pw;

    Map<String, String> data = {
      'id': user_id,
      'pw': user_pw,
    };

    final response = await repository.login(data);

    switch (response["statusCode"]) {
      case 200:
        Get.snackbar("로그인 성공", "로그인 성공");

        break;
      default:
        Get.snackbar("로그인 실패", "로그인 실패");
    }
    return response;
  }

  Future<bool> checkLogin() async {
    print(box.read("id"));
    if (box.hasData('isAutoLogin') && box.hasData('id') && box.hasData('pw')) {
      var res = await autoLogin(box.read('id'), box.read('pw'));
      print(box.read('id'));
      print("login!!");

      switch (res["statusCode"]) {
        case 200:
          return true;
          break;
        default:
          return false;
      }
    }
    print("no login");
    print(box.hasData('isAutoLogin'));
    print(box.hasData('id'));
    print(box.hasData('pw'));
    return false;
  }

  void setCurrentClassID(int id) {
    currentClassID.value = id;
  }

  @override
  void onInit() async {
    super.onInit();
    chatScrollController = ScrollController(initialScrollOffset: 0.0);

    ever(chatBox, (_) {
      print("char box ${chatBox}");
    });

    chatFocusNode.addListener(() {
      print("???????!!!!!!!!!!!!!!!!");
      print(chatFocusNode.hasFocus);
    });
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   chatScrollController
    //       .jumpTo(chatScrollController.position.maxScrollExtent);
    // });

    // ever(chatScrollController, (_) {
    //   print("has client!");
    // });

    // firebaseCloudMessaging_Listeners();
  }

  // @override
  // void onReady() async {
  //   print("onready");
  // }

  RxList<Rx<ClassChatModel>> get getClassHistory {
    print("!!!!");
    print(chatBox);
    for (Rx<ChatBoxModel> item in chatBox) {
      print("${item.value.CLASS_ID} - ${currentClassID.value}");
      if (item.value.CLASS_ID == currentClassID.value) {
        return item.value.ClassChatList;
      }
    }
  }
}
