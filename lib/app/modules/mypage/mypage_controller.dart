import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polarstar_flutter/app/data/model/sign_up_model.dart';
import 'package:polarstar_flutter/app/data/provider/sign_up_provider.dart';
import 'package:polarstar_flutter/app/data/repository/sign_up_repository.dart';
import 'package:polarstar_flutter/app/global_widgets/dialoge.dart';
import 'package:polarstar_flutter/app/global_widgets/pushy_controller.dart';
import 'package:polarstar_flutter/app/modules/classChat/class_chat_controller.dart';
import 'package:polarstar_flutter/app/modules/main_page/main_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/board_model.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/model/profile/mypage_model.dart';
import 'package:polarstar_flutter/app/data/repository/profile/mypage_repository.dart';
import 'package:polarstar_flutter/app/modules/mypage/mypage.dart';
import 'package:polarstar_flutter/app/modules/noti/noti_controller.dart';
import 'package:polarstar_flutter/app/modules/sign_up_page/sign_up_controller.dart';

import 'package:polarstar_flutter/session.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

final box = GetStorage();

class MyPageController extends GetxController
    with SingleGetTickerProviderMixin {
  final MyPageRepository repository;

  MyPageController({@required this.repository}) : assert(repository != null);

  Rx<MyProfileModel> myProfile = new MyProfileModel().obs;
  RxString PersonalInfoURL = "".obs;
  RxList<Rx<Post>> myBoardWrite = <Rx<Post>>[].obs;
  RxList<Rx<Post>> myBoardLike = <Rx<Post>>[].obs;
  RxList<Rx<Post>> myBoardScrap = <Rx<Post>>[].obs;
  RxBool doubleMajorChanged = false.obs;

  RxBool activatePushNoti = false.obs;

  Rx<int> profilePostIndex = 0.obs;
  Rx<String> imagePath = ''.obs;
  RxList<AssetEntity> photoAssets = <AssetEntity>[].obs;

  TabController tabController;

  Future<void> checkAllPushNotiActivate() async {
    String keyName = "activatePushNoti";
    if (box.read(keyName) == null) {
      box.write(keyName, true);
      activatePushNoti.value = true;
    } else if (box.read(keyName) == false) {
      activatePushNoti.value = false;
    } else {
      activatePushNoti.value = true;
    }
  }

//Tdialog 디자인가져옴
  Future<void> changeDoubleMajor() async {
    SignUpController signUpController = Get.put(SignUpController(
        repository: SignUpRepository(apiClient: SignUpApiClient())));
    await signUpController.getMajorInfo();
    final doubleMajorFocus = FocusNode();
    await Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 16.0),
      titleStyle: const TextStyle(
          color: const Color(0xff6f6e6e),
          fontWeight: FontWeight.w400,
          fontFamily: "NotoSansSC",
          fontStyle: FontStyle.normal,
          fontSize: 12.0),
      contentPadding: const EdgeInsets.only(top: 20),
      title: "补修专业",
      content: Column(children: [
        Container(
            margin: const EdgeInsets.only(bottom: 24.0, left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(22)),
                color: const Color(0xfff5f5f5)),
            child: TextFormField(
              focusNode: doubleMajorFocus,
              // onTap: () async {
              //   await Future.delayed(Duration(milliseconds: 100));
              //   majorScrollController.animateTo(
              //       majorScrollController.position.maxScrollExtent,
              //       duration: Duration(milliseconds: 100),
              //       curve: Curves.fastOutSlowIn);
              //   signUpController.majorSelected.value = false;
              // },
              style: const TextStyle(
                  color: const Color(0xff2f2f2f),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Roboto",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0),
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 11.0, 10.0, 11.0),
                  isDense: true,
                  hintText: "请用韩语输入您的专业",
                  hintStyle: const TextStyle(
                      color: const Color(0xffd6d4d4),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide:
                          BorderSide(color: const Color(0xffeaeaea), width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide:
                          BorderSide(color: const Color(0xffeaeaea), width: 1)),
                  border: InputBorder.none),
              controller: signUpController.doubleMajorController,
              onChanged: (string) {
                signUpController.doubleMajorSelected.value = false;
                print("${signUpController.majorList}");
                if (string.isEmpty) {
                  // if the search field is empty or only contains white-space, we'll display all users

                  signUpController.searchedDoubleMajorList.value = [];
                } else {
                  signUpController.searchedDoubleMajorList(signUpController
                      .majorList
                      .where((major) => major.MAJOR_NAME
                          .toLowerCase()
                          .contains(string.toLowerCase()))
                      .toList());
                  // we use the toLowerCase() method to make it case-insensitive
                }
              },
            )),
        Obx(() {
          return signUpController.doubleMajorSelected.value
              ? Container()
              : LimitedBox(
                  maxHeight: 100.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border:
                          Border.all(color: const Color(0xffeaeaea), width: 1),
                    ),
                    child: Obx(() => CupertinoScrollbar(
                        isAlwaysShown: true,
                        child: SizedBox(
                            height: 100,
                            width: 300,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: signUpController
                                    .searchedDoubleMajorList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        doubleMajorFocus.unfocus();
                                        signUpController
                                            .doubleMajorSelected.value = true;
                                        signUpController
                                                .doubleMajorController.text =
                                            signUpController
                                                .searchedDoubleMajorList[index]
                                                .MAJOR_NAME;
                                        signUpController.selectedDoubleMajor(
                                            signUpController
                                                .searchedDoubleMajorList[index]
                                                .MAJOR_ID);
                                      },
                                      child: Text(
                                        signUpController
                                            .searchedDoubleMajorList[index]
                                            .MAJOR_NAME,
                                        style: const TextStyle(
                                            color: const Color(0xff2f2f2f),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "NotoSansKR",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12.0),
                                      ),
                                    ),
                                  );
                                })))),
                  ),
                );
        }),
        // 선 122
        Container(
            margin: const EdgeInsets.only(right: 20, left: 20),
            width: 280,
            height: 1,
            decoration: BoxDecoration(color: const Color(0xffd6d4d4))),
        Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Ink(
                  child: InkWell(
                    onTap: () async {
                      var response = await Session().getX(
                          "/info/changeDoubleMajor/${signUpController.selectedDoubleMajor.value}");

                      if (response.statusCode == 200) {
                        // * 시간표 수업 추가 시 noti page 업데이트(채팅 방)

                        myProfile.update((val) async {
                          // * Rx Object update 할때는 .update 메서드 사용
                          // ! MAJOR_ID가 인덱스랑 다름 => 기존 majorList[index - 1]에서 변경
                          val.DOUBLE_MAJOR_NAME = signUpController.majorList
                              .firstWhere((CollegeMajorModel item) =>
                                  item.MAJOR_ID ==
                                  signUpController.selectedDoubleMajor.value)
                              .MAJOR_NAME;

                          await MainUpdateModule.updateNotiPage(
                            1,
                          );
                        });

                        Get.back();
                        // Get.snackbar("我换了双重专业", "我换了双重专业");
                      } else {
                        Get.snackbar(
                            "communication error", "communication error");
                      }
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Text("是",
                            style: const TextStyle(
                                color: const Color(0xff4570ff),
                                fontWeight: FontWeight.w400,
                                fontFamily: "NotoSansSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0),
                            textAlign: TextAlign.center)),
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }

  RxBool isPushySetting = false.obs;

  Future<bool> activateAllPushNoti() async {
    try {
      isPushySetting.value = true;

      String keyName = "activatePushNoti";
      if (await PuhsyController.pushySubscribe("*") == 200) {
        isPushySetting.value = false;
        box.write(keyName, true);

        return true;
      } else {
        isPushySetting.value = false;

        return false;
      }
    } catch (e) {
      isPushySetting.value = false;

      return false;
    }
  }

  Future<bool> deactivateAllPushNoti() async {
    try {
      isPushySetting.value = true;

      String keyName = "activatePushNoti";
      if (await PuhsyController.pushyUnsubscribe("*") == 200) {
        isPushySetting.value = false;
        box.write(keyName, false);

        return true;
      } else {
        isPushySetting.value = false;

        return false;
      }
    } catch (e) {
      isPushySetting.value = false;

      return false;
    }
  }

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
  int MAX_BOARDS_LIMIT = 30;

  final ScrollController scrollController =
      ScrollController(initialScrollOffset: 0.0);

  //내 프로필
  Future<void> getMineProfile() async {
    final response = await repository.getMineProfile();

    myProfile.value = response["myProfile"];
    PersonalInfoURL.value = response["PersonalInfoURL"];

    _dataAvailableMypage.value = true;
  }

  //내가 쓴 글 목록 불러옴
  Future<void> getMineWrite() async {
    final response = await repository.getMineWrite(writePage.value);
    final status = response["status"];
    MAX_BOARDS_LIMIT = response["MAX_BOARDS_LIMIT"];

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
          if (myBoardWrite.length < MAX_BOARDS_LIMIT) {
            writeMaxPage.value = writePage.value;
          }
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
    MAX_BOARDS_LIMIT = response["MAX_BOARDS_LIMIT"];

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
          if (myBoardLike.length < MAX_BOARDS_LIMIT) {
            likeMaxPage.value = likePage.value;
          }
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
    MAX_BOARDS_LIMIT = response["MAX_BOARDS_LIMIT"];

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
          if (myBoardScrap.length < MAX_BOARDS_LIMIT) {
            scrapMaxPage.value = scrapPage.value;
          }
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

    await checkAllPushNotiActivate();

    scrollController.addListener(() async {
      if ((scrollController.position.pixels ==
              scrollController.position.maxScrollExtent ||
          !scrollController.position.hasPixels)) {
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
          // Get.snackbar("프로필 사진 변경 성공", "변경 성공");

          break;

        default:
        // Get.snackbar("변경 실패", "변경 실패");
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
        // Get.snackbar("사진 변경 성공", "사진 변경 성공",
        //     snackPosition: SnackPosition.BOTTOM);

        myProfile.update((val) {
          val.PROFILE_PHOTO = value["src"];
        });
        break;
      case 500:
        // Get.snackbar("사진 변경 실패", "사진 변경 실패",
        //     snackPosition: SnackPosition.BOTTOM);
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

  void setMaxPageEqualCurPage() {
    switch (tabController.index) {
      case 0:
        writeMaxPage.value = writePage.value;
        break;
      case 1:
        scrapMaxPage.value = scrapPage.value;

        break;
      case 2:
        likeMaxPage.value = likePage.value;

        break;
      default:
        break;
    }
  }
}
