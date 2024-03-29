import 'dart:io';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path/path.dart' as p;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:linkwell/linkwell.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:polarstar_flutter/app/modules/main_page/main_controller.dart';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';

import 'package:polarstar_flutter/app/modules/claa_view/class_view_controller.dart';
import 'package:polarstar_flutter/app/data/model/class/class_view_model.dart';

import 'package:polarstar_flutter/app/modules/claa_view/functions/rating.dart';

import 'package:polarstar_flutter/app/modules/claa_view/functions/semester.dart';

import 'package:polarstar_flutter/app/modules/claa_view/widgets/app_bars.dart';
import 'package:polarstar_flutter/app/modules/claa_view/widgets/modal_bottom_sheet.dart';

import 'package:polarstar_flutter/app/global_functions/timetable_semester.dart';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';

// Colors
const mainColor = 0xff4570ff;
const backgroundColor = 0xffe6f1ff;
const classInfoColor = 0xff2f2f2f;
const categoryColor = 0xff2f2f2f;

// Sizes
const starSize = 12.0;

class ClassView extends StatelessWidget {
  const ClassView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ClassViewController classViewController = Get.find();
    final reviewTextController = TextEditingController();
    final examInfoTextController = TextEditingController();
    final testStrategyController = TextEditingController();
    final pageController = PageController();

