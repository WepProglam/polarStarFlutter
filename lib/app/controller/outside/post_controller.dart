import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/repository/outside/post_repository.dart';
import 'package:polarstar_flutter/session.dart';

class OutSidePostController extends GetxController {
  final OutSidePostRepository repository;
  final box = GetStorage();

  OutSidePostController(
      {@required this.repository,
      @required this.COMMUNITY_ID,
      @required this.BOARD_ID})
      : assert(repository != null);

  Rx<bool> _dataAvailable = false.obs;

  int COMMUNITY_ID;
  int BOARD_ID;

  // Post
  var anonymousCheck = true.obs;
  Rx<bool> mailAnonymous = true.obs;
  Rx<Post> postContent = Post().obs;

  @override
  void onInit() async {
    super.onInit();
    await getPostData();
  }

  Future<void> refreshPost() async {
    await getPostData();
  }

  Future<void> getPostData() async {
    _dataAvailable.value = false;
    final Map<String, dynamic> response =
        await repository.getPostData(this.COMMUNITY_ID, this.BOARD_ID);
    print(response);
    final status = response["statusCode"];

    switch (status) {
      case 401:
        Session().getX('/logout');
        Get.offAllNamed('/login');
        return null;
        break;
      case 400:
      case 200:
        postContent.value = response["listPost"][0];
        _dataAvailable.value = true;
        return;
      default:
    }
  }

  void totalSend(String urlTemp, String what) {
    String url = "/outside" + urlTemp;
    if (what != "좋아요" && what != "스크랩") {
      Get.snackbar("좋아요와 스크랩 외엔 할 수 없습니다.", "좋아요와 스크랩 외엔 할 수 없습니다.");
      return;
    }
    Session().getX(url).then((value) {
      switch (value.statusCode) {
        case 200:
          Get.snackbar("$what 성공", "$what 성공",
              snackPosition: SnackPosition.BOTTOM);
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

  bool get dataAvailable => _dataAvailable.value;
}
