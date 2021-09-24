import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/board_model.dart';
import 'package:polarstar_flutter/app/data/model/profile/mypage_model.dart';
import 'package:polarstar_flutter/app/data/repository/profile/mypage_repository.dart';
import 'package:polarstar_flutter/app/ui/android/profile/mypage.dart';
import 'package:polarstar_flutter/session.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:http/http.dart' as http;

class MyPageController extends GetxController {
  final MyPageRepository repository;

  MyPageController({@required this.repository}) : assert(repository != null);

  Rx<MyProfileModel> myProfile = new MyProfileModel().obs;
  RxList<Board> myBoardWrite = <Board>[].obs;
  RxList<Board> myBoardLike = <Board>[].obs;
  RxList<Board> myBoardScrap = <Board>[].obs;
  Rx<int> profilePostIndex = 0.obs;
  Rx<String> imagePath = ''.obs;
  RxList<AssetEntity> photoAssets = <AssetEntity>[].obs;

  final PageController pageController =
      PageController(initialPage: 0, viewportFraction: 1.0, keepPage: true);

  var _dataAvailableMypage = false.obs;
  var _dataAvailableMypageWrite = false.obs;
  var _dataAvailableMypageLike = false.obs;
  var _dataAvailableMypageScrap = false.obs;

  //내가 쓴 글 목록 불러옴
  Future<void> getMineWrite() async {
    final response = await repository.getMineWrite();
    final status = response["status"];

    switch (status) {
      case 200:
        myBoardWrite.value = response["myPageBoard"];
        break;
      default:
        myBoardWrite.value = [];
        // Get.snackbar("에러 발생", "에러 발생");
        break;
    }

    myProfile.value = response["myProfile"];

    _dataAvailableMypage.value = true;
    _dataAvailableMypageWrite.value = true;
  }

  //유저 좋아요 글
  Future<void> getMineLike() async {
    final response = await repository.getMineLike();
    final status = response["status"];

    switch (status) {
      case 200:
        myBoardLike.value = response["myPageBoard"];

        break;
      default:
        myBoardLike.value = [];

        // Get.snackbar("에러 발생", "에러 발생");
        break;
    }

    _dataAvailableMypageLike.value = true;
  }

  //유저 스크랩 글
  Future<void> getMineScrap() async {
    final response = await repository.getMineScrap();
    final status = response["status"];

    switch (status) {
      case 200:
        myBoardScrap.value = response["myPageBoard"];

        break;
      default:
        myBoardScrap.value = [];

        // Get.snackbar("에러 발생", "에러 발생");
        break;
    }

    _dataAvailableMypageScrap.value = true;
  }

  @override
  void onClose() async {}

  @override
  void onInit() async {
    super.onInit();
    await getMineWrite();

    // await getMineLike();
    // await getMineScrap();
    profilePostIndex.value = 0;

    //사용자가 인덱스 변경 시 매번 다운 받았는지 체크 후, 안받았으면 http 요청 보냄
    ever(profilePostIndex, (_) async {
      switch (profilePostIndex.value) {
        case 0:
          if (!dataAvailableMypage) {
            getMineWrite();
          }
          break;

        case 1:
          if (!dataAvailableMypageLike) {
            getMineScrap();
          }
          break;

        case 2:
          if (!dataAvailableMypageScrap) {
            getMineLike();
          }
          break;
        default:
          if (!dataAvailableMypage) {
            getMineWrite();
          }
          break;
      }
    });
  }

  getMultipleGallertImage(BuildContext context) async {
    photoAssets.value = await AssetPicker.pickAssets(context, maxAssets: 1);
  }

  Future<void> updateProfile(String profileMsg, String profileNickname) async {
    Map<String, dynamic> data = MyProfileModel(
            PROFILE_NICKNAME: profileNickname, PROFILE_MESSAGE: profileMsg)
        .toJson();

    await Session().patchX("/info/modify", data).then((value) {
      switch (value.statusCode) {
        case 200:
          myProfile.update((val) {
            val.PROFILE_MESSAGE = profileMsg;
            val.PROFILE_NICKNAME = profileNickname;
          });

          Get.back();
          Get.snackbar("변경 성공", "변경 성공");

          break;

        default:
          Get.snackbar("변경 실패", "변경 실패");
      }
    });
  }

  Future<void> upload() async {
    Uint8List photoByte = await photoAssets[0].originBytes;

    http.MultipartFile photo = http.MultipartFile.fromBytes('photo', photoByte,
        filename: "${photoAssets[0].title}");

    Map<String, dynamic> value = await repository.uploadProfileImage(photo);

    switch (value["status"]) {
      case 200:
        Get.snackbar("사진 변경 성공", "사진 변경 성공",
            snackPosition: SnackPosition.BOTTOM);

        myProfile.update((val) {
          val.PROFILE_PHOTO = value["src"];
        });
        break;
      case 500:
        Get.snackbar("사진 변경 실패", "사진 변경 실패",
            snackPosition: SnackPosition.BOTTOM);
        break;
      default:
    }
  }

  void setDataAvailableMypageFalse() {
    _dataAvailableMypage.value = false;
  }

  bool get dataAvailableMypage => _dataAvailableMypage.value;
  bool get dataAvailableMypageWrite => _dataAvailableMypageWrite.value;
  bool get dataAvailableMypageLike => _dataAvailableMypageLike.value;
  bool get dataAvailableMypageScrap => _dataAvailableMypageScrap.value;
}
