import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/controller/board/board_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/provider/board/board_provider.dart';
import 'package:polarstar_flutter/app/data/repository/board/board_repository.dart';
import 'package:polarstar_flutter/app/data/repository/board/post_repository.dart';
import 'package:polarstar_flutter/session.dart';

class PostController extends GetxController {
  final PostRepository repository;
  final box = GetStorage();

  PostController(
      {@required this.repository,
      @required this.COMMUNITY_ID,
      @required this.BOARD_ID})
      : assert(repository != null);

  Rx<bool> _dataAvailable = false.obs;

  Rx<int> bottomTextLine = 1.obs;

  int COMMUNITY_ID;
  int BOARD_ID;

  // Post
  var anonymousCheck = true.obs;
  Rx<bool> mailAnonymous = true.obs;
  RxList postContent = [].obs;
  RxList<Post> sortedList = <Post>[].obs;
  RxMap postBody = {}.obs;

  var isCcomment = false.obs;
  var ccommentUrl = ''.obs;
  var commentUrl = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    isCcomment(false);
    makeCommentUrl(COMMUNITY_ID, BOARD_ID);
    await getPostData();
  }

  Future<void> refreshPost() async {
    // _dataAvailable.value = false;
    await getPostData();
  }

  Future<void> getPostData() async {
    // _dataAvailable.value = false;
    final Map<String, dynamic> response =
        await repository.getPostData(this.COMMUNITY_ID, this.BOARD_ID);
    final status = response["statusCode"];

    switch (status) {
      case 401:
        Session().getX('/logout');
        Get.offAllNamed('/login');
        return null;
        break;
      case 400:
      case 200:
        sortPCCC(response["listPost"]);
        _dataAvailable.value = true;
        print(sortedList[0].PHOTO);
        return;
      default:
    }
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
    final status =
        await repository.deleteResource(COMMUNITY_ID, UNIQUE_ID, tag);
    switch (status) {
      case 200:
        Get.snackbar("삭제 성공", "삭제 성공", snackPosition: SnackPosition.BOTTOM);

        if (tag == "bid") {
          // Get.offNamed("/board/$COMMUNITY_ID/page/1");
          Get.offNamedUntil('/main', (route) => false);
          Get.toNamed("/board/$COMMUNITY_ID/page/1");
        } else {
          // await getPostData();
          await refreshPost();
        }

        break;
      default:
        Get.snackbar("삭제 실패", "삭제 실패", snackPosition: SnackPosition.BOTTOM);
    }
  }

  void postComment(String url, var data) async {
    final status = await repository.postComment(url, data);
    switch (status) {
      case 200:
        await getPostData();
        break;

      default:
        break;
    }
  }

  void putComment(String url, var data) async {
    final status = await repository.putComment(url, data);
    switch (status) {
      case 200:
        await getPostData();
        break;

      default:
        break;
    }
  }

  void sortPCCC(List<Post> itemList) {
    sortedList.clear();

    sortedList.add(itemList[0]);

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
      sortedList.add(itemList[i]);

      for (int k = 1; k < itemList.length; k++) {
        //itemlist를 돌면서 댓글을 부모로 가지는 대댓글 찾아서
        if (itemList[k].PARENT_ID == unsortedItem.UNIQUE_ID) {
          //sortedList에 집어넣음(순서대로)
          sortedList.add(itemList[k]);
        }
      }
    }
  }

  void totalSend(String urlTemp, String what, int index) {
    String url = "/board" + urlTemp;
    Session().getX(url).then((value) {
      switch (value.statusCode) {
        case 200:
          Get.snackbar("$what 성공", "$what 성공",
              snackPosition: SnackPosition.BOTTOM);
          // if (what == "좋아요") {
          //   sortedList[index].LIKES++;
          // } else if (what == "스크랩") {
          //   sortedList[index].SCRAPS++;
          // }
          // _dataAvailable(false);
          _dataAvailable.refresh();
          getPostData();
          break;
        case 403:
          Get.snackbar('이미 $what 한 게시글입니다', '이미 $what 한 게시글입니다',
              snackPosition: SnackPosition.BOTTOM);
          break;
        default:
      }
    });
  }

  Future<int> getArrestType() async {
    var response = await Get.defaultDialog(
        title: "신고 사유 선택",
        content: Column(
          children: [
            InkWell(
              child: Text("게시판 성격에 안맞는 글"),
              onTap: () {
                Get.back(result: 0);
              },
            ),
            InkWell(
              child: Text("광고"),
              onTap: () {
                Get.back(result: 1);
              },
            ),
            InkWell(
              child: Text("허위 사실"),
              onTap: () {
                Get.back(result: 2);
              },
            ),
            InkWell(
              child: Text("욕설/비난"),
              onTap: () {
                Get.back(result: 3);
              },
            ),
            InkWell(
              child: Text("저작권"),
              onTap: () {
                Get.back(result: 4);
              },
            ),
            InkWell(
              child: Text("풍기문란"),
              onTap: () {
                Get.back(result: 5);
              },
            ),
          ],
        ));
    return response;
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

  updateAutoFocusTextForm(bool b) {
    autoFocusTextForm.value = b;
  }

  void getPostFromCommentData(Map comment) async {
    var response = await Session().getX(
        "/board/${comment['comment']['type']}/read/${comment['comment']['bid']}");
  }

  bool get dataAvailable => _dataAvailable.value;
}
