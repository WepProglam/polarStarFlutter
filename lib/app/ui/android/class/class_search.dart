import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';

import 'package:polarstar_flutter/app/controller/class/class_search_controller.dart';
// import 'package:polarstar_flutter/app/ui/android/class/class.dart';

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

class RateStarRow extends StatelessWidget {
  const RateStarRow({Key key, @required this.rate}) : super(key: key);

  final String rate;

  @override
  Widget build(BuildContext context) {
    print(rate);
    double rate_double;
    try {
      rate_double = double.parse(rate);
    } catch (e) {
      rate_double = 5.0;
    }
    int rate_int = rate_double.ceil();
    return Row(children: [
      Container(
        margin: const EdgeInsets.only(left: 2),
        child: Image.asset(
          (rate_int >= 1)
              ? "assets/images/star_100.png"
              : "assets/images/star_0.png",
          width: 12,
          height: 12,
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 2),
        child: Image.asset(
          (rate_int >= 2)
              ? "assets/images/star_100.png"
              : "assets/images/star_0.png",
          width: 12,
          height: 12,
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 2),
        child: Image.asset(
          (rate_int >= 3)
              ? "assets/images/star_100.png"
              : "assets/images/star_0.png",
          width: 12,
          height: 12,
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 2),
        child: Image.asset(
          (rate_int >= 4)
              ? "assets/images/star_100.png"
              : "assets/images/star_0.png",
          width: 12,
          height: 12,
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 2),
        child: Image.asset(
          (rate_int >= 5)
              ? "assets/images/star_100.png"
              : "assets/images/star_0.png",
          width: 12,
          height: 12,
        ),
      ),
    ]);
  }
}

class ClassItem extends StatelessWidget {
  const ClassItem({Key key, @required this.model}) : super(key: key);
  final ClassModel model;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 67,
        margin: const EdgeInsets.only(bottom: 10),
        child: Container(
          margin: const EdgeInsets.fromLTRB(14, 14, 12, 14),
          child: Row(children: [
            Container(
                margin: const EdgeInsets.symmetric(vertical: 3.5),
                child: Image.asset("assets/images/icn_book.png", width: 32.0)),
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 한국문화와언어
                  Container(
                    width: Get.mediaQuery.size.width - 74 - 110,
                    // padding: const EdgeInsets.only(right: 80),
                    child: Text("${model.CLASS_NAME}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(0xff2f2f2f),
                            fontWeight: FontWeight.w500,
                            fontFamily: "NotoSansKR",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                  ), // 오광근
                  Container(
                    width: Get.mediaQuery.size.width - 74 - 110,
                    child: Text("${model.PROFESSOR}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(0xff6f6e6e),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansKR",
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0),
                        textAlign: TextAlign.left),
                  )
                ],
              ),
            ),
            Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 3.5),
              child: // Rectangle 7
                  Container(
                width: 76,
                height: 32,
                // child: Container(
                //   width: 78,
                //   height: 32,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(Radius.circular(20)),
                //       color: const Color(0xff4570ff)),
                //   child: Center(
                //     child: Text("去评价",
                //         overflow: TextOverflow.ellipsis,
                //         style: const TextStyle(
                //             overflow: TextOverflow.ellipsis,
                //             color: const Color(0xffffffff),
                //             fontWeight: FontWeight.w500,
                //             fontFamily: "NotoSansSC",
                //             fontStyle: FontStyle.normal,
                //             fontSize: 14.0),
                //         textAlign: TextAlign.left),
                //   ),
                // ),
                child: RateStarRow(rate: model.RATE),
              ),
            )
          ]),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: const Color(0xffeaeaea), width: 1),
            color: const Color(0xffffffff)));
  }
}
