import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/board_model.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/model/profile/mypage_model.dart';
import 'package:polarstar_flutter/app/data/repository/profile/mypage_repository.dart';
import 'package:polarstar_flutter/app/ui/android/profile/mypage.dart';
import 'package:polarstar_flutter/session.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class MyPageController extends GetxController
    with SingleGetTickerProviderMixin {
  final MyPageRepository repository;

  MyPageController({@required this.repository}) : assert(repository != null);

  Rx<MyProfileModel> myProfile = new MyProfileModel().obs;
  RxList<Rx<Post>> myBoardWrite = <Rx<Post>>[].obs;
  RxList<Rx<Post>> myBoardLike = <Rx<Post>>[].obs;
  RxList<Rx<Post>> myBoardScrap = <Rx<Post>>[].obs;

  Rx<int> profilePostIndex = 0.obs;
  Rx<String> imagePath = ''.obs;
  RxList<AssetEntity> photoAssets = <AssetEntity>[].obs;

  TabController tabController;

  final PageController pageController =
      PageController(initialPage: 0, viewportFraction: 1.0, keepPage: true);

  var _dataAvailableMypage = false.obs;
  var _dataAvailableMypageWrite = false.obs;
  var _dataAvailableMypageLike = false.obs;
  var _dataAvailableMypageScrap = false.obs;

  RxInt writePage = 0.obs;
  RxInt likePage = 0.obs;
  RxInt scrapPage = 0.obs;

  RxInt writeMaxPage = 99999.obs;
  RxInt likeMaxPage = 99999.obs;
  RxInt scrapMaxPage = 99999.obs;

  final Rx<ScrollController> scrollController =
      ScrollController(initialScrollOffset: 0.0).obs;

  //내가 쓴 글 목록 불러옴
  Future<void> getMineProfile() async {
    final response = await repository.getMineProfile();

    myProfile.value = response["myProfile"];

    _dataAvailableMypage.value = true;
  }

  //내가 쓴 글 목록 불러옴
  Future<void> getMineWrite() async {
    final response = await repository.getMineWrite(writePage.value);
    final status = response["status"];

    if (writePage.value > 0) {
      if (response["myPageBoard"].length == 0) {
        writeMaxPage.value = writePage.value;
      } else {
        myBoardWrite.addAll(response["myPageBoard"]);
      }
    } else {
      switch (status) {
        case 200:
          myBoardWrite.value = response["myPageBoard"];
          break;
        default:
          myBoardWrite.value = [];
          break;
      }
    }

    _dataAvailableMypageWrite.value = true;
  }

  //유저 좋아요 글
  Future<void> getMineLike() async {
    final response = await repository.getMineLike(likePage.value);
    final status = response["status"];

    if (likePage.value > 0) {
      if (response["myPageBoard"].length == 0) {
        likeMaxPage.value = likePage.value;
      } else {
        myBoardLike.addAll(response["myPageBoard"]);
      }
    } else {
      switch (status) {
        case 200:
          myBoardLike.value = response["myPageBoard"];

          break;
        default:
          myBoardLike.value = [];

          break;
      }
    }

    _dataAvailableMypageLike.value = true;
  }

  //유저 스크랩 글
  Future<void> getMineScrap() async {
    final response = await repository.getMineScrap(scrapPage.value);
    final status = response["status"];

    if (scrapPage.value > 0) {
      if (response["myPageBoard"].length == 0) {
        scrapMaxPage.value = scrapPage.value;
      } else {
        myBoardScrap.addAll(response["myPageBoard"]);
      }
    } else {
      switch (status) {
        case 200:
          myBoardScrap.value = response["myPageBoard"];

          break;
        default:
          myBoardScrap.value = [];

          break;
      }
    }

    _dataAvailableMypageScrap.value = true;
  }

  @override
  void onClose() async {}

  @override
  void onInit() async {
    tabController = TabController(vsync: this, length: 3);

    super.onInit();
    await getMineProfile();
    await getMineWrite();
    await getMineLike();
    await getMineScrap();

    tabController.addListener(() {
      print("${tabController.index}");
    });

    scrollController.value.addListener(() async {
      if ((scrollController.value.position.pixels ==
              scrollController.value.position.maxScrollExtent ||
          !scrollController.value.position.hasPixels)) {
        print("curpage : ${curPage} maxPage: ${MaxPage}");
        if (curPage == MaxPage) {
          return;
        }
        switch (tabController.index) {
          case 0:
            writePage.value += 1;
            getMineWrite();
            break;
          case 1:
            scrapPage.value += 1;
            getMineScrap();

            break;
          case 2:
            likePage.value += 1;
            getMineLike();
            break;
          default:
            break;
        }
      }
    });

    // await getMineLike();
    // await getMineScrap();
    profilePostIndex.value = 0;

    // //사용자가 인덱스 변경 시 매번 다운 받았는지 체크 후, 안받았으면 http 요청 보냄
    // ever(profilePostIndex, (_) async {
    //   switch (profilePostIndex.value) {
    //     case 0:
    //       if (!dataAvailableMypage) {
    //         getMineWrite();
    //       }
    //       break;

    //     case 1:
    //       if (!dataAvailableMypageLike) {
    //         getMineScrap();
    //       }
    //       break;

    //     case 2:
    //       if (!dataAvailableMypageScrap) {
    //         getMineLike();
    //       }
    //       break;
    //     default:
    //       if (!dataAvailableMypage) {
    //         getMineWrite();
    //       }
    //       break;
    //   }
    // });
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
  int get curPage {
    int page = 0;
    switch (tabController.index) {
      case 0:
        page = writePage.value;
        break;
      case 1:
        page = scrapPage.value;
        break;
      case 2:
        page = likePage.value;
        break;
      default:
        break;
    }
    return page;
  }

  int get MaxPage {
    int page = 99999;
    switch (tabController.index) {
      case 0:
        page = writeMaxPage.value;
        break;
      case 1:
        page = scrapMaxPage.value;
        break;
      case 2:
        page = likeMaxPage.value;
        break;
      default:
        break;
    }
    return page;
  }
}
