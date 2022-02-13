import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:polarstar_flutter/app/controller/class/class_controller.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_addclass_search_controller.dart';
import 'package:polarstar_flutter/app/data/model/class/class_model.dart';
import 'package:polarstar_flutter/app/data/model/class/class_view_model.dart';
import 'package:polarstar_flutter/app/data/provider/timetable/timetable_addclass_provider.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_addclass_repository.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';

import 'package:polarstar_flutter/app/ui/android/class/widgets/class_preview.dart';
import 'package:polarstar_flutter/app/ui/android/class/widgets/class_search_bar.dart';
import 'package:polarstar_flutter/app/ui/android/functions/timetable_semester.dart';
import 'package:polarstar_flutter/app/ui/android/main/main_page_scroll.dart';

const mainColor = 0xff4570ff;
const backColor = 0xffe6f1ff;
const textColor = 0xff000000;
const whiteColor = 0xffffffff;

class Class extends StatelessWidget {
  Class({Key key}) : super(key: key);
  final ScrollController classScrollController =
      ScrollController(initialScrollOffset: 0.0);
  final FocusNode searchFocusNode = FocusNode();
  final ClassController controller = Get.find();
  final searchText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        searchFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(backColor),
        appBar: AppBar(
          toolbarHeight: 56,
          backgroundColor: Get.theme.primaryColor,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "成均馆大学",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                color: const Color(whiteColor),
                fontWeight: FontWeight.w500,
                fontFamily: "NotoSansSC",
                fontStyle: FontStyle.normal,
                fontSize: 14.0),
          ),
          actions: [
            InkWell(
              onTap: () async {
                await classScrollController.animateTo(0.0,
                    duration: Duration(milliseconds: 100),
                    curve: Curves.fastOutSlowIn);
                searchFocusNode.requestFocus();
              },
              child: Ink(
                child: Image.asset("assets/images/icn_search.png"),
              ),
            ),
          ],
        ),

        // AppBar(
        //   backgroundColor: Color(0xffffffff),
        //   elevation: 0,
        //   toolbarHeight: 50,
        //   automaticallyImplyLeading: false,
        //   titleSpacing: 0,
        //   title: Row(
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.fromLTRB(15, 1.5, 15, 1.5),
        //         child: InkWell(
        //           onTap: () {
        //             Get.back();
        //           },
        //           child: Ink(
        //             width: 9.36572265625,
        //             height: 16.6669921875,
        //             child: Image.asset(
        //               "assets/images/891.png",
        //               fit: BoxFit.fitHeight,
        //             ),
        //           ),
        //         ),
        //       ),
        //       SizedBox(
        //         width: size.width - 38.5 - 15,
        //         height: 30,
        //         child: ClassSearchBar(size: size, searchText: searchText),
        //       )
        //     ],
        //   ),
        // ),
        body: RefreshIndicator(
          onRefresh: MainUpdateModule.updateClassPage,
          child: Obx(() {
            if (!controller.dataAvailbale.value) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
              // color: const Color(0xffffffff),
              child: SingleChildScrollView(
                controller: classScrollController,
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      height: 20,
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: ClassSearchBar(
                              searchText: searchText,
                              searchFocusNode: searchFocusNode,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 20, left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("我的课程",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: const Color(textColor),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "NotoSansSC",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 18.0),
                                      textAlign: TextAlign.left),
                                ),
                                Spacer(),
                                // ! 서버에서 포인트 받아야함
                                // ! 일단 삭제
                                // Container(
                                //   margin: const EdgeInsets.only(top: 6),
                                //   child: Text("积分 100Point",
                                //       style: const TextStyle(
                                //           color: const Color(0xff571df0),
                                //           fontWeight: FontWeight.w500,
                                //           fontFamily: "NotoSansSC",
                                //           fontStyle: FontStyle.normal,
                                //           fontSize: 14.0),
                                //       textAlign: TextAlign.left),
                                // )
                              ],
                            ),
                          ),
                          controller.classList.length == 0
                              ? // Rectangle 2
                              Ink(
                                  child: InkWell(
                                    onTap: () async {
                                      CreateNewTimetable(
                                          searchText, searchFocusNode);
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 14,
                                            left: 20,
                                            right: 20,
                                            bottom: 20),
                                        height: 67,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons
                                                    .add_circle_outline_outlined,
                                                size: 24,
                                                color: const Color(0xffd6d4d4),
                                              ),
                                              Center(
                                                  child: // 补课
                                                      Text("添加课程",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: const TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              color: const Color(
                                                                  0xffd6d4d4),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontFamily:
                                                                  "NotoSansSC",
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 10.0),
                                                          textAlign: TextAlign
                                                              .center)),
                                            ]),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7)),
                                            border: Border.all(
                                                color: const Color(0xffeaeaea),
                                                width: 1),
                                            boxShadow: [
                                              BoxShadow(
                                                  color:
                                                      const Color(0x0f000000),
                                                  offset: Offset(0, 3),
                                                  blurRadius: 10,
                                                  spreadRadius: 0)
                                            ],
                                            color: const Color(0xffffffff))),
                                  ),
                                )
                              : Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, left: 20, right: 20, bottom: 10),
                                  child: // Rectangle 2
                                      ListView.builder(
                                          itemCount:
                                              controller.classList.length,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Ink(
                                              child: InkWell(
                                                onTap: () async {
                                                  searchFocusNode.unfocus();
                                                  await Get.toNamed(
                                                          '/class/view/${controller.classList[index].CLASS_ID}')
                                                      .then((value) async {
                                                    await MainUpdateModule
                                                        .updateClassPage();
                                                  });
                                                },
                                                child: ClassItem(
                                                    model: controller
                                                        .classList[index]),
                                              ),
                                            );
                                          }),
                                ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      color: const Color(backColor),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                top: 20, left: 20, right: 20),
                            child: // 最新课程评价
                                Row(children: [
                              Text("最新评价",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: const Color(textColor),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "NotoSansSC",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 18.0),
                                  textAlign: TextAlign.left),
                            ]),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 10, left: 20, right: 20),
                            child: // Rectangle 146

                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: controller.reviewList.length,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ClassRecentReview(
                                        model: controller.reviewList[index],
                                      );
                                    }),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class ClassRecentReview extends StatelessWidget {
  const ClassRecentReview({Key key, @required this.model}) : super(key: key);

  final ClassRecentReviewModel model;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed('/class/view/${model.CLASS_ID}').then((value) async {
          await MainUpdateModule.updateClassPage();
        });
      },
      child: Container(
          height: 123,
          margin: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text("${model.CLASS_NAME}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: const Color(0xff2f2f2f),
                              fontWeight: FontWeight.w500,
                              fontFamily: "NotoSansKR",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          textAlign: TextAlign.left),
                    ),
                    Spacer(),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 4.5,
                      ),
                      child: RateStarRow(rate: model.RATE),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4, left: 20, right: 20),
                child: Text("教授名：${model.PROFESSOR}",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: const Color(0xff2f2f2f),
                        fontWeight: FontWeight.w500,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0),
                    textAlign: TextAlign.left),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                    "听课学期：${timetableSemChanger(model.CLASS_YEAR, model.CLASS_SEMESTER)}",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: const Color(0xff2f2f2f),
                        fontWeight: FontWeight.w500,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0),
                    textAlign: TextAlign.left),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4, left: 20, right: 20),
                child: Text("${model.CONTENT}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: const Color(0xff6f6e6e),
                        fontWeight: FontWeight.w500,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0),
                    textAlign: TextAlign.left),
              )
            ],
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: const Color(0xffeaeaea), width: 1),
              boxShadow: [
                BoxShadow(
                    color: const Color(0x0f000000),
                    offset: Offset(0, 3),
                    blurRadius: 10,
                    spreadRadius: 0)
              ],
              color: const Color(0xffffffff))),
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
    int rate_int = rate_double.round();
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
                child: Container(
                  width: 78,
                  height: 32,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: const Color(0xff4570ff)),
                  child: Center(
                    child: Text("去评价",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w500,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                  ),
                ),
                // child: RateStarRow(rate: model.RATE),
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

