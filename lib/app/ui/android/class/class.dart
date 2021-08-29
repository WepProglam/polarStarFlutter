import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';

import 'package:polarstar_flutter/app/controller/class/class_controller.dart';

class Class extends StatelessWidget {
  const Class({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ClassController controller = Get.find();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          leading: InkWell(
            child: Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onTap: () {
              Get.back();
            },
          ),
          leadingWidth: 35,
          titleSpacing: 0,
          title: Text(
            "Course Evaluation",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: controller.refreshPage,
          child: Obx(() {
            if (controller.classListAvailable.value) {
              return ListView.builder(
                  itemCount: controller.classList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ClassPreview(
                      classModel: controller.classList[index],
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ));
  }
}

class ClassPreview extends StatelessWidget {
  const ClassPreview({Key key, @required this.classModel}) : super(key: key);
  final ClassModel classModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 2),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(
                  Icons.book,
                  size: 80,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classModel.CLASS_NAME,
                    textScaleFactor: 1.5,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(classModel.PROFESSOR),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star),
                      Icon(Icons.star),
                      Icon(Icons.star),
                      Icon(Icons.star_border),
                      Icon(Icons.star_border),
                      Text(classModel.CREDIT),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Map example = {
  "CLASS_ID": 1,
  "CLASS_NUMBER": "BIZ2021-01",
  "CLASS_NAME": "관리회계",
  "PROFESSOR": "백태영",
  "CREDIT": "3",
  "DEGREE_COURSE": "학사",
  "SECTOR": "전공핵심",
  "REFER": "경영학과 1학년 전용 수업",
  "CLASSES": [
    {
      "day": "화요일",
      "campus": "인문사회캠퍼스",
      "online": 0,
      "end_time": "10:50",
      "classRoom": "33301",
      "start_time": "10:00",
      "toal_elpased_time": "50"
    },
    {
      "day": "목요일",
      "campus": "자연과학캠퍼스",
      "online": 0,
      "end_time": "10:50",
      "classRoom": "33310",
      "start_time": "10:00",
      "toal_elpased_time": "50"
    }
  ]
};