    return WillPopScope(
      onWillPop: () async {
        print("!!!");
        await MainUpdateModule.updateClassPage();
        print("@@@");
        await MainUpdateModule.updateClassSearchPage();
        print("????");
        return true;
      },
      child: Container(
        color: Get.theme.primaryColor,
        child: SafeArea(
          top: false,
          child: Scaffold(
            backgroundColor: const Color(backgroundColor),
            appBar: AppBars().classBasicAppBar(),
            // bottomSheet: Container(
            //   height: 56,
            //   child: TabBarView(
            //       controller: classViewController.tabController,
            //       children: [
            //         Ink(
            //           color: Get.theme.primaryColor,
            //           child: InkWell(
            //             onTap: () {
            //               showModalBottomSheet(
            //                   shape: RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.only(
            //                           topLeft: const Radius.circular(20),
            //                           topRight: const Radius.circular(20))),
            //                   isScrollControlled: true,
            //                   context: context,
            //                   builder: (BuildContext context) {
            //                     return WriteComment(
            //                       classInfoModel:
            //                           classViewController.classInfo.value,
            //                       // classViewController: classViewController,
            //                       reviewTextController: reviewTextController,
            //                       CLASS_ID:
            //                           classViewController.classInfo.value.CLASS_ID,
            //                     );
            //                   });
            //             },
            //             child: Container(
            //               height: 50,
            //               width: Get.mediaQuery.size.width,
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Padding(
            //                     padding: const EdgeInsets.all(8.0),
            //                     child: Icon(
            //                       Icons.post_add,
            //                       color: Colors.white,
            //                     ),
            //                   ),
            //                   Padding(
            //                     padding: const EdgeInsets.all(8.0),
            //                     child: Text(
            //                       "Writing Evaluation",
            //                       textScaleFactor: 1.2,
            //                       style: TextStyle(
            //                           color: Colors.white,
            //                           fontWeight: FontWeight.normal),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //         Ink(
            //           color: Get.theme.primaryColor,
            //           child: InkWell(
            //             onTap: () {
            //               showModalBottomSheet(
            //                   shape: RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.only(
            //                           topLeft: const Radius.circular(30),
            //                           topRight: const Radius.circular(30))),
            //                   isScrollControlled: true,
            //                   context: context,
            //                   builder: (BuildContext context) {
            //                     return WriteExamInfo(
            //                         classViewController: classViewController,
            //                         examInfoTextController: examInfoTextController,
            //                         testStrategyController: testStrategyController);
            //                   });
            //             },
            //             child: Container(
            //               height: 50,
            //               width: Get.mediaQuery.size.width,
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Padding(
            //                     padding: const EdgeInsets.all(8.0),
            //                     child: Icon(
            //                       Icons.add_circle_outline,
            //                       color: Colors.white,
            //                     ),
            //                   ),
            //                   Padding(
            //                     padding: const EdgeInsets.all(8.0),
            //                     child: Text(
            //                       "Add Exam Information",
            //                       textScaleFactor: 1.2,
            //                       style: TextStyle(
            //                           color: Colors.white,
            //                           fontWeight: FontWeight.normal),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       ]),
            // ),

            body: RefreshIndicator(
              notificationPredicate: (notification) {
                return notification.depth == 2;
              },
              onRefresh: classViewController.refreshPage,
              child: Obx(() {
                if (classViewController.classViewAvailable.value) {
                  return NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            automaticallyImplyLeading: false,
                            pinned: false,
                            floating: false,
                            snap: false,
                            forceElevated: false,
                            elevation: 0,
                            expandedHeight: 300.0,
                            flexibleSpace: FlexibleSpaceBar(
                              // collapseMode: CollapseMode.pin,
                              background: ClassViewInfo(
                                  classInfoModel:
                                      classViewController.classInfo.value),
                            ),
                            backgroundColor: const Color(backgroundColor),
                          ),
                          // SliverPersistentHeader(
                          //   pinned: true,
                          //   delegate: MenuTabBar(
                          //     classViewController: classViewController,
                          //     tabBar: TabBar(
                          //       controller: classViewController.tabController,
                          //       labelColor: const Color(0xffffffff),
                          //       unselectedLabelColor: const Color(0xff2f2f2f),
                          //       labelStyle: const TextStyle(
                          //           fontWeight: FontWeight.w500,
                          //           fontFamily: "NotoSansSC",
                          //           fontStyle: FontStyle.normal,
                          //           fontSize: 14.0),
                          //       indicator: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(8.0),
                          //           color: Get.theme.primaryColor),
                          //       tabs: <Tab>[
                          //         Tab(
                          //           text: "讲义评价",
                          //         ),
                          //         Tab(
                          //           text: "考试信息",
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ];
                      },
                      body: Column(children: [
                        Container(
                          height: 44,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: const Color(0xffffffff)),
                          margin: const EdgeInsets.only(
                              top: 16, left: 20, right: 20, bottom: 0),
                          child: TabBar(
                            controller: classViewController.tabController,
                            labelColor: const Color(0xffffffff),
                            unselectedLabelColor: const Color(0xff2f2f2f),
                            labelStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: "NotoSansSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Get.theme.primaryColor),
                            tabs: <Tab>[
                              Tab(
                                text: "讲义评价",
                              ),
                              Tab(
                                text: "考试信息",
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                              controller: classViewController.tabController,
                              children: [
                                Stack(children: [
                                  ListView.builder(
                                    padding: const EdgeInsets.only(top: 20),
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index == 0) {
                                        if (index ==
                                            classViewController
                                                    .classReviewList.length -
                                                1) {
                                          return Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8))),
                                            child: ClassViewReview(
                                              classReviewModel:
                                                  classViewController
                                                      .classReviewList[index],
                                              index: index,
                                            ),
                                          );
                                        }
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(8))),
                                          child: ClassViewReview(
                                            classReviewModel:
                                                classViewController
                                                    .classReviewList[index],
                                            index: index,
                                          ),
                                        );
                                      } else if (index ==
                                          classViewController
                                                  .classReviewList.length -
                                              1) {
                                        return

                                            // Container(
                                            //   height: 1000,
                                            //   color: Colors.red,
                                            // );
                                            Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 60.0),
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        bottom: Radius.circular(
                                                            8))),
                                            child: ClassViewReview(
                                              classReviewModel:
                                                  classViewController
                                                      .classReviewList[index],
                                              index: index,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return

                                            // Container(
                                            //   height: 1000,
                                            //   color: Colors.red,
                                            // );
                                            Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: ClassViewReview(
                                            classReviewModel:
                                                classViewController
                                                    .classReviewList[index],
                                            index: index,
                                          ),
                                        );
                                      }
                                    },
                                    itemCount: classViewController
                                        .classReviewList.length,
                                    // separatorBuilder: (context, index) {
                                    //   return ;
                                    // },
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Container(
                                      color: Get.theme.primaryColor,
                                      child: InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: const Radius
                                                              .circular(20),
                                                          topRight: const Radius
                                                              .circular(20))),
                                              isScrollControlled: true,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return WriteComment(
                                                  classInfoModel:
                                                      classViewController
                                                          .classInfo.value,
                                                  // classViewController: classViewController,
                                                  reviewTextController:
                                                      reviewTextController,
                                                  CLASS_ID: classViewController
                                                      .classInfo.value.CLASS_ID,
                                                );
                                              });
                                        },
                                        child: Container(
                                            height: 50,
                                            width: Get.mediaQuery.size.width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Padding(
                                                //   padding: const EdgeInsets.all(8.0),
                                                //   child: Icon(
                                                //     Icons.post_add,
                                                //     color: Colors.white,
                                                //   ),
                                                // ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "写讲义评价",
                                                    // textScaleFactor: 1.2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color: const Color(
                                                            0xffffffff),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            "NotoSansSC",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 14.0),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ),
                                ]),
                                Obx(() {
                                  if (classViewController
                                      .classExamAvailable.value) {
                                    return Stack(children: [
                                      Positioned.fill(
                                        child: ListView.separated(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              if (index ==
                                                  classViewController
                                                          .classExamList
                                                          .length -
                                                      1) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 60.0),
                                                  child: ClassExamInfo(
                                                    classExamModel:
                                                        classViewController
                                                                .classExamList[
                                                            index],
                                                    classInfoModel:
                                                        classViewController
                                                            .classInfo.value,
                                                    index: index,
                                                  ),
                                                );
                                              }
                                              return ClassExamInfo(
                                                classExamModel:
                                                    classViewController
                                                        .classExamList[index],
                                                classInfoModel:
                                                    classViewController
                                                        .classInfo.value,
                                                index: index,
                                              );
                                            },
                                            itemCount: classViewController
                                                .classExamList.length,
                                            separatorBuilder: (context, index) {
                                              return Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 34.5),
                                                  height: 1,
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xffeaeaea)));
                                            }),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        child: Container(
                                          color: Get.theme.primaryColor,
                                          child: InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft: const Radius
                                                              .circular(30),
                                                          topRight: const Radius
                                                              .circular(30))),
                                                  isScrollControlled: true,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return WriteExamInfo(
                                                        classViewController:
                                                            classViewController,
                                                        examInfoTextController:
                                                            examInfoTextController,
                                                        testStrategyController:
                                                            testStrategyController);
                                                  });
                                            },
                                            child: Container(
                                                height: 50,
                                                width:
                                                    Get.mediaQuery.size.width,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    // Padding(
                                                    //   padding:
                                                    //       const EdgeInsets.all(8.0),
                                                    //   child: Icon(
                                                    //     Icons.add_circle_outline,
                                                    //     color: Colors.white,
                                                    //   ),
                                                    // ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "写考试信息",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        // textScaleFactor: 1.2,
                                                        style: const TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            color: const Color(
                                                                0xffffffff),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                "NotoSansSC",
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 14.0),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ),
                                    ]);
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                })
                              ]),
                        ),
                      ]));

                  //     CustomScrollView(
                  //   slivers: <Widget>[
                  //     // 강의 정부
                  //     SliverToBoxAdapter(
                  //       child: ClassViewInfo(
                  //           classInfoModel: classViewController.classInfo.value),
                  //     ),
                  //     // Comment, Exam Info Tabbar
                  //     SliverPersistentHeader(
                  //         pinned: true,
                  //         delegate: MenuTabBar(
                  //           classViewController: classViewController,
                  //           tabBar: TabBar(
                  //             controller: classViewController.tabController,
                  //             labelColor: const Color(0xffffffff),
                  //             unselectedLabelColor: const Color(0xff2f2f2f),
                  //             labelStyle: const TextStyle(
                  //                 fontWeight: FontWeight.w500,
                  //                 fontFamily: "NotoSansSC",
                  //                 fontStyle: FontStyle.normal,
                  //                 fontSize: 14.0),
                  //             indicator: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(8.0),
                  //                 color: Get.theme.primaryColor),
                  //             tabs: <Tab>[
                  //               Tab(
                  //                 text: "在校生交流区",
                  //               ),
                  //               Tab(
                  //                 text: "考试攻略",
                  //               ),
                  //             ],
                  //           ),
                  //         )),

                  //     SliverFillRemaining(

                  //       child: TabBarView(
                  //           controller: classViewController.tabController,
                  //           children: <Widget>[
                  //             ListView.separated(
                  //                 // physics: NeverScrollableScrollPhysics(),
                  //                 itemBuilder: (context, index) {
                  //                   return ClassViewReview(
                  //                     classReviewModel: classViewController
                  //                         .classReviewList[index],
                  //                     index: index,
                  //                   );
                  //                 },
                  //                 separatorBuilder: (context, index) {
                  //                   return Container(
                  //                       width: 292,
                  //                       height: 1,
                  //                       decoration: BoxDecoration(
                  //                           color: const Color(0xffeaeaea)));
                  //                 },
                  //                 itemCount:
                  //                     classViewController.classReviewList.length),
                  //             ListView.separated(
                  //                 // physics: NeverScrollableScrollPhysics(),
                  //                 itemBuilder: (context, index) {
                  //                   return ClassViewReview(
                  //                     classReviewModel: classViewController
                  //                         .classReviewList[index],
                  //                     index: index,
                  //                   );
                  //                 },
                  //                 separatorBuilder: (context, index) {
                  //                   return Container(
                  //                       width: 292,
                  //                       height: 1,
                  //                       decoration: BoxDecoration(
                  //                           color: const Color(0xffeaeaea)));
                  //                 },
                  //                 itemCount:
                  //                     classViewController.classReviewList.length),
                  //           ]),
                  //     ),
                  //     // SliverPersistentHeader(pinned: true, delegate: IndexButton()),
                  //     // SliverToBoxAdapter(
                  //     //   child: Container(
                  //     //     width: Get.mediaQuery.size.width,
                  //     //     height: 10,
                  //     //   ),
                  //     // ),
                  //     // Obx(() {
                  //     //   if (classViewController.typeIndex == 0) {
                  //     //     return SliverList(
                  //     //       delegate: SliverChildBuilderDelegate(
                  //     //           (BuildContext context, int index) {
                  //     //         return GestureDetector(
                  //     //           //* SWAPPING remove
                  //     //           /* onHorizontalDragEnd: (dragEnd) {
                  //     //             if (dragEnd.primaryVelocity < 0) {
                  //     //               classViewController.typeIndex(1);
                  //     //             }
                  //     //           }, */
                  //     //           child: ClassViewReview(
                  //     //             classReviewModel:
                  //     //                 classViewController.classReviewList[index],
                  //     //             index: index,
                  //     //           ),
                  //     //         );
                  //     //       },
                  //     //           childCount:
                  //     //               classViewController.classReviewList.length),
                  //     //     );
                  //     //   } else {
                  //     //     if (classViewController.classExamAvailable.value) {
                  //     //       return SliverList(
                  //     //         delegate: SliverChildBuilderDelegate(
                  //     //             (BuildContext context, int index) {
                  //     //           return GestureDetector(
                  //     //             //* SWAPPING remove
                  //     //             /* onHorizontalDragEnd: (dragEnd) {
                  //     //               if (dragEnd.primaryVelocity > 0) {
                  //     //                 classViewController.typeIndex(0);
                  //     //               }
                  //     //             }, */
                  //     //             child: ClassExamInfo(
                  //     //               classExamModel:
                  //     //                   classViewController.classExamList[index],
                  //     //               classInfoModel:
                  //     //                   classViewController.classInfo.value,
                  //     //               index: index,
                  //     //             ),
                  //     //           );
                  //     //         },
                  //     //             childCount:
                  //     //                 classViewController.classExamList.length),
                  //     //       );
                  //     //     } else {
                  //     //       return SliverToBoxAdapter(
                  //     //           child: GestureDetector(
                  //     //         onHorizontalDragEnd: (dragEnd) {
                  //     //           if (dragEnd.primaryVelocity > 0) {
                  //     //             classViewController.typeIndex(0);
                  //     //           }
                  //     //         },
                  //     //         child: Center(
                  //     //           child: CircularProgressIndicator(),
                  //     //         ),
                  //     //       ));
                  //     //     }
                  //     //   }
                  //     // }),
                  //     // SliverToBoxAdapter(
                  //     //     child: SizedBox(
                  //     //   height: 50,
                  //     // )),
                  //   ],
                  // );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class ClassViewInfo extends StatelessWidget {
  const ClassViewInfo({Key key, @required this.classInfoModel})
      : super(key: key);
  final ClassInfoModel classInfoModel;

  @override
  Widget build(BuildContext context) {
    // final ClassViewController classViewController = Get.find();
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Container(
            height: 100,
            margin: EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 14.0),
            padding: EdgeInsets.fromLTRB(20.0, 23.0, 20.0, 20.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: const Color(0xffeaeaea), width: 1),
                color: const Color(classInfoColor)),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${classInfoModel.CLASS_NAME}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansKR",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),
                  Text("${classInfoModel.PROFESSOR}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: const Color(0xff6f6e6e),
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansKR",
                          fontStyle: FontStyle.normal,
                          fontSize: 12.0),
                      textAlign: TextAlign.left),
                  Row(
                    children: [
                      Container(
                        width: 68.0,
                        height: 12.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: classInfoModel.AVG_RATE != null
                              ? rate_star(classInfoModel.AVG_RATE, 12.0)
                              : rate_star("0.0", 12.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                            classInfoModel.AVG_RATE != null
                                ? "(${double.parse(classInfoModel.AVG_RATE).toStringAsFixed(1)})"
                                : "",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            textAlign: TextAlign.left),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),

          // 세부 내용
          Column(
            children: [
              // SECTOR
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text("作业量",
                    //     overflow: TextOverflow.ellipsis,
                    //     style: const TextStyle(
                    //         overflow: TextOverflow.ellipsis,
                    //         color: const Color(categoryColor),
                    //         fontWeight: FontWeight.w400,
                    //         fontFamily: "NotoSansSC",
                    //         fontStyle: FontStyle.normal,
                    //         fontSize: 14.0),
                    //     textAlign: TextAlign.left),
                    Spacer(),
                    Text(
                      classInfoModel.CLASS_SECTOR_2 == null
                          ? ""
                          : "${classInfoModel.CLASS_SECTOR_2}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: const Color(0xff333333),
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansKR",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              ),
              //* 말하기 속도, 억양, 사투리
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("教授语速、方言等",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(categoryColor),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NㅋotoSansTC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    Container(
                      width: 68,
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: classInfoModel.AVG_RATE_LANGUAGE != null
                            ? rate_heart(
                                classInfoModel.AVG_RATE_LANGUAGE, starSize)
                            : rate_heart("0.0", starSize),
                      ),
                    ),
                  ],
                ),
              ),
              //* 외국인을 대하는 태도
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("教授对留学生的态度",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(categoryColor),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    Container(
                      width: 68,
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: classInfoModel.AVG_RATE_ATTITUDE != null
                            ? rate_heart(
                                classInfoModel.AVG_RATE_ATTITUDE, starSize)
                            : rate_heart("0.0", starSize),
                      ),
                    ),
                  ],
                ),
              ),
              //* 시험 난이도
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("考试难度",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(categoryColor),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    Container(
                      width: 68,
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:
                            classInfoModel.AVG_RATE_EXAM_DIFFICULTY != null
                                ? rate_heart(
                                    classInfoModel.AVG_RATE_EXAM_DIFFICULTY,
                                    starSize)
                                : rate_heart("0.0", starSize),
                      ),
                    ),
                  ],
                ),
              ),
              //* 과제량
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("作业量",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(0xff2f2f2f),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    Container(
                      width: 68,
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: classInfoModel.AVG_RATE_ASSIGNMENT != null
                            ? rate_heart(
                                classInfoModel.AVG_RATE_ASSIGNMENT, starSize)
                            : rate_heart("0.0", starSize),
                      ),
                    ),
                  ],
                ),
              ),
              //* 학점 비율
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("给分",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(0xff2f2f2f),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    Container(
                      width: 68,
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: classInfoModel.AVG_RATE_GRADE != null
                            ? rate_heart(
                                classInfoModel.AVG_RATE_GRADE, starSize)
                            : rate_heart("0.0", starSize),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
          // Sector
        ],
      ),
    );
  }
}

