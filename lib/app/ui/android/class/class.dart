import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/controller/class/class_controller.dart';

class Class extends StatelessWidget {
  const Class({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: Container(),
    );
  }
}
