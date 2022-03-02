import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:polarstar_flutter/app/modules/write_post/write_post_controller.dart';
import 'package:polarstar_flutter/app/modules/init_page/init_controller.dart';

import 'package:polarstar_flutter/app/global_widgets/pushy_controller.dart';

import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/model/board/write_post_model.dart';
import 'package:polarstar_flutter/app/global_widgets/dialoge.dart';
import 'package:pushy_flutter/pushy_flutter.dart';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'package:permission_handler/permission_handler.dart';

class WritePost extends StatelessWidget {
  final WritePostController c = Get.find();

  final Rx<Post> item = Get.arguments;

  final TextEditingController photoName = TextEditingController();

  final TextEditingController title = TextEditingController(
      text: Get.arguments == null ? "" : Get.arguments.value.TITLE);
  final TextEditingController content = TextEditingController(
      text: Get.arguments == null ? "" : Get.arguments.value.CONTENT);

  getMultipleGallertImage(BuildContext context) async {
    print("???!!");
    // c.photoAssets.clear();
    List<AssetEntity> temp = await AssetPicker.pickAssets(context,
        requestType: RequestType.image,
        maxAssets: 10,
        themeColor: Get.theme.primaryColor);

    // await ImagePicker().pickMultiImage();
    // await ImagePicker().pickVideo(source: ImageSource.gallery);
    c.photoAssets.addAll(temp);
    print(temp);
    for (AssetEntity item in temp) {
      print(item.type);
    }
  }

  // getGalleryImage() async {
  //   var img = await _picker.pickImage(source: ImageSource.gallery);
  //   c.imagePath.value = img.path;
  // }

