import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:polarstar_flutter/app/data/repository/board/write_post_repository.dart';
import 'package:http/http.dart' as http;

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
      image.value = XFile(
          "'http://ec2-3-37-156-121.ap-northeast-2.compute.amazonaws.com:3000$photo");
    }
    ever(anonymousCheck, (_) {
      print("익명 변경");
    });
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
    var pic = await http.MultipartFile.fromPath("photo", imagePath.value);

    int status = await repository.postPostImage(data, pic, COMMUNITY_ID);
    Get.back();

    responseSwitchCase(status);
  }

  //게시글 수정 (사진 O)
  Future<void> putPostImage(Map<String, dynamic> data) async {
    var pic = await http.MultipartFile.fromPath("photo", imagePath.value);

    int status =
        await repository.putPostImage(data, pic, COMMUNITY_ID, BOARD_ID);
    Get.back();

    responseSwitchCase(status);
  }

  bool get dataAvailable => _dataAvailable.value;
}

void responseSwitchCase(int status) {
  switch (status) {
    case 200:
      Get.snackbar("성공", "성공");
      break;
    default:
      Get.snackbar("실패", "실패");
      break;
  }
}
