import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';

import 'package:polarstar_flutter/app/controller/class/class_controller.dart';

import 'package:polarstar_flutter/app/ui/android/class/widgets/class_preview.dart';
import 'package:polarstar_flutter/app/ui/android/class/widgets/class_search_bar.dart';

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
        body: Column(
          children: [
            ClassSearchBar(),
            Expanded(
              child: RefreshIndicator(
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
              ),
            ),
          ],
        ));
  }
}
