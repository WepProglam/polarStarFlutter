import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';
import 'package:polarstar_flutter/app/data/model/noti/noti_model.dart';
import 'package:image_size_getter/image_size_getter.dart';

import 'package:polarstar_flutter/app/data/repository/class/class_repository.dart';
import 'package:polarstar_flutter/app/ui/android/functions/keyboard_visibility.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:polarstar_flutter/main.dart';
import 'package:polarstar_flutter/session.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:path/path.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ClassChatController extends GetxController {
  final box = GetStorage();
  RxString roomID = "".obs;
  RxBool dataAvailble = false.obs;
  RxBool frameComplete = false.obs;
  RxList<ChatModel> chatHistory = <ChatModel>[].obs;
  RxInt CHAT_MAX = 100.obs;

  List<Rx<ChatModel>> tempChatHistory = <Rx<ChatModel>>[].obs;

  ScrollController chatScrollController;
  RxList<Rx<ChatBoxModel>> classChatBox = <Rx<ChatBoxModel>>[].obs;
  RxList<Rx<ChatBoxModel>> majorChatBox = <Rx<ChatBoxModel>>[].obs;
  RxInt currentBoxID = 0.obs;
  RxBool canChatFileShow = false.obs;
  RxBool tapTextField = false.obs;
  List<File> files = <File>[].obs;
  RxBool isNewMessage = false.obs;
  List<AssetEntity> photos = <AssetEntity>[].obs;
  RxList<ChatPrifileModel> chatProfileList = <ChatPrifileModel>[].obs;
  RxDouble totalHeightListView = 0.0.obs;
  final FocusNode chatFocusNode = new FocusNode();

  Map<String, Rx<String>> downloadFileList = {};

  bool isFileDownloaded(String url) {
    return box.read(url) == null ? false : true;
    // downloadFileList.indexOf(TID) == -1 ? false : true;
  }

  Future<void> getChatProfileList(int BOX_ID) async {
    var response = await Session().getX("/chat/chatBox/${BOX_ID}/profile");
    Iterable jsonResponse = jsonDecode(response.body);
    chatProfileList.value =
        jsonResponse.map((e) => ChatPrifileModel.fromJson(e)).toList();
    ChatPrifileModel MINE;
    for (ChatPrifileModel item in chatProfileList) {
      if (item.MY_SELF) {
        MINE = item;
        break;
      }
    }
    chatProfileList.removeWhere((element) => element.MY_SELF);
    chatProfileList.insert(0, MINE);
    // chatProfileList.sort((a, b) {
    //   if (a.MY_SELF) {
    //     return 0;
    //   }
    //   return 1;
    // });
  }

  Rx<ChatModel> fileFindCurChat(String tid) {
    ChatBoxModel curBox = findCurBox.value;
    for (Rx<ChatModel> item in curBox.ChatList) {
      if (item.value.FILE_TID == tid) {
        return item;
      }
    }
    return findCurBox.value.ChatList.first;
  }

  String findFileTID(String url) {
    if (isFileDownloaded(url)) {
      return box.read(url);
    }
    return null;
  }

  // RxList<ChatModel> getChatList() {
  //   Map<String, dynamic> chatMeta = findChatHistory();
  //   int chatIndex = chatMeta["index"];
  //   bool isClass = chatMeta["isClass"];
  //   Rx<ChatBoxModel> box_model =
  //       isClass ? classChatBox[chatIndex] : majorChatBox[chatIndex];
  // }

  Rx<ChatBoxModel> get findCurBox {
    for (Rx<ChatBoxModel> item in classChatBox) {
      if (item.value.BOX_ID == currentBoxID.value) {
        return item;
      }
    }
    for (Rx<ChatBoxModel> item in majorChatBox) {
      if (item.value.BOX_ID == currentBoxID.value) {
        return item;
      }
    }
  }

  Future<void> readClassChat(int BOX_ID) async {
    for (Rx<ChatBoxModel> item in classChatBox) {
      if (item.value.BOX_ID == BOX_ID) {
        int LAST_READ_CHAT_ID = item.value.ChatList.last.value.CHAT_ID;
        item.update((val) {
          val.UNREAD_AMOUNT = 0;
        });
        classChatSocket.emit("readChat", [BOX_ID, LAST_READ_CHAT_ID]);
        break;
      }
    }
  }

  Future<void> readMajorChat(int BOX_ID) async {
    for (Rx<ChatBoxModel> item in majorChatBox) {
      if (item.value.BOX_ID == BOX_ID) {
        int LAST_READ_CHAT_ID = item.value.ChatList.last.value.CHAT_ID;
        item.update((val) {
          val.UNREAD_AMOUNT = 0;
        });
        classChatSocket.emit("readChat", [BOX_ID, LAST_READ_CHAT_ID]);
        break;
      }
    }
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) {
      return;
    }
    ChatModel item = ChatModel.fromJson({
      "BOX_ID": currentBoxID.value,
      "MY_SELF": true,
      "TIME_CREATED": "${DateTime.now()}",
      "CONTENT": text,
      "IS_PRE_SEND": true
    });
    findCurBox.update((val) {
      val.LoadingChatList.add(item.obs);
    });
    isNewMessage.value = true;
    classChatSocket
        .emit("sendMessage", {"content": text, "roomId": currentBoxID.value});
  }

  Future<void> sendFile() async {
    List<Map> sendFileObj = [];
    for (int i = 0; i < files.length; i++) {
      ChatModel item = ChatModel.fromJson({
        "BOX_ID": currentBoxID.value,
        "MY_SELF": true,
        "FILE_META": [
          {
            "file_name": basename(files[i].path),
            "file_size": files[i].lengthSync(),
            "expire": "${DateTime.now().add(Duration(days: 7))}"
          }
        ],
        "FILE": ["sibal"],
        "TIME_CREATED": "${DateTime.now()}",
        "IS_PRE_SEND": true
      });
      findCurBox.update((val) {
        val.LoadingChatList.add(item.obs);
      });
      // print("add!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      // print(findCurBox.value.LoadingChatList.first.toJson());
      isNewMessage.value = true;

      //print(item);
      Map tmp = {};
      tmp["content"] = await files[i].readAsBytes();
      tmp["fileName"] = basename(files[i].path);
      tmp["fileSize"] = files[i].lengthSync();
      //   print(tmp["fileSize"]);

      classChatSocket.emitWithBinary("sendFile", {
        "sendFileObj": [tmp],
        "roomId": currentBoxID.value
      });
    }

    files = [];
  }

  Future<void> sendPhoto() async {
    List<Map> sendFileObj = [];

    for (int i = 0; i < photos.length; i++) {
      Uint8List temp = await photos[i].originBytes;
      int before_compress = temp.lengthInBytes;
      temp = await FlutterImageCompress.compressWithList(temp, quality: 70);
      int after_compress = temp.lengthInBytes;

      print(
          "before : ${before_compress}B | after : ${after_compress}B | ${100 - (after_compress * 100 / before_compress)}% 압축");

      var width;
      var height;
      var decodedImage = await decodeImageFromList(temp);
      if (Platform.isAndroid) {
        width = decodedImage.width;
        height = decodedImage.height;
      } else {
        width = photos[i].width;
        height = photos[i].height;
      }

      //  print(height);
      // print(width);
      // print("@@@@@@@@@@@@@@@@@@@@@");
      // ! 사진 구별 필요
      ChatModel item = ChatModel.fromJson({
        "BOX_ID": currentBoxID.value,
        "MY_SELF": true,
        "PHOTO_META": [
          {
            "photo_name": basename(photos[i].title),
            "pixel_height": height,
            "pixel_width": width
          }
        ],
        "PRE_IMAGE": [
          Image.memory(
            temp,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) {
                // print("wasSynchronouslyLoaded : ${wasSynchronouslyLoaded}");
                isNewMessage.value = true;
                return child;
              }
              return Container();
            },
          )
          // Image(
          //   image: AssetImage(photos[i].relativePath + photos[i].title),
          //   loadingBuilder: (context, child, loadingProgress) {
          //     if (loadingProgress == null) {
          //       return Container(
          //         child: child,
          //       );
          //     } else {
          //       return Container(
          //         height: 260,
          //         child: Center(child: CircularProgressIndicator()),
          //       );
          //     }
          //   },
          //   gaplessPlayback: true,
          // ),
        ],
        "PHOTO": ["fuckfuck"],
        "TIME_CREATED": "${DateTime.now()}",
        "IS_PRE_SEND": true
      });
      findCurBox.update((val) {
        val.LoadingChatList.add(item.obs);
      });
      //print("add!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      //print(findCurBox.value.LoadingChatList.first.toJson());

      Map tmp = {};
      tmp["content"] = temp;
      tmp["fileName"] = basename(photos[i].title);
      tmp["pixel_height"] = height;
      tmp["pixel_width"] = width;
      classChatSocket.emitWithBinary("sendPhoto", {
        "sendFileObj": [tmp],
        "roomId": currentBoxID.value
      });
    }

    photos = [];
  }

  Future<void> sendCameraPhoto(XFile photo_file) async {
    var temp = await photo_file.readAsBytes();
    temp = await FlutterImageCompress.compressWithList(temp, quality: 70);

    var width;
    var height;
    var decodedImage = await decodeImageFromList(temp);

    if (Platform.isAndroid) {
      width = decodedImage.width;
      height = decodedImage.height;
    } else {
      width = Image.file(File(photo_file.path)).width;
      height = Image.file(File(photo_file.path)).height;
    }

    ChatModel item = ChatModel.fromJson({
      "BOX_ID": currentBoxID.value,
      "MY_SELF": true,
      "PHOTO_META": [
        {
          "photo_name": basename(photo_file.name),
          "pixel_height": height,
          "pixel_width": width
        }
      ],
      "PRE_IMAGE": [
        Image.memory(
          temp,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              // print("wasSynchronouslyLoaded : ${wasSynchronouslyLoaded}");
              isNewMessage.value = true;
              return child;
            }
            return Container();
          },
        )
      ],
      "PHOTO": ["fuckfuck"],
      "TIME_CREATED": "${DateTime.now()}",
      "IS_PRE_SEND": true
    });
    findCurBox.update((val) {
      val.LoadingChatList.add(item.obs);
    });
    //print("add!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    //print(findCurBox.value.LoadingChatList.first.toJson());

    Map tmp = {};
    tmp["content"] = temp;
    tmp["fileName"] = basename(photo_file.name);
    tmp["pixel_height"] = height;
    tmp["pixel_width"] = width;
    classChatSocket.emitWithBinary("sendPhoto", {
      "sendFileObj": [tmp],
      "roomId": currentBoxID.value
    });
  }

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

  // void countingAmountClassChat(int curClassID) {
  //   //int last_cid = box.read("LastChat_${curClassID}");

  //   // * 최근 메시지가 같이 왔을 때 카운팅
  //   bool isExist = false;
  //   for (Rx<ChatBoxModel> item in classChatBox) {
  //     //print("${item.value.BOX_ID} : ${curClassID}");
  //     if (item.value.BOX_ID == curClassID) {
  //       int index = item.value.ChatList.length - 1;
  //       int last_cid = item.value.LAST_READ_CHAT_ID;
  //       if (last_cid == null) {
  //         break;
  //       }
  //       for (Rx<ChatModel> it in item.value.ChatList) {
  //         if (it.value.CHAT_ID == last_cid) {
  //           item.update((val) {
  //             val.UNREAD_AMOUNT = index;
  //           });
  //           isExist = true;
  //           break;
  //         }
  //         index--;
  //       }
  //     }
  //   }
  //   // * 최근 메시지가 없을 때 카운팅
  //   if (!isExist) {
  //     for (Rx<ChatBoxModel> item in classChatBox) {
  //       if (item.value.BOX_ID == curClassID) {
  //         item.update((val) {
  //           val.UNREAD_AMOUNT = item.value.ChatList.length > 100
  //               ? 100
  //               : item.value.ChatList.length;
  //         });
  //         break;
  //       }
  //     }
  //   }
  // }

  // void countingAmountMajorChat(int curMajorID) {
  //   //int last_cid = box.read("LastChat_${curMajorID}");

  //   // * 최근 메시지가 같이 왔을 때 카운팅
  //   bool isExist = false;
  //   for (Rx<ChatBoxModel> item in majorChatBox) {
  //     // print("${item.value.BOX_ID} : ${curMajorID}");
  //     if (item.value.BOX_ID == curMajorID) {
  //       int index = item.value.ChatList.length - 1;
  //       int last_cid = item.value.LAST_READ_CHAT_ID;
  //       if (last_cid == null) {
  //         break;
  //       }
  //       for (Rx<ChatModel> it in item.value.ChatList) {
  //         if (it.value.CHAT_ID == last_cid) {
  //           item.update((val) {
  //             val.UNREAD_AMOUNT = index;
  //           });
  //           isExist = true;
  //           break;
  //         }
  //         index--;
  //         // print(index);
  //       }
  //     }
  //   }
  //   // * 최근 메시지가 없을 때 카운팅
  //   if (!isExist) {
  //     for (Rx<ChatBoxModel> item in majorChatBox) {
  //       if (item.value.BOX_ID == curMajorID) {
  //         item.update((val) {
  //           val.UNREAD_AMOUNT = item.value.ChatList.length > 100
  //               ? 100
  //               : item.value.ChatList.length;
  //         });
  //         break;
  //       }
  //     }
  //   }
  // }

  // void countTotal(int BOX_ID, bool isClass) {
  //   if (isClass) {
  //     countingAmountClassChat(BOX_ID);
  //   } else {
  //     countingAmountMajorChat(BOX_ID);
  //   }
  //   return;
  // }

  void removeLoadingChatFile(Rx<ChatModel> chat) {
    findCurBox.update((val) {
      RxList<Rx<ChatModel>> tempList = <Rx<ChatModel>>[].obs;
      tempList.value = val.LoadingChatList.value;
      tempList.removeWhere((element) {
        if (element.value.FILE_META != null &&
            element.value.FILE_META.length > 0) {
          if (element.value.FILE_META[0].FILE_NAME ==
              chat.value.FILE_META[0].FILE_NAME) {
            //print("remove!!");

            return true;
          }
        }
        return false;
      });
      //print(tempList);
      val.LoadingChatList.value = tempList.value;

      val.LoadingChatList.refresh();
    });
  }

  void removeLoadingChatPhoto(Rx<ChatModel> chat) {
    findCurBox.update((val) {
      RxList<Rx<ChatModel>> tempList = <Rx<ChatModel>>[].obs;
      tempList.value = val.LoadingChatList.value;
      tempList.removeWhere((element) {
        if (element.value.PHOTO_META != null &&
            element.value.PHOTO_META.length > 0) {
          if (element.value.PHOTO_META.first.PHOTO_NAME ==
              chat.value.PHOTO_META.first.PHOTO_NAME) {
            // chat.update((val) {
            //   val.PRE_IMAGE[0] = element.value.PRE_IMAGE[0];
            // });
            //print("remove!!");

            return true;
          }
        }
        return false;
      });
      // print(tempList);
      val.LoadingChatList.value = tempList.value;

      val.LoadingChatList.refresh();
    });
  }

  void removeLoadingChatMessage(Rx<ChatModel> chat) {
    findCurBox.update((val) {
      RxList<Rx<ChatModel>> tempList = <Rx<ChatModel>>[].obs;
      tempList.value = val.LoadingChatList.value;
      int index = tempList.indexWhere((element) {
        if (element.value.CONTENT != null) {
          if (element.value.CONTENT == chat.value.CONTENT) {
            //  print("remove!!");
            return true;
          }
        }
        return false;
      });
      if (index == -1) {
        return;
      }
      tempList.removeAt(index);

      val.LoadingChatList.value = tempList.value;

      val.LoadingChatList.refresh();
    });
  }

  RxBool chatDownloaed = false.obs;
  RxBool imagePreCached = false.obs;
  RxBool isFirstEnter = true.obs;
  RxInt chatEnterAmouunt = 0.obs;
  RxBool additionalChatLoading = false.obs;

  Rx<bool> isPageEnd = true.obs;
  int searchIndex = 0;
  bool checkPageEnded(List<dynamic> ChatList) {
    return ChatList.length < CHAT_MAX.value ? true : false;
  }

  Future<void> socketting() async {
    classChatSocket.on("viewRecentMessage", (data) async {
      print("viewRecentMessage");
      Iterable cc = data;
      //print(data);
      tempChatHistory.clear();
      tempChatHistory = cc.map((e) => ChatModel.fromJson(e).obs).toList();
      print(tempChatHistory);
      // * 서버에서 역순으로 보내므로 다시 정렬
      tempChatHistory = tempChatHistory.reversed.toList();
      if (tempChatHistory.length == 0) {
        return;
      }
      // int curBoxID = tempChatHistory[0].value.BOX_ID;

      // bool isClass = checkClassOrMajor(curBoxID);
      // * 채팅 박스 모델에 최근 채팅 내역 가져옴
      print("val.ChatList ${findCurBox.value.ChatList.length}");
      if (chatScrollController.hasClients) {
        print(chatScrollController.offset);
      }
      findCurBox.update((val) {
        if (searchIndex > 1) {
          additionalChatLoading.value = true;
          // double current_totalHeightListView =
          //     chatScrollController.position.maxScrollExtent;

          // chatScrollController.jumpTo(
          //     current_totalHeightListView - past_totalHeightListView.value);
        }
        val.ChatList.insertAll(0, tempChatHistory);

        chatDownloaed(true);
        isPageEnd.value = checkPageEnded(tempChatHistory);
      });

      // for (Rx<ChatBoxModel> item in isClass ? classChatBox : majorChatBox) {
      //   if (item.value.BOX_ID == curBoxID) {
      //     print(" val.ChatList ${item.value.ChatList.length}");
      //     item.update((val) {
      //       val.ChatList.addAll(tempChatHistory);
      //     });
      //   }
      // }

      // if (chatScrollController.hasClients) {
      //   await Future.delayed(Duration(milliseconds: 100), () {
      //     chatScrollController.jumpTo(
      //         chatScrollController.position.maxScrollExtent -
      //             past_totalHeightListView.value);
      //     print("jump!");
      //     additionalChatLoading.value = false;
      //   });
      // }

      print("chatDownloaed33 :${chatDownloaed.value}");
      // // * 현재 들어가있을때
      // if (currentBoxID.value == curBoxID) {
      //   box.write("LastChat_${tempChatHistory.last.value.BOX_ID}",
      //       tempChatHistory.last.value.CHAT_ID);
      // }
      // // * 안 읽은 개수 체크
      // countTotal(curBoxID, isClass);
    });

    classChatSocket.on("newMessage", (data) async {
      Rx<ChatModel> chat = ChatModel.fromJson(data).obs;
      bool isClass = checkClassOrMajor(chat.value.BOX_ID);
      // findCurBox.update((val) {
      //   val.UNREAD_AMOUNT += 1;
      // });
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
            if (chat.value.MY_SELF) {
              // * 파일 미리 보낸거 삭제
              if (chat.value.FILE != null && chat.value.FILE.length > 0) {
                removeLoadingChatFile(chat);
              }
              // * 사진 미리 보낸거 삭제
              // ! 실제 사진 넣어서 기다리다가 받으면 끝내야할듯
              else if (chat.value.PHOTO != null &&
                  chat.value.PHOTO.length > 0) {
                removeLoadingChatPhoto(chat);
              }
              // * 메세지 미리 보낸거 삭제
              else {
                removeLoadingChatMessage(chat);
              }
            }
            //print(chat.value.CONTENT);
            // * 단톡방 미리보기 수정
            val.LAST_CHAT = chat.value.CONTENT;
            val.TIME_LAST_CHAT_SENDED = chat.value.TIME_CREATED;
            isNewMessage.value = true;

            // * 내가 보낸 채팅이 아니면 +1
            if (!chat.value.MY_SELF) {
              val.UNREAD_AMOUNT += 1;
            }
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

      // // * 안 읽은 개수 체크
      // countTotal(chat.value.BOX_ID, isClass);
    });

    classChatSocket.on('leaveRoom', (_) {
      // print("leaveRoom called : roomID - ${roomID}");
    });

    classChatSocket.on('error', (err) => print(err));
    classChatSocket.on('event', (data) => print(data));
    classChatSocket.on('fromServer', (_) => print(_));

    // return socket;
  }

  bool checkClassOrMajor(int BOX_ID) {
    return BOX_ID > 10000 ? true : false;
  }

  Future<void> registerSocket() async {
    await socketting();
  }

  Future<void> getChatBox() async {
    var response = await Session().getX("/chat/chatBox");
    var jsonResponse = jsonDecode(response.body);
    //print(jsonResponse);
    Iterable classChatBoxList = jsonResponse["classChatBox"];
    Iterable majorChatBoxList = jsonResponse["majorChatBox"];

    CHAT_MAX.value = jsonResponse["CHAT_MAX"];
    // classChatBox.value =

    classChatBox.value = classChatBoxList.map((e) {
      ChatBoxModel temp = ChatBoxModel.fromJson(e);
      for (Rx<ChatBoxModel> item in classChatBox) {
        if (temp.BOX_ID == item.value.BOX_ID) {
          print("??!@#!!@!@  ${item.value.ChatList.length}");
          temp.ChatList = item.value.ChatList;
        }
      }
      return temp.obs;
    }).toList();

    classChatBox.sort((Rx<ChatBoxModel> a, Rx<ChatBoxModel> b) =>
        a.value.TIME_LAST_CHAT_SENDED.isAfter(b.value.TIME_LAST_CHAT_SENDED)
            ? 0
            : 1);

    // classChatBox.value = tempList;

    majorChatBox.value = majorChatBoxList.map((e) {
      ChatBoxModel temp = ChatBoxModel.fromJson(e);
      for (Rx<ChatBoxModel> item in majorChatBox) {
        if (temp.BOX_ID == item.value.BOX_ID) {
          print("??!@#!!@!@  ${item.value.ChatList.length}");
          temp.ChatList = item.value.ChatList;
        }
      }
      return temp.obs;
    }).toList();

    majorChatBox.sort((Rx<ChatBoxModel> a, Rx<ChatBoxModel> b) =>
        a.value.TIME_LAST_CHAT_SENDED.isAfter(b.value.TIME_LAST_CHAT_SENDED)
            ? 0
            : 1);
    print("unread amount :  ${majorChatBox.first.value.UNREAD_AMOUNT}");

    box.remove("classSocket");

    // * 강의별 톡방
    List<ChatBoxModel> tempClassList = [];
    for (Rx<ChatBoxModel> item in classChatBox) {
      joinRooms(item.value.BOX_ID);
      // countTotal(item.value.BOX_ID, true);
    }

    // * 전공별 톡방
    tempClassList.clear();
    for (Rx<ChatBoxModel> item in majorChatBox) {
      joinRooms(item.value.BOX_ID);
      // countTotal(item.value.BOX_ID, false);
    }

    return;
  }

  List<int> joinedRooms = [];

  Future<void> joinRooms(int BOX_ID) async {
    if (joinedRooms.indexOf(BOX_ID) != -1) {
      print("이미 조인함");
      return;
    }
    classChatSocket.emit("joinRoom", [BOX_ID, "fuckfuck"]);
    joinedRooms.add(BOX_ID);
    return;
  }

  Future<void> getChatLog(int BOX_ID) async {
    // chatDownloaed(false);
    await classChatSocket.emit("getChatLog", [BOX_ID, searchIndex]);
    searchIndex += 1;
    return;
  }

  void setcurrentBoxID(int id) {
    currentBoxID.value = id;
  }

  RxDouble past_totalHeightListView = 0.0.obs;
  double current_totalHeightListView = 0.0;
  RxBool toBottomButton = false.obs;

  @override
  void onInit() async {
    super.onInit();

    chatScrollController =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: false);
    // chatScrollController.addListener(() {
    //   chatScrollController
    //       .jumpTo(chatScrollController.position.maxScrollExtent);
    // });

    chatScrollController.addListener(() async {
      print("isPageEnd : ${isPageEnd} offset : ${chatScrollController.offset}");
      current_totalHeightListView = chatScrollController.offset;
      if (current_totalHeightListView - 0.0 >= 300) {
        toBottomButton.value = true;
      } else {
        toBottomButton.value = false;
      }
      // print(
      //     "totalHeightListView : ${chatScrollController.position.maxScrollExtent} min : ${chatScrollController.position.minScrollExtent}");
      if (!isPageEnd.value &&
          chatScrollController.offset ==
              chatScrollController.position.maxScrollExtent) {
        past_totalHeightListView.value =
            chatScrollController.position.maxScrollExtent;

        await getChatLog(currentBoxID.value);

        // double current_totalHeightListView =
        //     chatScrollController.position.maxScrollExtent;

        // await Future.delayed(Duration(milliseconds: 5000), () {
        //   current_totalHeightListView =
        //       chatScrollController.position.maxScrollExtent;
        //   print("past_totalHeightListView : ${past_totalHeightListView}");
        //   print(
        //       "current_totalHeightListView222 : ${current_totalHeightListView}");
        // });

        // await chatScrollController.animateTo(
        //     chatScrollController.position.maxScrollExtent,
        //     duration: Duration(milliseconds: 100),
        //     curve: Curves.ease);
        print("offset : ${chatScrollController.offset}");
        print("emitt!!");
      }

      // print(chatScrollController.offset);
    });

    ever(dataAvailble, (_) {
      // print("dataavailable : ${dataAvailble.value}");
    });

    ever(classChatBox, (_) {
      //print("char box ${classChatBox}");
    });

    chatFocusNode.addListener(() {
      // print("???????!!!!!!!!!!!!!!!!");
      //print(chatFocusNode.hasFocus);
    });
  }

  RxList<Rx<ChatModel>> get getClassHistory {
    //  print("!!!!");
    //  print(classChatBox);
    for (Rx<ChatBoxModel> item in classChatBox) {
      //  print("${item.value.BOX_ID} - ${currentBoxID.value}");
      if (item.value.BOX_ID == currentBoxID.value) {
        return item.value.ChatList;
      }
    }
  }

  int get chatLength {
    if (findCurBox.value.LoadingChatList == null) {
      return findCurBox.value.ChatList.length;
    }
    return findCurBox.value.ChatList.length +
        findCurBox.value.LoadingChatList.length;
  }

  @override
  void onClose() async {
    // * 강의별 톡방
    for (Rx<ChatBoxModel> item in classChatBox) {
      await classChatSocket.emit("leaveRoom", [item.value.BOX_ID]);
      print("leaveroom ${item.value.BOX_ID} ");
    }

    // * 전공별 톡방
    for (Rx<ChatBoxModel> item in majorChatBox) {
      await classChatSocket.emit("leaveRoom", [item.value.BOX_ID]);
      print("leaveroom ${item.value.BOX_ID} ");
    }

    classChatSocket.disconnect();
    // print("contoller close : ${roomID.value}");
    // await classChatSocket.emit("leaveRoom", roomID.value);
    // chatHistory.clear();
  }
}