class ClassViewReview extends StatelessWidget {
  const ClassViewReview({Key key, this.classReviewModel, this.index})
      : super(key: key);
  final ClassReviewModel classReviewModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final ClassViewController classViewController = Get.find();
    print(classReviewModel.CLASS_YEAR);
    print(classReviewModel.CLASS_SEMESTER);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //* 별점 & 좋아요
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(right: 4.0),
                          width: 68,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: rate_star(classReviewModel.RATE, 12))),
                      Text("(${classReviewModel.RATE})",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: const Color(0xffd6d4d4),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 10.0),
                          textAlign: TextAlign.center),
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    splashColor: Colors.cyan[100].withOpacity(0.6),
                    onTap: () async {
                      await classViewController.getCommentLike(
                          classReviewModel.CLASS_ID,
                          classReviewModel.CLASS_COMMENT_ID,
                          index);
                    },
                    child: Container(
                      width: 25.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                              classReviewModel.ALREADY_LIKED
                                  ? "assets/images/414.png"
                                  : "assets/images/icn_reply_like_color.png",
                              height: 12,
                              width: 12),
                          Text(classReviewModel.LIKES.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: const Color(0xff6ea5ff),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "NotoSansKR",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 10.0))
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await classViewController.arrestClassCommentFunc(index);
                    },
                    child: Container(
                      width: 25.0,
                      margin: EdgeInsets.only(left: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                              classReviewModel.ALREADY_ACCUSED
                                  ? "assets/images/413.png"
                                  : "assets/images/415.png",
                              height: 12,
                              width: 12),
                          Text(classReviewModel.ACCUSE_AMOUNT.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: const Color(0xff6ea5ff),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "NotoSansKR",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 10.0))
                        ],
                      ),
                    ),
                  ),

                  //   TextButton.icon(
                  //       style: ButtonStyle(
                  //           foregroundColor:
                  //               MaterialStateProperty.all(Colors.cyan[200]),
                  //           overlayColor: MaterialStateProperty.all(
                  //               Colors.cyan[100].withOpacity(0.6))),
                  //       onPressed: () async {
                  //         await classViewController.getCommentLike(
                  //             classReviewModel.CLASS_ID,
                  //             classReviewModel.CLASS_COMMENT_ID,
                  //             index);
                  //       },
                  //       icon: Icon(Icons.thumb_up, size: 12),
                  //       label: Text(classReviewModel.LIKES.toString()))
                ]),
          ),

          // * 수강 학기: 데이터 안 날라옴
          Text(
              "${timetableSemChanger(classReviewModel.CLASS_YEAR, classReviewModel.CLASS_SEMESTER)}",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: const Color(0xff9b9b9b),
                  fontWeight: FontWeight.w300,
                  fontFamily: "NotoSansSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 10.0),
              textAlign: TextAlign.left),

          Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 14.0),
              width: Get.mediaQuery.size.width,
              // decoration: BoxDecoration(
              //     color: Colors.grey[200],
              //     borderRadius: BorderRadius.circular(10)),
              child: LinkWell(
                "${classReviewModel.CONTENT}",
                // overflow: TextOverflow.ellipsis,
                linkStyle: TextStyle(
                    // overflow: TextOverflow.ellipsis,
                    color: Get.theme.primaryColor,
                    fontWeight: FontWeight.w300,
                    fontFamily: "NotoSansSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 10.0),
                style: const TextStyle(
                    // overflow: TextOverflow.ellipsis,
                    color: const Color(0xff2f2f2f),
                    fontWeight: FontWeight.w300,
                    fontFamily: "NotoSansSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 10.0),
              )),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 0.0),
              height: 1,
              decoration: BoxDecoration(color: const Color(0xffeaeaea)))
        ],
      ),
    );
  }
}

