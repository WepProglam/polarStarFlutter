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
  RxInt currentBoxID = 0.obs;
  RxBool canChatFileShow = false.obs;
  RxBool tapTextField = false.obs;
  final FocusNode chatFocusNode = new FocusNode();

  Map<String, dynamic> findChatHistory() {
    int index = 0;
    // * class
    for (Rx<ChatBoxModel> item in classChatBox) {
      if (item.value.BOX_ID == currentBoxID.value) {
        return {"isClass": true, "index": index};
      }
      index++;
    }

    // * major
    index = 0;
    for (Rx<ChatBoxModel> item in majorChatBox) {
      if (item.value.BOX_ID == currentBoxID.value) {
        return {"isClass": false, "index": index};
      }
      index++;
    }
    return null;
  }

  void countingAmountClassChat(int curClassID) {
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

  void countingAmountMajorChat(int curMajorID) {
    int last_cid = box.read("LastChat_${curMajorID}");

    // * 최근 메시지가 같이 왔을 때 카운팅
    bool isExist = false;
    for (Rx<ChatBoxModel> item in majorChatBox) {
      print("${item.value.BOX_ID} : ${curMajorID}");
      if (item.value.BOX_ID == curMajorID) {
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
          print(index);
        }
      }
    }
    // * 최근 메시지가 없을 때 카운팅
    if (!isExist) {
      for (Rx<ChatBoxModel> item in majorChatBox) {
        if (item.value.BOX_ID == curMajorID) {
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

  void countTotal(int BOX_ID, bool isClass) {
    if (isClass) {
      countingAmountClassChat(BOX_ID);
    } else {
      countingAmountMajorChat(BOX_ID);
    }
    return;
  }

  Future<void> socketting() async {
    classChatSocket.on("viewRecentMessage", (data) {
      // print(data);
      Iterable cc = data;
      print(data);
      tempChatHistory.clear();
      tempChatHistory.value = cc.map((e) => ChatModel.fromJson(e).obs).toList();

      // * 서버에서 역순으로 보내므로 다시 정렬
      tempChatHistory.value = tempChatHistory.reversed.toList();
      if (tempChatHistory.length == 0) {
        return;
      }
      int curBoxID = tempChatHistory[0].value.BOX_ID;

      bool isClass = checkClassOrMajor(curBoxID);
      // * 채팅 박스 모델에 최근 채팅 내역 가져옴
      for (Rx<ChatBoxModel> item in isClass ? classChatBox : majorChatBox) {
        if (item.value.BOX_ID == curBoxID) {
          item.update((val) {
            val.ChatList.addAll(tempChatHistory);
          });
        }
      }
      // * 현재 들어가있을때
      if (currentBoxID.value == curBoxID) {
        box.write("LastChat_${tempChatHistory.last.value.BOX_ID}",
            tempChatHistory.last.value.CHAT_ID);
      }
      // * 안 읽은 개수 체크
      countTotal(curBoxID, isClass);
    });

    classChatSocket.on("newMessage", (data) async {
      Rx<ChatModel> chat = ChatModel.fromJson(data).obs;
      bool isClass = checkClassOrMajor(chat.value.BOX_ID);
      for (Rx<ChatBoxModel> item in isClass ? classChatBox : majorChatBox) {
        if (item.value.BOX_ID == chat.value.BOX_ID) {
          // if (item.value.ChatList.length != 0 &&
          //     item.value.ChatList.last.value.CHAT_ID == chat.value.CHAT_ID) {
          //   print("중복");
          //   break;
          // }
          item.update((val) {
            // * 채팅방 수정
            val.ChatList.add(chat.value.obs);
            print(chat.value.CONTENT);
            // * 단톡방 미리보기 수정
            val.LAST_CHAT = chat.value.CONTENT;
            val.TIME_LAST_CHAT_SENDED = chat.value.TIME_CREATED;
          });
        }
      }

      if (isClass) {
        // * 현재 들어가있을때
        if (currentBoxID.value == chat.value.BOX_ID) {
          await box.write("LastChat_${chat.value.BOX_ID}", chat.value.CHAT_ID);
        }
      } else {
        // * 현재 들어가있을때
        if (currentBoxID.value == chat.value.BOX_ID) {
          await box.write("LastMajor_${chat.value.BOX_ID}", chat.value.CHAT_ID);
        }
      }

      // * 안 읽은 개수 체크
      countTotal(chat.value.BOX_ID, isClass);
    });

    classChatSocket.on('leaveRoom', (_) {
      // print("leaveRoom called : roomID - ${roomID}");
    });

    classChatSocket.on('event', (data) => print(data));
    classChatSocket.on('fromServer', (_) => print(_));

    // return socket;
  }

  bool checkClassOrMajor(int BOX_ID) {
    return BOX_ID > 10000 ? true : false;
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) {
      return;
    }
    classChatSocket
        .emit("sendMessage", {"content": text, "roomId": currentBoxID.value});
  }

  Future<void> registerSocket() async {
    await socketting();
  }

  Future<void> getChatBox() async {
    print("getChatBox called!!!!!!!!!!!!!!!!!!!!!!!!!");
    var response = await Session().getX("/chat/chatBox");
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    Iterable classChatBoxList = jsonResponse["classChatBox"];
    Iterable majorChatBoxList = jsonResponse["majorChatBox"];
    classChatBox.value =
        classChatBoxList.map((e) => ChatBoxModel.fromJson(e).obs).toList().obs;

    majorChatBox.value =
        majorChatBoxList.map((e) => ChatBoxModel.fromJson(e).obs).toList().obs;

    box.remove("classSocket");
    List<ChatBoxModel> tempClassList = [];
    for (Rx<ChatBoxModel> item in classChatBox) {
      joinAndEmit(item.value.BOX_ID);
    }

    tempClassList.clear();
    for (Rx<ChatBoxModel> item in majorChatBox) {
      joinAndEmit(item.value.BOX_ID);
    }
    return;
  }

  Future<void> joinAndEmit(int BOX_ID) async {
    print("joinRoom! ${BOX_ID}");
    classChatSocket.emit("joinRoom", [BOX_ID, "fuckfuck"]);
    await classChatSocket.emit("getChatLog", [BOX_ID, 0]);
    return;
  }

  void setcurrentBoxID(int id) {
    currentBoxID.value = id;
  }

  @override
  void onInit() async {
    super.onInit();

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
      print("${item.value.BOX_ID} - ${currentBoxID.value}");
      if (item.value.BOX_ID == currentBoxID.value) {
        return item.value.ChatList;
      }
    }
  }

  @override
  void onClose() async {
    classChatSocket.disconnect();
    print("contoller close : ${roomID.value}");
    // await classChatSocket.emit("leaveRoom", roomID.value);
    // chatHistory.clear();
  }
}
