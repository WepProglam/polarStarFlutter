import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';

// class 메인 페이지에서 사용(My Last Courses)
class CoursePreview extends StatelessWidget {
  const CoursePreview({Key key, @required this.classModel}) : super(key: key);
  final ClassModel classModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        // boxShadow: [
        //   BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 2),
        // ],
      ),
      child: Ink(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            Get.toNamed('/class/view/${classModel.CLASS_ID}');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 강의 이미지
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    Icons.book,
                    size: 60,
                  ),
                ),
              ),
              // 강의명, 교수명, 평가
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classModel.CLASS_NAME,
                      textScaleFactor: 1,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(classModel.PROFESSOR),
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
                        Text(classModel.CREDIT),
                      ],
                    )
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.blue[900]),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Evaluate",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class 메인 페이지에서 사용(Recent Comments)
class CommentPreview extends StatelessWidget {
  const CommentPreview({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: null,
    );
  }
}
