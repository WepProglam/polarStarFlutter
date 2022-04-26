import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/modules/board/board_controller.dart';
import 'package:polarstar_flutter/app/modules/init_page/pushy_controller.dart';
import 'package:polarstar_flutter/app/modules/post/post_controller.dart';
import 'package:polarstar_flutter/app/data/repository/board/write_post_repository.dart';
import 'package:http/http.dart' as http;
import 'package:polarstar_flutter/session.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:mime/mime.dart';

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
  RxBool sendingPost = false.obs;

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
      image.value = XFile("http://3.39.76.247:3000$photo");
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
      // final BoardController boardController = Get.find();
      // await boardController.getBoard();
    } else {
      return;
    }
  }

  void deleteTargetPhoto(String id) {
    photoAssets.removeWhere((element) => element.id == id);
  }

  //게시글 새로 작성 (사진 X)
  Future<void> postPostNoImage(Map<String, dynamic> data) async {
    sendingPost.value = true;
    Map response =
        await repository.postPostNoImage(data, "/board/$COMMUNITY_ID");
    Get.back();
    String RES_BOARD_ID = "${response["jsonResponse"]["BOARD_ID"]}";
    String RES_COMMUNITY_ID = "${response["jsonResponse"]["COMMUNITY_ID"]}";

    await responseSwitchCase(response["statusCode"],
        BOARD_ID: RES_BOARD_ID, COMMUNITY_ID: RES_COMMUNITY_ID);
    sendingPost.value = false;
  }

  //게시글 수정 (사진 X)
  Future<void> putPostNoImage(Map<String, dynamic> data) async {
    sendingPost.value = true;

    int status = await repository.putPostNoImage(
        data, '/board/$COMMUNITY_ID/bid/$BOARD_ID');
    Get.back();
    await responseSwitchCase(status);
    sendingPost.value = false;
  }
  // 论疫情下螺蛳粉的滞销

  //게시글 작성 (사진 O)
  Future<void> postPostImage(Map<String, dynamic> data) async {
    sendingPost.value = true;
    // var pic = await http.MultipartFile.fromPath("photo", imagePath.value);
    List<http.MultipartFile> photoList = <http.MultipartFile>[];

    int size = 0;
    for (AssetEntity source in photoAssets) {
      Uint8List photo = await source.originBytes;

      photo = await FlutterImageCompress.compressWithList(photo, quality: 70);

      size += photo.lengthInBytes;

      http.MultipartFile photo_upload = http.MultipartFile.fromBytes(
          'photo', photo,
          filename: "${source.title}");

      photoList.add(photo_upload);
    }

    print("${size}B");

    Map response =
        await repository.postPostImage(data, photoList, COMMUNITY_ID);
    Get.back();

    String RES_BOARD_ID = "${response["jsonResponse"]["BOARD_ID"]}";
    String RES_COMMUNITY_ID = "${response["jsonResponse"]["COMMUNITY_ID"]}";

    await responseSwitchCase(response["statusCode"],
        BOARD_ID: RES_BOARD_ID, COMMUNITY_ID: RES_COMMUNITY_ID);

    sendingPost.value = false;
  }

  //게시글 수정 (사진 O)
  Future<void> putPostImage(Map<String, dynamic> data) async {
    sendingPost.value = true;
    // var pic = await http.MultipartFile.fromPath("photo", imagePath.value);
    List<http.MultipartFile> photoList = <http.MultipartFile>[];

    int size = 0;
    for (AssetEntity source in photoAssets) {
      Uint8List photo = await source.originBytes;

      photo = await FlutterImageCompress.compressWithList(photo, quality: 70);

      size += photo.elementSizeInBytes;

      photoList.add(http.MultipartFile.fromBytes('photo', photo,
          filename: "${source.title}"));
    }
    print("${size}B");

    int status =
        await repository.putPostImage(data, photoList, COMMUNITY_ID, BOARD_ID);
    Get.back();

    await responseSwitchCase(status);
    sendingPost.value = false;
  }

  bool get dataAvailable => _dataAvailable.value;
}

Future<void> responseSwitchCase(int status,
    {String BOARD_ID = null, String COMMUNITY_ID = null}) async {
  switch (status) {
    case 200:
      print(BOARD_ID);
      print(COMMUNITY_ID);
      if (BOARD_ID != null && COMMUNITY_ID != null) {
        String topic = "board_${COMMUNITY_ID}_bid_${BOARD_ID}";
        print(await PushyController.pushySubscribe(topic));
        print("pushySubscribe");
      }
      break;
    case 401:
      Get.snackbar("系统错误", "无法识别用户",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.black);
      break;
    // * 도배 방지
    case 403:
      Get.snackbar("系统错误", "不要经常写相同内容的文章",
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
    // * 용량이 너무 큼
    case 413:
      Get.snackbar("系统错误", "容量太大了",
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