  // getCameraImage() async {
  //   var img = await _picker.pickImage(source: ImageSource.camera);
  //   c.imagePath.value = img.path;
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: AppBar(
            toolbarHeight: 56,

            backgroundColor: Get.theme.primaryColor,
            titleSpacing: 0,
            // elevation: 0,
            automaticallyImplyLeading: false,

            title: Stack(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 16.5),
                    child: Text("发布帖子",
                        style: const TextStyle(
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w500,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.center),
                  ),
                ),
                Positioned(
                  // left: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    child: Ink(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Image.asset(
                          'assets/images/back_icon.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    right: 20,
                    top: 14,
                    child: Ink(
                      child: InkWell(
                        onTap: () async {
                          if (title.text.isEmpty || content.text.isEmpty) {
                            return;
                          }
                          Map<String, dynamic> data = WritePostModel(
                                  title: title.text,
                                  description: content.text,
                                  unnamed: (c.anonymousCheck.value) ? '1' : '0')
                              .toJson();

                          Function ontapConfirm = () async {
                            Get.back();
                            // * pushy subscribe

                            print("subscribe !!");

                            if (c.putOrPost == "put") {
                              if (c.photoAssets.length > 0) {
                                await c.putPostImage(data);
                              } else {
                                await c.putPostNoImage(data);
                              }
                            } else {
                              //작성

                              if (c.photoAssets.length > 0) {
                                print("이미지 포스트");
                                await c.postPostImage(data);
                              } else {
                                print("글 포스트");
                                await c.postPostNoImage(data);
                              }
                            }

                            // ? Board ID 받아야함

                            // await PuhsyController.pushySubscribe(
                            //     "board_${c.COMMUNITY_ID}_bid_${c.BOARD_ID}");
                            // ;
                          };

                          Function ontapCancel = () {
                            Get.back();
                          };

                          await TFdialogue(
                              Get.context,
                              c.putOrPost == "put" ? "修改帖子 " : "发表帖子",
                              c.putOrPost == "put" ? "确定修改帖子内容吗？" : "确定发表帖子吗？",
                              ontapConfirm,
                              ontapCancel);
                        },
                        child: Container(
                            width: 52,
                            height: 28,
                            child: Center(
                              child: Text("发布",
                                  style: TextStyle(
                                      color: Get.theme.primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "NotoSansSC",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0),
                                  textAlign: TextAlign.right),
                            ),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14)),
                                border: Border.all(
                                    color: const Color(0xff8f90f8), width: 1),
                                color: const Color(0xffffffff))),
                      ),
                    )),
              ],
            ),
          ),
          body: SafeArea(
            child: Obx(() {
              return Stack(children: [
                SingleChildScrollView(
                  child: Container(
                    color: const Color(0xffffffff),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10, top: 24),
                          child: TextFormField(
                            controller: title,
                            maxLines: 2,
                            minLines: 1,

                            // textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: const Color(0xff6f6e6e),
                                fontWeight: FontWeight.w500,
                                fontFamily: "NotoSansSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              // contentPadding: const EdgeInsets.only(bottom: 14),
                              hintStyle: const TextStyle(
                                  color: const Color(0xff9b9b9b),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "NotoSansSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                              hintText: '标题',
                            ),
                          ),
                        ),

                        // 선 3
                        Container(
                            // width: Get0,
                            height: 1,
                            decoration:
                                BoxDecoration(color: const Color(0xffeaeaea))),

                        // Text("Content",
                        //     style: const TextStyle(
                        //         color: const Color(0xff333333),
                        //         fontWeight: FontWeight.w700,
                        //         fontFamily: "PingFangSC",
                        //         fontStyle: FontStyle.normal,
                        //         fontSize: 16.0),
                        //     textAlign: TextAlign.left),

                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: TextFormField(
                            controller: content,
                            // textAlign: TextAlign.center,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 10,

                            style: const TextStyle(
                                color: const Color(0xff6f6e6e),
                                fontWeight: FontWeight.w500,
                                fontFamily: "NotoSansSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              // contentPadding: const EdgeInsets.only(bottom: 14),
                              hintStyle: const TextStyle(
                                  color: const Color(0xff9b9b9b),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "NotoSansSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                              hintText: '请输入内容',
                            ),
                          ),
                        ),

                        // 사진 영역
                        Container(
                          height: 120.0,
                          margin: const EdgeInsets.only(top: 10),
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            itemCount: c.photoAssets.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: const EdgeInsets.only(right: 10.0),
                                child: Center(
                                  child: SizedBox(
                                    width: 120.0,
                                    height: 120.0,
                                    child: index == 0
                                        ? InkWell(
                                            onTap: () async {
                                              if (await ManagePermission
                                                  .checkPermission("storage")) {
                                                await getMultipleGallertImage(
                                                    context);
                                              } else {
                                                ManagePermission
                                                    .permissionDialog(
                                                        "Storage");
                                              }
                                            },
                                            child: Container(
                                                width: 120,
                                                height: 120,
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Center(
                                                        child: Icon(
                                                          Icons
                                                              .add_circle_outline_outlined,
                                                          color: const Color(
                                                              0xffeaeaea),
                                                          size: 20,
                                                        ),
                                                      ),
                                                      Text("照片/视频",
                                                          style: const TextStyle(
                                                              color: const Color(
                                                                  0xffd6d4d4),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontFamily:
                                                                  "NotoSansSC",
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 10.0),
                                                          textAlign:
                                                              TextAlign.center)
                                                    ]),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(8)),
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xffeaeaea),
                                                        width: 1),
                                                    color: const Color(
                                                        0xffffffff))))
                                        : Stack(children: [
                                            Center(
                                              child: Image(
                                                  width: 120,
                                                  height: 120,
                                                  fit: BoxFit.cover,
                                                  image:
                                                      AssetEntityImageProvider(
                                                          c.photoAssets[
                                                              index - 1],
                                                          isOriginal: true)),
                                            ),
                                            Positioned(
                                              child: InkWell(
                                                  onTap: () {
                                                    String photoId = c
                                                        .photoAssets[index - 1]
                                                        .id;
                                                    c.deleteTargetPhoto(
                                                        photoId);
                                                  },
                                                  child: Icon(Icons.delete)),
                                              top: 0,
                                              right: 0,
                                            ),
                                          ]),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Container(width: 7.5);
                            },
                          ),
                        ),

                        // 선 6
                        Container(
                            margin: const EdgeInsets.only(top: 20),
                            height: 1,
                            decoration:
                                BoxDecoration(color: const Color(0xffeaeaea))),

                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("匿名发布",
                                  style: const TextStyle(
                                      color: const Color(0xff9b9b9b),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "NotoSansSC",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0),
                                  textAlign: TextAlign.left),
                              Spacer(),
                              Container(
                                width: 52,
                                height: 28,
                                child: CupertinoSwitch(
                                  activeColor: Get.theme.primaryColor,
                                  value: c.anonymousCheck.value,
                                  onChanged: (bool value) {
                                    c.anonymousCheck.value =
                                        !c.anonymousCheck.value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                c.sendingPost.value
                    ? Align(
                        alignment: Alignment.center,
                        child: Container(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator()),
                      )
                    : Container()
              ]);
            }),
          )),
    );
  }
}
