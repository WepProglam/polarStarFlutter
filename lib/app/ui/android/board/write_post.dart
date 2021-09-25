import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/controller/board/write_post_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/model/board/write_post_model.dart';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class WritePost extends StatelessWidget {
  final WritePostController c = Get.find();

  final Post item = Get.arguments;

  final TextEditingController photoName = TextEditingController();

  getMultipleGallertImage(BuildContext context) async {
    c.photoAssets.value = await AssetPicker.pickAssets(context, maxAssets: 10);
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
        TextEditingController(text: item == null ? "" : item.TITLE);
    final TextEditingController content =
        TextEditingController(text: item == null ? "" : item.CONTENT);

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 30,
            backgroundColor: Color(0xffffffff),
            foregroundColor: Color(0xff333333),
            elevation: 0,
            automaticallyImplyLeading: false,
            leadingWidth: 15 + 14.6 + 9.4,
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 14.6),
                child: Ink(
                  child: Image.asset(
                    'assets/images/848.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            titleSpacing: 0,
            title: Text('Publish Posts',
                style: const TextStyle(
                    color: const Color(0xff333333),
                    fontWeight: FontWeight.w700,
                    fontFamily: "PingFangSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 21.0),
                textAlign: TextAlign.left),
            // actions: [
            //   Center(
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: InkWell(
            //         onTap: () async {
            //           Map<String, dynamic> data = WritePostModel(
            //                   title: title.text,
            //                   description: content.text,
            //                   unnamed: (c.anonymousCheck.value) ? '1' : '0')
            //               .toJson();

            //           //수정
            //           if (c.putOrPost == "put") {
            //             if (c.photoAssets.length > 0) {
            //               await c.putPostImage(data);
            //             } else {
            //               await c.putPostNoImage(data);
            //             }
            //           }
            //           //작성
            //           else {
            //             if (c.photoAssets.length > 0) {
            //               print("이미지 포스트");
            //               await c.postPostImage(data);
            //             } else {
            //               await c.postPostNoImage(data);
            //             }
            //           }
            //         },
            //         child: Container(
            //           margin: EdgeInsets.all(8),
            //           child: c.putOrPost == "put"
            //               ? Text(
            //                   '수정',
            //                   style: TextStyle(color: Colors.black),
            //                 )
            //               : Text(
            //                   '작성',
            //                   style: TextStyle(color: Colors.black),
            //                 ),
            //         ),
            //       ),
            //     ),
            //   )
            // ],
          ),
          body: Obx(() {
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 14.8, top: 21.0, right: 14.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text("Title",
                    //     style: const TextStyle(
                    //         color: const Color(0xff333333),
                    //         fontWeight: FontWeight.w700,
                    //         fontFamily: "PingFangSC",
                    //         fontStyle: FontStyle.normal,
                    //         fontSize: 16.0),
                    //     textAlign: TextAlign.left),

                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 12.3),
                      child: TextFormField(
                        controller: title,
                        // textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.normal,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          // contentPadding: const EdgeInsets.only(bottom: 14),
                          hintStyle: const TextStyle(
                              color: const Color(0xff999999),
                              fontWeight: FontWeight.w400,
                              fontFamily: "PingFangSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          hintText: 'Please enter the title',
                        ),
                      ),
                    ),

                    // Text("Content",
                    //     style: const TextStyle(
                    //         color: const Color(0xff333333),
                    //         fontWeight: FontWeight.w700,
                    //         fontFamily: "PingFangSC",
                    //         fontStyle: FontStyle.normal,
                    //         fontSize: 16.0),
                    //     textAlign: TextAlign.left),

                    TextFormField(
                      controller: content,
                      // textAlign: TextAlign.center,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 10,

                      style: const TextStyle(
                          color: const Color(0xff333333),
                          fontWeight: FontWeight.normal,
                          fontFamily: "PingFangSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        // contentPadding: const EdgeInsets.only(bottom: 14),
                        hintStyle: const TextStyle(
                            color: const Color(0xff999999),
                            fontWeight: FontWeight.w400,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        hintText: 'Please enter the content',
                      ),
                    ),
                    Row(
                      children: [
                        Spacer(),
                        Container(
                          height: 20,
                          width: 20,
                          child: Transform.scale(
                            scale: 1,
                            child: Checkbox(
                              value: c.anonymousCheck.value,
                              onChanged: (value) {
                                c.anonymousCheck.value =
                                    !c.anonymousCheck.value;
                                print(c.anonymousCheck.value);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(' 익명'),
                        ),
                      ],
                    ),

                    // Text(
                    //   "PHOTO",
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //   ),
                    // ),

                    // 사진 영역
                    Container(
                      height: 110.0,
                      margin: const EdgeInsets.only(top: 22.5, bottom: 125),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        itemCount: c.photoAssets.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: SizedBox(
                                width: 110.0,
                                height: 110.0,
                                child: index == 0
                                    ? InkWell(
                                        onTap: () async {
                                          await getMultipleGallertImage(
                                              context);
                                        },
                                        child: Stack(
                                          children: [
                                            Image.asset(
                                                "assets/images/417.png"),
                                            Center(
                                                child: Icon(
                                              Icons.add_outlined,
                                              size: 25.1,
                                              color: const Color(0xffa5a5a5),
                                            ))
                                          ],
                                        ))
                                    : Stack(children: [
                                        Center(
                                          child: Image(
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

                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          Map<String, dynamic> data = WritePostModel(
                                  title: title.text,
                                  description: content.text,
                                  unnamed: (c.anonymousCheck.value) ? '1' : '0')
                              .toJson();

                          //수정
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
                              await c.postPostNoImage(data);
                            }
                          }
                        },
                        child: Container(
                          width: 288,
                          height: 49,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0x965f88b7),
                                    offset: Offset(0, 13),
                                    blurRadius: 30,
                                    spreadRadius: 0)
                              ],
                              color: const Color(0xff1a4678)),
                          child: Center(
                            child: Text("Publish",
                                style: const TextStyle(
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "PingFangSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 18.0),
                                textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ),

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
