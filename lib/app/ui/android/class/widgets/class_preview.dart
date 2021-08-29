import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';

class ClassPreview extends StatelessWidget {
  const ClassPreview({Key key, @required this.classModel}) : super(key: key);
  final ClassModel classModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed('/class/view/${classModel.CLASS_ID}');
      },
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
            )
          ],
        ),
      ),
    );
  }
}
