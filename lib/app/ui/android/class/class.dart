import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';

import 'package:polarstar_flutter/app/controller/class/class_controller.dart';

import 'package:polarstar_flutter/app/ui/android/class/widgets/class_preview.dart';
import 'package:polarstar_flutter/app/ui/android/class/widgets/class_search_bar.dart';
import 'package:polarstar_flutter/app/ui/android/class/widgets/app_bars.dart';

class Class extends StatelessWidget {
  const Class({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ClassController controller = Get.find();

    return Scaffold(
      backgroundColor: Colors.grey[200],
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
        title: ClassSearchBar(),
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshPage,
        child: CustomScrollView(
          slivers: [
            // My last courses
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "My last courses",
                    textScaleFactor: 1.2,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            // CourseList
            Obx(() {
              if (controller.classListAvailable.value) {
                return SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                  return Ink(
                      color: Colors.white,
                      child: CoursePreview(
                          classModel: controller.classList[index]));
                }, childCount: controller.classList.length));
              } else {
                return SliverToBoxAdapter(
                  child: CircularProgressIndicator(),
                );
              }
            }),

            // Recent comments
            SliverToBoxAdapter(
              child: Container(
                // decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Recent Comments",
                    textScaleFactor: 1.2,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            // 원래는 강평 리스트인데 지금은 classlist임
            Obx(() {
              if (controller.classListAvailable.value) {
                return SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                  return CoursePreview(classModel: controller.classList[index]);
                }, childCount: controller.classList.length));
              } else {
                return SliverToBoxAdapter(
                  child: CircularProgressIndicator(),
                );
              }
            }),
          ],
        ),
      ),
      // Column(
      //   children: [
      //     Expanded(
      //       flex: 2,
      //       child:
      //           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //         Text("My last courses"),
      //       ]),
      //     ),
      //     Expanded(
      //       flex: 3,
      //       child: RefreshIndicator(
      //         onRefresh: controller.refreshPage,
      //         child: Obx(() {
      //           if (controller.classListAvailable.value) {
      //             return ListView.builder(
      //                 itemCount: controller.classList.length,
      //                 itemBuilder: (BuildContext context, int index) {
      //                   return CoursePreview(
      //                     classModel: controller.classList[index],
      //                   );
      //                 });
      //           } else {
      //             return Center(
      //               child: CircularProgressIndicator(),
      //             );
      //           }
      //         }),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
