import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/controller/board/board_controller.dart';
import 'package:polarstar_flutter/app/controller/board/post_controller.dart';
import 'package:polarstar_flutter/app/data/repository/board/write_post_repository.dart';
import 'package:http/http.dart' as http;
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class WritePostController extends GetxController {
  final WritePostRepository repository;
  final box = GetStorage();
  final String putOrPost;
  int COMMUNITY_ID;
  int BOARD_ID;
  String photo;
  Rx<bool> _dataAvailable = false.obs;
  Rx<XFile> image = null.obs;
  RxBool anonymousCheck = true.obs;
  Rx<String> imagePath = "".obs;
  RxList<AssetEntity> photoAssets = <AssetEntity>[].obs;

  WritePostController(
      {@required this.repository,
      @required this.COMMUNITY_ID,
      this.BOARD_ID,
      this.photo,
      @required this.putOrPost})
      : assert(repository != null);

  @override
  void onInit() async {
    super.onInit();
    if (photo != null) {
      image.value = XFile("http://13.209.5.161:3000$photo");
    }
    ever(anonymousCheck, (_) {
      print("익명 변경");
    });
  }

  //페이지 나갈 때 게시판 리스트 업데이트
  @override
  void onClose() async {
    super.onClose();
    if (putOrPost == "put") {
      final PostController postController = Get.find();
      await postController.getPostData();
    } else if (putOrPost == "post") {
      final BoardController boardController = Get.find();
      await boardController.getBoard();
    } else {
      return;
    }
  }

  void deleteTargetPhoto(String id) {
    photoAssets.removeWhere((element) => element.id == id);
  }

  //게시글 새로 작성 (사진 X)
  Future<void> postPostNoImage(Map<String, dynamic> data) async {
    int status = await repository.postPostNoImage(data, "/board/$COMMUNITY_ID");
    Get.back();

    responseSwitchCase(status);
  }

  //게시글 수정 (사진 X)
  Future<void> putPostNoImage(Map<String, dynamic> data) async {
    int status = await repository.putPostNoImage(
        data, '/board/$COMMUNITY_ID/bid/$BOARD_ID');
    Get.back();
    responseSwitchCase(status);
  }

  //게시글 작성 (사진 O)
  Future<void> postPostImage(Map<String, dynamic> data) async {
    // var pic = await http.MultipartFile.fromPath("photo", imagePath.value);
    List<http.MultipartFile> photoList = <http.MultipartFile>[];

    for (AssetEntity source in photoAssets) {
      Uint8List photo = await source.originBytes;

      photoList.add(http.MultipartFile.fromBytes('photo', photo,
          filename: "${source.title}"));

      print(photo.length);
    }
    int status = await repository.postPostImage(data, photoList, COMMUNITY_ID);
    Get.back();

    responseSwitchCase(status);
  }

  //게시글 수정 (사진 O)
  Future<void> putPostImage(Map<String, dynamic> data) async {
    // var pic = await http.MultipartFile.fromPath("photo", imagePath.value);
    List<http.MultipartFile> photoList = <http.MultipartFile>[];

    for (AssetEntity source in photoAssets) {
      Uint8List photo = await source.originBytes;

      photoList.add(http.MultipartFile.fromBytes('photo', photo,
          filename: "${source.title}"));
    }

    int status =
        await repository.putPostImage(data, photoList, COMMUNITY_ID, BOARD_ID);
    Get.back();

    responseSwitchCase(status);
  }

  bool get dataAvailable => _dataAvailable.value;
}

void responseSwitchCase(int status) {
  switch (status) {
    case 200:
      // Get.snackbar("시스템 오류", "글쓰기 성공");
      break;
    case 401:
      Get.snackbar("系统错误", "无法识别用户",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.black);
      break;
    case 403:
      Get.snackbar("系统错误", "错误访问",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.black);
      break;
    case 404:
      Get.snackbar("系统错误", "该论坛不存在",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.black);
      break;
    default:
      Get.snackbar("系统错误", "帖子发送失败",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.black);
      break;
  }
}
