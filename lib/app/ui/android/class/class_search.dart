import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';

import 'package:polarstar_flutter/app/controller/class/class_search_controller.dart';
import 'package:polarstar_flutter/app/ui/android/class/class.dart';

import 'package:polarstar_flutter/app/ui/android/class/widgets/class_preview.dart';
import 'package:polarstar_flutter/app/ui/android/class/widgets/app_bars.dart';

class ClassSearch extends StatelessWidget {
  const ClassSearch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ClassSearchController controller = Get.find();
    final FocusNode searchFocusNode = FocusNode();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 56,
          backgroundColor: Get.theme.primaryColor,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Stack(children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 18),
                child: Text(
                  "讲义评价",
                  style: const TextStyle(
                      color: const Color(0xffffffff),
                      fontWeight: FontWeight.w500,
                      fontFamily: "NotoSansSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                ),
              ),
            ),
            Positioned(
                top: 16,
                left: 20,
                child: Ink(
                    child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Image.asset(
                          'assets/images/back_icon.png',
                        ))),
                width: 24,
                height: 24)
          ]),
        ),
        body: RefreshIndicator(
          onRefresh: controller.refreshPage,
          child: Container(
            color: const Color(0xffffffff),
            child: Obx(() {
              if (controller.classSearchListAvailable.value) {
                return Container(
                  margin: const EdgeInsets.only(
                      top: 10, left: 20, right: 20, bottom: 10),
                  child: ListView.builder(
                      itemCount: controller.classSearchList.length,
                      controller: controller.scrollController,
                      itemBuilder: (BuildContext context, int index) {
                        return Ink(
                            child: InkWell(
                                onTap: () async {
                                  searchFocusNode.unfocus();
                                  await Get.toNamed(
                                          '/class/view/${controller.classSearchList[index].CLASS_ID}')
                                      .then((value) async {
                                    await MainUpdateModule.updateClassPage();
                                  });
                                },
                                child: ClassItem(
                                    model: controller.classSearchList[index])));
                      }),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
          ),
        ),
      ),
    );
  }
}
