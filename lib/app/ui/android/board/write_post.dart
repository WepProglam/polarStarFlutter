import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

import 'package:polarstar_flutter/app/controller/board/write_post_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/model/board/write_post_model.dart';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class WritePost extends StatelessWidget {
  final WritePostController c = Get.find();

  final Post item = Get.arguments;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController photoName = TextEditingController();

  getMultipleGallertImage(BuildContext context) async {
    c.photoAssets.value = await AssetPicker.pickAssets(context, maxAssets: 10);
  }

  getGalleryImage() async {
    var img = await _picker.pickImage(source: ImageSource.gallery);
    c.imagePath.value = img.path;
  }

  getCameraImage() async {
    var img = await _picker.pickImage(source: ImageSource.camera);
    c.imagePath.value = img.path;
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController title =
        TextEditingController(text: item == null ? "" : item.TITLE);
    final TextEditingController content =
        TextEditingController(text: item == null ? "" : item.CONTENT);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Publish Posts',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    Map<String, dynamic> data = WritePostModel(
                            title: title.text,
                            description: content.text,
                            unnamed: (c.anonymousCheck.value) ? '1' : '0')
                        .toJson();

                    //수정
                    if (c.putOrPost == "put") {
                      if (c.imagePath.value.trim() != "") {
                        await c.putPostImage(data);
                      } else {
                        await c.putPostNoImage(data);
                      }
                    }
                    //작성
                    else {
                      if (c.imagePath.value.trim() != "") {
                        await c.postPostImage(data);
                      } else {
                        await c.postPostNoImage(data);
                      }
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    child: c.putOrPost == "put"
                        ? Text(
                            '수정',
                            style: TextStyle(color: Colors.black),
                          )
                        : Text(
                            '작성',
                            style: TextStyle(color: Colors.black),
                          ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Obx(() {
          return SingleChildScrollView(
            child: Column(
              children: [
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "TITLE",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Spacer()
                ]),
                TextFormField(
                  controller: title,
                  // textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '제목을 작성하세요.',
                    isDense: true,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "CONTENT",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Spacer()
                ]),
                TextFormField(
                  controller: content,
                  // textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '내용을 작성하세요.',
                    isDense: true,
                  ),
                  maxLines: 10,
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
                            c.anonymousCheck.value = !c.anonymousCheck.value;
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
                SizedBox(
                  height: 10,
                ),
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "PHOTO",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Spacer()
                ]),
                SizedBox(
                  height: 150.0,
                  child: ListView.separated(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    scrollDirection: Axis.horizontal,
                    itemCount: c.photoAssets.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Center(
                          child: SizedBox(
                            width: 150.0,
                            height: 150.0,
                            child: index == 0
                                ? InkWell(
                                    onTap: () async {
                                      await getMultipleGallertImage(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 0.1)),
                                      child: Icon(
                                        Icons.add,
                                        size: 50,
                                      ),
                                    ),
                                  )
                                : Stack(children: [
                                    Center(
                                      child: Image(
                                          // fit: BoxFit.fill,
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
                      return Container(width: 0.1, color: Colors.black);
                    },
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
          );
        }));
  }
}
