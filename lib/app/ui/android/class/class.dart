import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/controller/class/class_controller.dart';

import 'package:polarstar_flutter/app/ui/android/class/widgets/class_preview.dart';
import 'package:polarstar_flutter/app/ui/android/class/widgets/class_search_bar.dart';

class Class extends StatelessWidget {
  const Class({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ClassController controller = Get.find();

    final Size size = MediaQuery.of(context).size;
    final searchText = TextEditingController();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffffffff),
          elevation: 0,
          toolbarHeight: 50,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 1.5, 15, 1.5),
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Ink(
                    width: 9.36572265625,
                    height: 16.6669921875,
                    child: Image.asset(
                      "assets/images/891.png",
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: size.width - 38.5 - 15,
                height: 30,
                child: ClassSearchBar(size: size, searchText: searchText),
              )
            ],
          ),
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
                      padding: const EdgeInsets.fromLTRB(15, 17.5, 0, 22),
                      child: Text("This Semester Courses",
                          style: const TextStyle(
                              color: const Color(0xff333333),
                              fontWeight: FontWeight.w700,
                              // fontFamily: "PingFangSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 18.0),
                          textAlign: TextAlign.left)),
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
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              }),

              // Recent comments
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(color: const Color(0xfff6f6f6)),
                  margin:
                      const EdgeInsets.only(left: 15, top: 15, bottom: 17.5),
                  child: Text("Recent comments",
                      style: const TextStyle(
                          color: const Color(0xff333333),
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.0),
                      textAlign: TextAlign.left),
                ),
              ),
              Obx(() {
                if (controller.classListAvailable.value) {
                  return SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                    return CommentPreview(
                        classReviewModel: controller.reviewList[index]);
                  }, childCount: controller.reviewList.length));
                } else {
                  return SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
