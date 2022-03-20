import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/modules/init_page/pushy_controller.dart';
import 'package:polarstar_flutter/app/modules/main_page/main_controller.dart';
import 'package:polarstar_flutter/app/modules/photo_layout/photo_controller.dart';

import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/repository/board/post_repository.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:polarstar_flutter/app/global_widgets/dialoge.dart';
import 'package:polarstar_flutter/session.dart';

class PostController extends GetxController {
  final PostRepository repository;
  final box = GetStorage();
  final MainController mainController = Get.find();
  final PhotoController photoController = Get.find();

  PostController(
      {@required this.repository,
      @required this.COMMUNITY_ID,
      @required this.BOARD_ID})
      : assert(repository != null);

  Rx<bool> _dataAvailable = false.obs;
  RxBool isDeleted = false.obs;

  Rx<int> bottomTextLine = 1.obs;

  int COMMUNITY_ID;
  int BOARD_ID;
  int callType = 2;
  final FocusNode focusNode = FocusNode();

  // Post
  var anonymousCheck = true.obs;
  Rx<bool> mailAnonymous = true.obs;
  RxList postContent = [].obs;
  RxList<Rx<Post>> sortedList = <Rx<Post>>[].obs;
  RxMap postBody = {}.obs;

  var isCcomment = false.obs;
  var ccommentUrl = ''.obs;
  var commentUrl = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    photoController.photo_index.value = 0;
    isCcomment(false);
    makeCommentUrl(COMMUNITY_ID, BOARD_ID);
    await getPostData();
    await checkSubscribe("board_${COMMUNITY_ID}_bid_${BOARD_ID}");
  }

  RxBool isSubscribed = false.obs;

  Future<void> checkSubscribe(String topic) async {
    if (await PushyController.checkSubscribe(topic)) {
      isSubscribed.value = true;
    } else {
      isSubscribed.value = false;
    }
  }

  RxBool isPushySubUnsubcribing = false.obs;

  Future<void> pushySubscribe(String topic) async {
    isPushySubUnsubcribing.value = true;
    print("subs ${topic}");
    if (await PushyController.pushySubscribe(topic) == 200) {
      print("??");
      isSubscribed.value = true;
    } else {}
    isPushySubUnsubcribing.value = false;
  }

  Future<void> pushyUnsubscribe(String topic) async {
    isPushySubUnsubcribing.value = true;
    print("unsubs ${topic}");
    if (await PushyController.pushyUnsubscribe(topic) == 200) {
      print("!!");

      isSubscribed.value = false;
    } else {}
    isPushySubUnsubcribing.value = false;
  }

  // Future<void> updateMute() async {
  //   List<dynamic> idList = await box.read("muteListCommunity");
  //   print(idList);
  //   if (idList == null) {
  //     idList = [BOARD_ID.toString()];
  //     box.write("muteListCommunity", idList);

  //     muteChecked.value = true;
  //     print("1");
  //   } else if (idList.contains(BOARD_ID.toString())) {
  //     idList.removeWhere((element) => element == BOARD_ID.toString());
  //     box.write("muteListCommunity", idList);
  //     muteChecked.value = false;
  //     print("2");
  //   } else {
  //     idList.add(BOARD_ID.toString());
  //     box.write("muteListCommunity", idList);
  //     muteChecked.value = true;
  //     print("3");
  //   }
  //   idList = await box.read("muteListCommunity");
  //   print(idList);
  // }

  Future<int> refreshPost() async {
    // _dataAvailable.value = false;
    await mainController.refreshLikeList();
    await mainController.refreshScrapList();
    int status_code = await getPostData();
    return status_code;
  }

  Future<int> getPostData() async {
    // _dataAvailable.value = false;
    final Map<String, dynamic> response =
        await repository.getPostData(this.COMMUNITY_ID, this.BOARD_ID);
    final status = response["statusCode"];
    print(status);

    switch (status) {
      case 401:
        Session().getX('/logout');
        Get.offAllNamed('/login');
        return null;
        break;
      case 200:
        sortPCCC(response["listPost"]);

        _dataAvailable.value = true;
        break;
      default:
        await Textdialogue(Get.context, "无效操作", "帖子已被删除");
        Get.back();
        isDeleted.value = true;
    }
    return status;
  }

  // void deletePost(int COMMUNITY_ID, int BOARD_ID) async {
  //   final status = await repository.deletePost(COMMUNITY_ID, BOARD_ID);
  //   switch (status) {
  //     case 200:
  //       Get.back();
  //       Get.snackbar("게시글 삭제 성공", "게시글 삭제 성공",
  //           snackPosition: SnackPosition.BOTTOM);

  //       await Get.offAllNamed("/board/$COMMUNITY_ID/page/1");

  //       break;
  //     default:
  //       Get.snackbar("게시글 삭제 실패", "게시글 삭제 실패",
  //           snackPosition: SnackPosition.BOTTOM);
  //   }
  // }

  void deleteResource(int COMMUNITY_ID, int UNIQUE_ID, String tag) async {
    Function onTapConfirm = () async {
      final status =
          await repository.deleteResource(COMMUNITY_ID, UNIQUE_ID, tag);
      Get.back();
      switch (status) {
        case 200:
          // Get.snackbar("삭제 성공", "삭제 성공", snackPosition: SnackPosition.BOTTOM);
          // Todo: main api 호출 후 refresh 해야 함
          // * offNamedUntil로 하면 현재 사용하고 있던 컨트롤러랑 새로 만들어진 컨트롤러랑 달라서 충돌 나는듯?
          if (tag == "bid") {
            int i = 0;
            while (Get.currentRoute != "/board/$COMMUNITY_ID/page/1" &&
                Get.currentRoute != Routes.MAIN_PAGE) {
              i++;
              if (i > 100) {
                break;
              }
              Get.back();
            }
          } else {
            await MainUpdateModule.updatePost(type: callType);
          }
          print("return");
          return;

          break;
        default:
          Get.snackbar("系统错误", "系统错误",
              colorText: Colors.white,
              backgroundColor: Colors.black,
              snackPosition: SnackPosition.BOTTOM);
          break;
      }
      return;
    };
    Function onTapCancel = () {
      Get.back();
    };
    TFdialogue("删除帖子", "确定要删除帖子吗？", onTapConfirm, onTapCancel);
    // Get.defaultDialog(title: "删除帖子", middleText: "确定要删除帖子吗？", actions: [
    //   TextButton(
    //       onPressed: () async {
    //         final status =
    //             await repository.deleteResource(COMMUNITY_ID, UNIQUE_ID, tag);
    //         Get.back();
    //         switch (status) {
    //           case 200:
    //             // Get.snackbar("삭제 성공", "삭제 성공",
    //             //     snackPosition: SnackPosition.BOTTOM);
    //             // Todo: main api 호출 후 refresh 해야 함
    //             // * offNamedUntil로 하면 현재 사용하고 있던 컨트롤러랑 새로 만들어진 컨트롤러랑 달라서 충돌 나는듯?
    //             if (tag == "bid") {
    //               while (Get.currentRoute != "/board/$COMMUNITY_ID/page/1") {
    //                 Get.back();
    //               }
    //             } else {
    //               // await getPostData();
    //               await MainUpdateModule.updatePost(type: callType);
    //             }

    //             break;
    //           default:
    //             Get.snackbar("系统错误", "系统错误",
    //                 colorText: Colors.white,
    //                 backgroundColor: Colors.black,
    //                 snackPosition: SnackPosition.BOTTOM);
    //         }
    //       },
    //       child: Text("是")),
    //   TextButton(
    //       onPressed: () {
    //         Get.back();
    //       },
    //       child: Text("否"))
    // ]);
  }

  void postComment(String url, var data) async {
    final status = await repository.postComment(url, data);
    switch (status) {
      case 200:
        await MainUpdateModule.updatePost(type: callType);
        break;

      default:
        break;
    }
  }

  void putComment(String url, var data) async {
    final status = await repository.putComment(url, data);
    switch (status) {
      case 200:
        await MainUpdateModule.updatePost(type: callType);
        break;

      default:
        break;
    }
  }

  void sortPCCC(List<Post> itemList) {
    sortedList.clear();

    sortedList.add(itemList[0].obs);

    int itemLength = itemList.length;

    //댓글 대댓글 정렬
    for (int i = 1; i < itemLength; i++) {
      Post unsortedItem = itemList[i];

      //게시글 - 댓글 - 대댓글 순서대로 정렬되있으므로 대댓글 만나는 순간 끝
      if (unsortedItem.DEPTH == 2) {
        print("break!");
        break;
      }

      //댓글 집어 넣기
      sortedList.add(itemList[i].obs);

      for (int k = 1; k < itemList.length; k++) {
        //itemlist를 돌면서 댓글을 부모로 가지는 대댓글 찾아서
        if (itemList[k].PARENT_ID == unsortedItem.UNIQUE_ID) {
          //sortedList에 집어넣음(순서대로)
          sortedList.add(itemList[k].obs);
        }
      }
    }
    sortedList.first.update((val) {
      val.COMMENTS = sortedList.length - 1;
    });
  }

  // * public
  Future<int> totalSend(String urlTemp, String what, int index) async {
    int statusCode = await _totalSend(urlTemp, what, index);
    await MainUpdateModule.updatePost(type: callType);
    //! 걍 다 업데이트함
    await MainUpdateModule.updateMyPage(0);
    await MainUpdateModule.updateMyPage(1);
    await MainUpdateModule.updateMyPage(2);
    return statusCode;
  }

  // * public
  Future<int> scrap_cancel(String urlTemp) async {
    int statusCode = await _scrap_cancel(urlTemp);
    await MainUpdateModule.updatePost(type: callType);
    //! 걍 다 업데이트함
    await MainUpdateModule.updateMyPage(0);
    await MainUpdateModule.updateMyPage(1);
    await MainUpdateModule.updateMyPage(2);
    return statusCode;
  }

  // * private
  Future<int> _totalSend(String urlTemp, String what, int index) async {
    String url = "/board" + urlTemp;
    int status_code = 400;
    await Session().getX(url).then((value) {
      status_code = value.statusCode;
      switch (value.statusCode) {
        case 200:
          break;
        case 403:
          if (what == "좋아요") {
            Get.snackbar('无效操作', '1. 您已经给帖子点过赞了\n2. 不能给本人的帖子或评论点赞哦',
                colorText: Colors.white,
                backgroundColor: Colors.black,
                snackPosition: SnackPosition.BOTTOM);
          } else {
            Get.snackbar(
                '无效操作', '1. 이미 $what 한 게시글입니다\n2. 본인의 글 / 댓글에 $what 할 수 없습니다',
                colorText: Colors.white,
                backgroundColor: Colors.black,
                snackPosition: SnackPosition.BOTTOM);
          }

          break;
        default:
          Get.snackbar('${value.statusCode}', '$what 실패',
              colorText: Colors.white,
              backgroundColor: Colors.black,
              snackPosition: SnackPosition.BOTTOM);
          break;
      }
    });
    return status_code;
  }

  // * private
  Future<int> _scrap_cancel(String urlTemp) async {
    String url = "/board" + urlTemp;
    int status_code = 400;
    Session().deleteX(url).then((value) {
      status_code = value.statusCode;
      switch (value.statusCode) {
        case 200:
          break;
        case 403:
          // *  부적절한 접근, 이미 스크랩 취소한 게시글입니다.
          Get.snackbar('无效操作', '无效操作',
              colorText: Colors.white,
              backgroundColor: Colors.black,
              snackPosition: SnackPosition.BOTTOM);
          break;

        default:
          break;
      }
    });
    return status_code;
  }

  changeAnonymous(bool value) {
    anonymousCheck.value = value;
  }

  changeCcomment(String cidUrl) {
    if (isCcomment.value && ccommentUrl.value == cidUrl) {
      isCcomment(false);
    } else {
      isCcomment(true);
    }
  }

  makeCcommentUrl(int COMMUNITY_ID, int cid) {
    ccommentUrl.value = '/board/$COMMUNITY_ID/cid/$cid';
  }

  makeCommentUrl(int COMMUNITY_ID, int bid) {
    commentUrl.value = '/board/$COMMUNITY_ID/bid/$bid';
  }

  // 댓글 수정
  var autoFocusTextForm = false.obs;
  var putUrl = ''.obs;
  RxBool isSendingComment = false.obs;

  updateAutoFocusTextForm(bool b) {
    autoFocusTextForm.value = b;
  }

  void getPostFromCommentData(Map comment) async {
    var response = await Session().getX(
        "/board/${comment['comment']['type']}/read/${comment['comment']['bid']}");
  }

  bool get dataAvailable => _dataAvailable.value;
}
