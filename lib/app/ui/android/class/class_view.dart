import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';

import 'package:polarstar_flutter/app/controller/class/class_view_controller.dart';
import 'package:polarstar_flutter/app/data/model/class/class_view_model.dart';

import 'package:polarstar_flutter/app/ui/android/class/widgets/class_preview.dart';
import 'package:polarstar_flutter/app/ui/android/class/widgets/class_search_bar.dart';
import 'package:polarstar_flutter/app/ui/android/class/widgets/app_bars.dart';

class ClassView extends StatelessWidget {
  const ClassView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ClassViewController classViewController = Get.find();

    return Scaffold(
      appBar: AppBars().classBasicAppBar(),
      body: Obx(() {
        if (classViewController.classViewAvailable.value) {
          return ListView.builder(
              itemCount: classViewController.classReviewList.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return ClassViewInfo(
                      classInfoModel: classViewController.classInfo.value);
                } else {
                  return ClassViewReview(
                      classReviewModel:
                          classViewController.classReviewList[index - 1]);
                }
              });
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}

class ClassViewInfo extends StatelessWidget {
  const ClassViewInfo({Key key, @required this.classInfoModel})
      : super(key: key);
  final ClassInfoModel classInfoModel;
  @override
  Widget build(BuildContext context) {
    final ClassViewController classViewController = Get.find();
    return Column(
      children: [
        // class preview 재사용
        Container(
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 2),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.green[800],
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(
                      Icons.book,
                      size: 60,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        classInfoModel.CLASS_NAME,
                        textScaleFactor: 1,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(classInfoModel.PROFESSOR),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow[800],
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow[800],
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow[800],
                          ),
                          Icon(
                            Icons.star_border,
                            color: Colors.yellow[800],
                          ),
                          Icon(
                            Icons.star_border,
                            color: Colors.yellow[800],
                          ),
                          Text(classInfoModel.CREDIT),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),

        // 세부 내용
        // Subject
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Subject"),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    classInfoModel.SECTOR,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
        // Team Project: 서버에서 데이터가 안날라와서 No로 설정
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Team Project"),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "No",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
        // Credit Ratio: 이것도 데이터가 안날라옴
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Credit Ratio"),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    classInfoModel.CREDIT,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
        // Attendance: 이것도 마찬가지
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Attendance"),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "99%",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
        // Number Of Exams: 이것도
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Number of Exams"),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "General",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class ClassViewReview extends StatelessWidget {
  const ClassViewReview({Key key, this.classReviewModel}) : super(key: key);
  final ClassReviewModel classReviewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: null,
    );
  }
}
