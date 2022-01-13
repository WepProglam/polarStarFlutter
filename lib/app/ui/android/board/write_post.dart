import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/controller/board/write_post_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/model/board/write_post_model.dart';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class WritePost extends StatelessWidget {
  final WritePostController c = Get.find();

  final Rx<Post> item = Get.arguments;

  final TextEditingController photoName = TextEditingController();

  getMultipleGallertImage(BuildContext context) async {
    c.photoAssets.clear();
    c.photoAssets.addAll(await AssetPicker.pickAssets(context, maxAssets: 10));
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
    final TextEditingController title =
        TextEditingController(text: item == null ? "" : item.value.TITLE);
    final TextEditingController content =
        TextEditingController(text: item == null ? "" : item.value.CONTENT);

    return SafeArea(
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
                    child: Text("新张贴物",
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
                          Map<String, dynamic> data = WritePostModel(
                                  title: title.text,
                                  description: content.text,
                                  unnamed: (c.anonymousCheck.value) ? '1' : '0')
                              .toJson();

                          await Get.defaultDialog(
                              title: "게시글 작성",
                              middleText: "게시글을 작성하시겠습니까?",
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      Get.back();
                                      if (c.putOrPost == "put") {
                                        if (c.photoAssets.length > 0) {
                                          await c.putPostImage(data);
                                        } else {
                                          await c.putPostNoImage(data);
                                        }
                                      }
                                      //작성
                                      else {
                                        if (c.photoAssets.length > 0) {
                                          print("이미지 포스트");
                                          await c.postPostImage(data);
                                        } else {
                                          print("글 포스트");
                                          await c.postPostNoImage(data);
                                        }
                                      }
                                    },
                                    child: Text("네")),
                                TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text("아니오")),
                              ]);
                          //수정
                        },
                        child: Container(
                            width: 52,
                            height: 28,
                            child: Center(
                              child: Text("张榜",
                                  style: const TextStyle(
                                      color: const Color(0xff371ac7),
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
          body: Obx(() {
            return SingleChildScrollView(
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
                            color: const Color(0xff9b9b9b),
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
                          hintText: '请输入内容.',
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
                            color: const Color(0xff9b9b9b),
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
                          hintText: '附有照片',
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
                                          await getMultipleGallertImage(
                                              context);
                                        },
                                        child: Container(
                                            width: 120,
                                            height: 120,
                                            child: Center(
                                              child: Icon(
                                                Icons
                                                    .add_circle_outline_outlined,
                                                color: const Color(0xffeaeaea),
                                                size: 20,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                                border: Border.all(
                                                    color:
                                                        const Color(0xffeaeaea),
                                                    width: 1),
                                                color:
                                                    const Color(0xffffffff))))
                                    : Stack(children: [
                                        Center(
                                          child: Image(
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.cover,
                                              image: AssetEntityImageProvider(
                                                  c.photoAssets[index - 1],
                                                  isOriginal: true)),
                                        ),
                                        Positioned(
                                          child: InkWell(
                                              onTap: () {
                                                String photoId =
                                                    c.photoAssets[index - 1].id;
                                                c.deleteTargetPhoto(photoId);
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
                                // setState(() {
                                //   _lights = value;
                                // });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Text(
                    //   "PHOTO",
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //   ),
                    // ),

                    // Center(
                    //   child: GestureDetector(
                    //     onTap: () async {
                    //       Map<String, dynamic> data = WritePostModel(
                    //               title: title.text,
                    //               description: content.text,
                    //               unnamed: (c.anonymousCheck.value) ? '1' : '0')
                    //           .toJson();

                    //       await Get.defaultDialog(
                    //           title: "게시글 작성",
                    //           middleText: "게시글을 작성하시겠습니까?",
                    //           actions: [
                    //             TextButton(
                    //                 onPressed: () async {
                    //                   Get.back();
                    //                   if (c.putOrPost == "put") {
                    //                     if (c.photoAssets.length > 0) {
                    //                       await c.putPostImage(data);
                    //                     } else {
                    //                       await c.putPostNoImage(data);
                    //                     }
                    //                   }
                    //                   //작성
                    //                   else {
                    //                     if (c.photoAssets.length > 0) {
                    //                       print("이미지 포스트");
                    //                       await c.postPostImage(data);
                    //                     } else {
                    //                       print("글 포스트");
                    //                       await c.postPostNoImage(data);
                    //                     }
                    //                   }
                    //                 },
                    //                 child: Text("네")),
                    //             TextButton(
                    //                 onPressed: () {
                    //                   Get.back();
                    //                 },
                    //                 child: Text("아니오")),
                    //           ]);
                    //       //수정
                    //     },
                    //     child: Container(
                    //       width: 288,
                    //       height: 49,
                    //       decoration: BoxDecoration(
                    //           borderRadius:
                    //               BorderRadius.all(Radius.circular(20)),
                    //           boxShadow: [
                    //             BoxShadow(
                    //                 color: const Color(0x965f88b7),
                    //                 offset: Offset(0, 13),
                    //                 blurRadius: 30,
                    //                 spreadRadius: 0)
                    //           ],
                    //           color: const Color(0xff1a4678)),
                    //       child: Center(
                    //         child: Text("Publish",
                    //             style: const TextStyle(
                    //                 color: const Color(0xffffffff),
                    //                 fontWeight: FontWeight.w700,
                    //                 // fontFamily: "PingFangSC",
                    //                 fontStyle: FontStyle.normal,
                    //                 fontSize: 18.0),
                    //             textAlign: TextAlign.center),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.all(4.0),
                    //         child: InkWell(
                    //           onTap: () async {
                    //             await getMultipleGallertImage(context);
                    //           },
                    //           child: Icon(Icons.star),
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.all(4.0),
                    //         child: InkWell(
                    //           onTap: () {
                    //             getGalleryImage();
                    //           },
                    //           child: Icon(Icons.photo),
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.all(4.0),
                    //         child: InkWell(
                    //           onTap: () {
                    //             getCameraImage();
                    //           },
                    //           child: Icon(Icons.photo_camera),
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.all(4.0),
                    //         child: Container(
                    //           width: 100,
                    //           height: 20,
                    //           child: TextField(
                    //             style: TextStyle(fontSize: 10),
                    //             enabled: false,
                    //             controller: photoName,
                    //             decoration: InputDecoration(hintText: 'photo name'),
                    //           ),
                    //         ),
                    //       ),
                    //       Spacer(),
                    //       Obx(
                    //         () {
                    //           return Container(
                    //             height: 20,
                    //             width: 20,
                    //             child: Transform.scale(
                    //               scale: 1,
                    //               child: Checkbox(
                    //                 value: c.anonymousCheck.value,
                    //                 onChanged: (value) {
                    //                   c.anonymousCheck.value =
                    //                       !c.anonymousCheck.value;
                    //                   print(c.anonymousCheck.value);
                    //                 },
                    //               ),
                    //             ),
                    //           );
                    //         },
                    //       ),
                    //       Text(' 익명'),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          })),
    );
  }
}