class ClassExamInfo extends StatelessWidget {
  const ClassExamInfo(
      {Key key,
      @required this.classExamModel,
      @required this.classInfoModel,
      this.index})
      : super(key: key);
  final ClassExamModel classExamModel;
  final ClassInfoModel classInfoModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final ClassViewController classViewController = Get.find();

    return Stack(children: [
      Container(
          child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),

        //! 구매 여부에 따른 블러 처리
        // imageFilter: classExamModel.IS_BUYED
        //     ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
        //     : ImageFilter.blur(
        //         sigmaX: 5.0, sigmaY: 5.0, tileMode: TileMode.decal),
        child: GestureDetector(
          onTap: () {
            //! 구매기능 제거
            // if (classExamModel.IS_BUYED) {
            //   print("이미 구매한 정보");
            // } else {
            //   Get.defaultDialog(
            //       title: "시험 정보 구매",
            //       middleText: "시험 정보를 구매하시겠습니까?",
            //       actions: [
            //         TextButton(
            //             onPressed: () async {
            //               Get.back();
            //               await classViewController.buyExamInfo(
            //                   classExamModel.CLASS_ID,
            //                   classExamModel.CLASS_EXAM_ID);
            //             },
            //             child: Text("네", overflow: TextOverflow.ellipsis)),
            //         TextButton(
            //             onPressed: () {
            //               Get.back();
            //             },
            //             child: Text(
            //               "아니요",
            //               overflow: TextOverflow.ellipsis,
            //             )),
            //       ]);
            // }
          },
          child: Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //* 시험 종류
                  Row(
                    children: [
                      Text(
                        classExamModel.MID_FINAL != null
                            ? "${classExamModel.MID_FINAL}"
                            : "Unknown",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(0xff2f2f2f),
                            fontWeight: FontWeight.w500,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                      ),
                      Spacer(),
                      InkWell(
                        splashColor: Colors.cyan[100].withOpacity(0.6),
                        onTap: () async {
                          await classViewController.getExamLike(
                              classExamModel.CLASS_ID,
                              classExamModel.CLASS_EXAM_ID,
                              index);
                        },
                        child: Container(
                          width: 25.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                  classExamModel.ALREADY_LIKED
                                      ? "assets/images/414.png"
                                      : "assets/images/icn_reply_like_color.png",
                                  height: 12,
                                  width: 12),
                              Text(classExamModel.LIKES.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: const Color(0xff6ea5ff),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "NotoSansKR",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 10.0))
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await classViewController.arrestClassExamFunc(index);
                        },
                        child: Container(
                          width: 25.0,
                          margin: EdgeInsets.only(left: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                  classExamModel.ALREADY_ACCUSED
                                      ? "assets/images/413.png"
                                      : "assets/images/415.png",
                                  height: 12,
                                  width: 12),
                              Text(classExamModel.ACCUSE_AMOUNT.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: const Color(0xff6ea5ff),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "NotoSansKR",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 10.0))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  //* 학기 정보
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                        "${timetableSemChanger(classExamModel.CLASS_EXAM_YEAR, classExamModel.CLASS_EXAM_SEMESTER)}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: const Color(0xff6f6e6e),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0),
                        textAlign: TextAlign.left),
                  ),
                  //* 문제 유형
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            "考试类型 :",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: const Color(0xff2f2f2f),
                                fontWeight: FontWeight.w500,
                                fontFamily: "NotoSansSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                          ),
                        ),
                        classExamModel.TEST_TYPE != null
                            ? Text(
                                classExamModel.TEST_TYPE,
                                // overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    // overflow: TextOverflow.ellipsis,
                                    color: const Color(0xff6f6e6e),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "NotoSansSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12.0),
                              )
                            : Text('')
                      ],
                    ),
                  ),
                  //* 시험 전략
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text("考试攻略 :",
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
                          ],
                        ),
                        (classExamModel.FILE.length != 0)
                            ? Container(
                                margin: EdgeInsets.only(top: 10),
                                height: 40,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: classExamModel.FILE.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                          onTap: () async {
                                            // * 이미 다운 받았으면 return

                                            final status = await Permission
                                                .storage
                                                .request();

                                            if (status.isGranted) {
                                              String dirloc = "";
                                              if (Platform.isAndroid) {
                                                dirloc = "/sdcard/download/";
                                              } else {
                                                dirloc =
                                                    (await getApplicationDocumentsDirectory())
                                                        .absolute
                                                        .path;
                                              }

                                              if (!Directory(dirloc)
                                                  .existsSync()) {
                                                dirloc =
                                                    (await getApplicationDocumentsDirectory())
                                                        .absolute
                                                        .path;
                                                if (!Directory(dirloc)
                                                    .existsSync()) {
                                                  Directory(dirloc)
                                                      .create(recursive: true);
                                                }
                                              }

                                              String file_name = classExamModel
                                                      .FILE_META[index]
                                                  ["file_name"];
                                              // * 파일 이름 중복
                                              if (File(
                                                      p.join(dirloc, file_name))
                                                  .existsSync()) {
                                                int i = 1;
                                                int string_length =
                                                    file_name.length;
                                                String a = "aa.aa";
                                                a.lastIndexOf(".");
                                                int extend_length = file_name
                                                        .split(".")
                                                        .last
                                                        .length +
                                                    1;
                                                int add_number_index =
                                                    string_length -
                                                        extend_length -
                                                        1;
                                                // String dupliacte_file_name = file_name
                                                while (File(p.join(
                                                        dirloc,
                                                        file_name.substring(
                                                                0,
                                                                file_name
                                                                    .lastIndexOf(
                                                                        ".")) +
                                                            "(${i})." +
                                                            file_name
                                                                .split(".")
                                                                .last))
                                                    .existsSync()) {
                                                  i += 1;
                                                }

                                                file_name = file_name.substring(
                                                        0,
                                                        file_name
                                                            .lastIndexOf(".")) +
                                                    "(${i})." +
                                                    file_name.split(".").last;
                                              }

                                              print(dirloc);
                                              print(
                                                  "==============================");

                                              final String taskID =
                                                  await FlutterDownloader.enqueue(
                                                      url: classExamModel
                                                          .FILE[index],
                                                      savedDir: dirloc,
                                                      fileName: file_name,
                                                      showNotification: true,
                                                      openFileFromNotification:
                                                          true,
                                                      saveInPublicStorage:
                                                          true);

                                              print("downloaded!!");
                                            } else {
                                              print('Permission Denied');
                                            }
                                          },
                                          child: Container(
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              width: 155,
                                              height: 40,
                                              child: Container(
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                    Image.asset(
                                                        "assets/images/594.png",
                                                        height: 16,
                                                        width: 16),
                                                    Text(
                                                        classExamModel
                                                                .FILE_META[index]
                                                            ["file_name"],
                                                        style: const TextStyle(
                                                            color: const Color(
                                                                0xff9b9b9b),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                "NotoSansSC",
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 10.0),
                                                        textAlign:
                                                            TextAlign.center)
                                                  ])),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7)),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xffeaeaea),
                                                      width: 1),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: const Color(
                                                            0x0f000000),
                                                        offset: Offset(0, 3),
                                                        blurRadius: 10,
                                                        spreadRadius: 0)
                                                  ],
                                                  color: const Color(
                                                      0xffffffff))));
                                    }))
                            : Container(),
                        (classExamModel.PHOTO.length != 0)
                            ? Container(
                                margin: EdgeInsets.only(top: 10),
                                height: 86,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: classExamModel.PHOTO.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                          margin: EdgeInsets.only(right: 10),
                                          width: 86,
                                          height: 86,
                                          child: CachedNetworkImage(
                                              imageUrl:
                                                  classExamModel.PHOTO[index],
                                              imageBuilder: (context, imageProvider) => Container(
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.fill))),
                                              fadeInDuration:
                                                  Duration(milliseconds: 0),
                                              progressIndicatorBuilder:
                                                  (context, url, downloadProgress) =>
                                                      Image(
                                                          image: AssetImage(
                                                              'assets/images/spinner.gif')),
                                              errorWidget: (context, url, error) {
                                                print(error);
                                                return Icon(Icons.error);
                                              }),
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
                                              color: const Color(0xffffffff)));
                                    }))
                            : Container(),
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: classExamModel.TEST_STRATEGY != null
                                ? LinkWell(
                                    "${classExamModel.TEST_STRATEGY}",
                                    //overflow: TextOverflow.ellipsis,
                                    linkStyle: TextStyle(
                                        // overflow: TextOverflow.ellipsis,
                                        color: Get.theme.primaryColor,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "NotoSansSC",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12.0),
                                    style: const TextStyle(
                                        color: const Color(0xff6f6e6e),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "NotoSansSC",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14.0),
                                    textAlign: TextAlign.left,
                                  )
                                : Text(''))
                      ])),

                  //* 시험 예시
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            "考试真题 :",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: const Color(0xff2f2f2f),
                                fontWeight: FontWeight.w500,
                                fontFamily: "NotoSansSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            // height: 54.0,
                            child: classExamModel.TEST_EXAMPLE != null
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        classExamModel.TEST_EXAMPLE.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      print(classExamModel.TEST_EXAMPLE);
                                      if (index ==
                                          classExamModel.TEST_EXAMPLE.length -
                                              1) {
                                        return classExamModel
                                                    .TEST_EXAMPLE[index] !=
                                                null
                                            ? Text(
                                                classExamModel
                                                    .TEST_EXAMPLE[index],
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color:
                                                        const Color(0xff6f6e6e),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "NotoSansSC",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0),
                                              )
                                            : Text('');
                                      }
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: classExamModel
                                                    .TEST_EXAMPLE[index] !=
                                                null
                                            ? Text(
                                                classExamModel
                                                    .TEST_EXAMPLE[index],
                                                // overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    // overflow: TextOverflow.ellipsis,
                                                    color:
                                                        const Color(0xff6f6e6e),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "NotoSansSC",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0),
                                              )
                                            : Text(''),
                                      );
                                    })
                                : Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      "There are no examples",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )),

      //! 블러 위 텍스트 일단 제거
      // Positioned.fill(
      //     child: Align(
      //         alignment: Alignment.center,
      //         child: Container(
      //             child: Text(
      //           classExamModel.IS_BUYED
      //               ? ""
      //               : '시험 정보를 구매해야 열람할 수 있습니다!\n' +
      //                   '현재 내 포인트 : ${classInfoModel.MY_CLASS_POINT}',
      //           overflow: TextOverflow.ellipsis,
      //           textAlign: TextAlign.center,
      //           style: const TextStyle(
      //               overflow: TextOverflow.ellipsis,
      //               color: const Color(0xff2f2f2f),
      //               fontWeight: FontWeight.w500,
      //               fontFamily: "NotoSansSC",
      //               fontStyle: FontStyle.normal,
      //               fontSize: 12.0),
      //         ))))
    ]);
  }
}

class MenuTabBar extends SliverPersistentHeaderDelegate {
  MenuTabBar({this.classViewController, this.tabBar});

  final ClassViewController classViewController;
  final TabBar tabBar;

  // @override
  // Size get preferredSize => Size(tabBar.preferredSize.width, 80.0);

  @override
  Widget build(
      BuildContext context, double shirinkOffset, bool overlapsContent) {
    return new Container(
      color: const Color(backgroundColor),
      height: 80.0,
      child: Container(
        margin: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 20.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: const Color(0xffffffff)),
        child: tabBar,
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 80.0;

  @override
  // TODO: implement minExtent
  double get minExtent => 80.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return false;
  }
}