class ClassSearchBar extends StatelessWidget {
  const ClassSearchBar({
    Key key,
    @required this.searchText,
    @required this.searchFocusNode,
  }) : super(key: key);

  final TextEditingController searchText;
  final FocusNode searchFocusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 48,
        child: Row(children: [
          Container(
            width: Get.mediaQuery.size.width - 20 * 2 - 6 - 68,
            child: TextFormField(
              onEditingComplete: () async {
                String text = searchText.text;
                searchText.clear();
                searchFocusNode.unfocus();

                await Get.toNamed(Routes.CLASSSEARCH,
                    arguments: {"search": text}).then((value) async {});
              },
              focusNode: searchFocusNode,
              autofocus: false,
              minLines: 1,
              maxLines: 1,
              controller: searchText,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: "NotoSansSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0),
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                isDense: true,
                hintText: "请输入搜索内容",
                hintStyle: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: const Color(0xffcecece),
                    fontWeight: FontWeight.w500,
                    fontFamily: "NotoSansSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 20, right: 0, top: 14, bottom: 14),
              ),
            ),
          ),
          // Rectangle 12
          InkWell(
            onTap: () async {
              String text = searchText.text;
              if (text.isEmpty) {
                return;
              }
              searchText.clear();
              searchFocusNode.unfocus();

              await Get.toNamed(Routes.CLASSSEARCH, arguments: {"search": text})
                  .then((value) async {});

              print(text);
            },
            child: Container(
                width: 68,
                height: 36,
                margin: const EdgeInsets.only(right: 6, top: 6, bottom: 6),
                child: Center(
                  child: // 搜索
                      Text("搜索",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w500,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          textAlign: TextAlign.left),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: const Color(0xff2f2f2f))),
          ),
        ]),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: const Color(0xfff1f1f1)));
  }
}
