import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';

import 'package:polarstar_flutter/app/controller/class/class_search_controller.dart';

import 'package:polarstar_flutter/app/ui/android/class/widgets/class_preview.dart';
import 'package:polarstar_flutter/app/ui/android/class/widgets/app_bars.dart';

class ClassSearch extends StatelessWidget {
  const ClassSearch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ClassSearchController controller = Get.find();

    return Scaffold(
      appBar: AppBars().classBasicAppBar(),
      body: RefreshIndicator(
        onRefresh: controller.refreshPage,
        child: Obx(() {
          if (controller.classSearchListAvailable.value) {
            return ListView.builder(
                itemCount: controller.classSearchList.length,
                controller: controller.scrollController,
                itemBuilder: (BuildContext context, int index) {
                  return CoursePreview(
                    classModel: controller.classSearchList[index],
                  );
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}
