import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

import 'package:polarstar_flutter/app/controller/board/write_post_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/model/board/write_post_model.dart';

class WritePost extends StatelessWidget {
  WritePostController c = Get.find();

  Post item = Get.arguments;

  final ImagePicker _picker = ImagePicker();
  TextEditingController photoName = TextEditingController();

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
        title: Text('polarStar'),
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

                  print(data);

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
                  child: c.putOrPost == "put" ? Text('수정') : Text('작성'),
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          TextFormField(
            controller: title,
            // textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '제목을 작성하세요.',
              isDense: true,
            ),
          ),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      getGalleryImage();
                    },
                    child: Icon(Icons.photo),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      getCameraImage();
                    },
                    child: Icon(Icons.photo_camera),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: 100,
                    height: 20,
                    child: TextField(
                      style: TextStyle(fontSize: 10),
                      enabled: false,
                      controller: photoName,
                      decoration: InputDecoration(hintText: 'photo name'),
                    ),
                  ),
                ),
                Spacer(),
                Obx(
                  () {
                    return Container(
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
                    );
                  },
                ),
                Text(' 익명'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
