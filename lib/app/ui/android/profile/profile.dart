import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polarstar_flutter/app/controller/profile/mypage_controller.dart';

class Profile extends StatelessWidget {
  final MyPageController myPageController = Get.find();

  final ImagePicker _picker = ImagePicker();

  final nicknameController = TextEditingController();

  final profilemessageController = TextEditingController();

  final box = GetStorage();

  getGalleryImage() async {
    var img = await _picker.pickImage(source: ImageSource.gallery);
    myPageController.imagePath.value = img.path;
  }

  bool showProgress = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('polarStar'),
            actions: [IconButton(onPressed: () {}, icon: Icon(Icons.person))],
          ),
          body: RefreshIndicator(
            onRefresh: myPageController.getMineWrite,
            child: Stack(
              children: [
                ListView(),
                Obx(
                  () {
                    if (myPageController.dataAvailableMypage) {
                      return Row(
                        children: [
                          Spacer(
                            flex: 80,
                          ),
                          Expanded(
                              flex: 280,
                              child: Column(children: [
                                Spacer(
                                  flex: 56,
                                ),
                                Expanded(
                                    flex: 200,
                                    child: Column(children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.defaultDialog(
                                              title: "프로필 사진을 변경하시겠습니까?",
                                              textConfirm: "네",
                                              textCancel: "아니오",
                                              confirm: ElevatedButton(
                                                  onPressed: () async {
                                                    Get.back();

                                                    await getGalleryImage();
                                                    await myPageController
                                                        .upload();
                                                  },
                                                  child: Text("네")),
                                              cancel: ElevatedButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: Text("아니오")));
                                        },
                                        child: CachedNetworkImage(
                                            imageUrl:
                                                'http://ec2-3-37-156-121.ap-northeast-2.compute.amazonaws.com:3000/uploads/${myPageController.myProfile.value.PROFILE_PHOTO}',
                                            fadeInDuration:
                                                Duration(milliseconds: 0),
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                Image(
                                                    image: AssetImage(
                                                        'image/spinner.gif')),
                                            errorWidget: (context, url, error) {
                                              print(error);
                                              return Icon(Icons.error);
                                            }),
                                      ),
                                    ])),
                                Spacer(
                                  flex: 60,
                                ),
                                Expanded(
                                  flex: 50,
                                  child: Row(
                                    children: [
                                      Text(
                                        "아이디",
                                        textScaleFactor: 1.5,
                                      ),
                                      Expanded(
                                          child: Text(
                                        "${myPageController.myProfile.value.LOGIN_ID}",
                                        style: TextStyle(fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ))
                                    ],
                                  ),
                                ),
                                Spacer(
                                  flex: 20,
                                ),
                                Expanded(
                                  flex: 50,
                                  child: Row(children: [
                                    Text(
                                      "학교",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${myPageController.myProfile.value.PROFILE_SCHOOL}",
                                        style: TextStyle(fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ]),
                                ),
                                Spacer(
                                  flex: 20,
                                ),
                                Expanded(
                                  flex: 50,
                                  child: Row(
                                    children: [
                                      Text(
                                        "프로필 메시지",
                                        textScaleFactor: 1.5,
                                      ),
                                      Expanded(
                                          child: Text(
                                        myPageController
                                            .myProfile.value.PROFILE_MESSAGE,
                                        style: TextStyle(fontSize: 20),
                                        textAlign: TextAlign.center,
                                      )),
                                      InkWell(
                                        child: Icon(Icons.edit),
                                        onTap: () {
                                          Get.defaultDialog(
                                            title: "프로필 메세지 변경",
                                            barrierDismissible: true,
                                            content: Column(
                                              children: [
                                                TextFormField(
                                                  controller:
                                                      profilemessageController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  maxLines: 1,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                    "기존 프로필 메시지 : ${myPageController.myProfile.value.PROFILE_MESSAGE}"),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      String tempProfileMsg =
                                                          profilemessageController
                                                              .text;

                                                      tempProfileMsg =
                                                          tempProfileMsg.trim();
                                                      if (tempProfileMsg
                                                          .isNotEmpty) {
                                                        if (tempProfileMsg ==
                                                            myPageController
                                                                .myProfile
                                                                .value
                                                                .PROFILE_MESSAGE) {
                                                          Get.snackbar(
                                                              "프로필 메세지가 동일합니다.",
                                                              "프로필 메세지가 동일합니다.");
                                                        } else {
                                                          await myPageController
                                                              .updateProfile(
                                                                  tempProfileMsg,
                                                                  myPageController
                                                                      .myProfile
                                                                      .value
                                                                      .PROFILE_NICKNAME);
                                                        }
                                                        print(
                                                            profilemessageController
                                                                .text);
                                                      }
                                                    },
                                                    child: Text("수정하기"))
                                              ],
                                            ),
                                          );
                                          print("수정하기");
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Spacer(
                                  flex: 20,
                                ),
                                Expanded(
                                  flex: 50,
                                  child: Row(
                                    children: [
                                      Text(
                                        "닉네임",
                                        textScaleFactor: 1.5,
                                      ),
                                      Expanded(
                                          child: Text(
                                        myPageController
                                            .myProfile.value.PROFILE_NICKNAME,
                                        style: TextStyle(fontSize: 20),
                                        textAlign: TextAlign.center,
                                      )),
                                      InkWell(
                                        child: Icon(Icons.edit),
                                        onTap: () {
                                          Get.defaultDialog(
                                            title: "닉네임 변경",
                                            content: Column(
                                              children: [
                                                TextFormField(
                                                  controller:
                                                      nicknameController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  maxLines: 1,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                    "기존 닉네임 : ${myPageController.myProfile.value.PROFILE_NICKNAME}"),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      String tempNickName =
                                                          nicknameController
                                                              .text;

                                                      tempNickName =
                                                          tempNickName.trim();
                                                      if (tempNickName
                                                          .isNotEmpty) {
                                                        if (tempNickName ==
                                                            myPageController
                                                                .myProfile
                                                                .value
                                                                .PROFILE_NICKNAME) {
                                                          Get.snackbar(
                                                              "기존 닉네임과 동일합니다.",
                                                              "기존 닉네임과 동일합니다.");
                                                        } else {
                                                          await myPageController
                                                              .updateProfile(
                                                                  myPageController
                                                                      .myProfile
                                                                      .value
                                                                      .PROFILE_MESSAGE,
                                                                  tempNickName);
                                                        }
                                                        print(
                                                            profilemessageController
                                                                .text);
                                                      }
                                                    },
                                                    child: Text("수정하기"))
                                              ],
                                            ),
                                          );
                                          print("수정하기");
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Spacer(
                                  flex: 20,
                                ),
                              ])),
                          Spacer(
                            flex: 80,
                          ),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                )
              ],
            ),
          )),
    );
  }
}
