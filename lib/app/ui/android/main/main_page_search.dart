import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/main/main_search_controller.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/board_layout.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/post_layout.dart';
import 'package:polarstar_flutter/app/ui/android/main/widgets/boardPreview.dart';
import 'package:polarstar_flutter/app/ui/android/main/widgets/classPreview.dart';
import 'package:polarstar_flutter/app/ui/android/main/widgets/hotBoardPreview.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/add_class.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/bottom_navigation_bar.dart';
import 'package:polarstar_flutter/session.dart';

class MainPageSearch extends StatelessWidget {
  final box = GetStorage();
  final MainController mainController = Get.find();
  final MainSearchController mc = Get.find();
  @override
  Widget build(BuildContext context) {
    final TextEditingController searchText =
        TextEditingController(text: mc.searchText.value);

    final Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
                    "全部搜索",
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

          // * 검색창
          // AppBar(
          //   elevation: 0,
          //   toolbarHeight: 56,
          //   automaticallyImplyLeading: false,
          //   titleSpacing: 0,
          //   title: Container(
          //     margin:
          //         const EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 20),
          //     child: Row(children: [
          //       Container(
          //           decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(Radius.circular(16)),
          //               color: const Color(0xffffffff)),
          //           width: Get.mediaQuery.size.width - 20 - 62,
          //           margin: const EdgeInsets.only(right: 14),
          //           height: 32,
          //           child: Row(children: [
          //             Ink(
          //               child: InkWell(
          //                 onTap: () async {
          //                   String text = searchText.text.trim();
          //                   mc.searchText(text);
          //                   await mc.clearAll();
          //                   await mc.searchApi();
          //                   FocusScope.of(context).unfocus();
          //                 },
          //                 child: Container(
          //                   padding: const EdgeInsets.symmetric(horizontal: 15),
          //                   child: Image.asset(
          //                     "assets/images/icn_search.png",
          //                     width: 20,
          //                     height: 20,
          //                     color: const Color(0xffcecece),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             Container(
          //               width: Get.mediaQuery.size.width - 20 - 62 - 30 - 20,
          //               child: MainSearchBar(
          //                   size: size, searchText: searchText, mc: mc),
          //             ),
          //           ])),
          //       Container(
          //         child: Ink(
          //           child: InkWell(
          //             onTap: () async {
          //               String text = searchText.text.trim();
          //               mc.searchText(text);
          //               await mc.clearAll();
          //               await mc.searchApi();
          //               FocusScope.of(context).unfocus();
          //             },
          //             child: Text("取消",
          //                 style: const TextStyle(
          //                     color: const Color(0xfff5f6ff),
          //                     fontWeight: FontWeight.w500,
          //                     fontFamily: "NotoSansSC",
          //                     fontStyle: FontStyle.normal,
          //                     fontSize: 14.0),
          //                 textAlign: TextAlign.left),
          //           ),
          //         ),
          //       ),
          //     ]),
          //   ),
          // ),
          // bottomNavigationBar:
          //     CustomBottomNavigationBar(mainController: mainController),
          body: Container(
            child: Stack(children: [
              Obx(() {
                if (!mc.dataAvailalbe) {
                  return Container(
                    height: size.height,
                    decoration: BoxDecoration(color: const Color(0xfff6f6f6)),
                    child: Container(
                      child: Center(
                        child: Text(
                          "Search Things",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  );
                }
                // ! 전체 검색일때 필요한 코드(게시판, 공모전, 장학금)
                // else if (mc.hasData[mc.searchType.value].value &&
                //     mc.didfetched[mc.searchType.value]) {
                //   return Container(
                //       height: size.height,
                //       decoration: BoxDecoration(color: const Color(0xfff6f6f6)),
                //       child: ListView.builder(
                //           controller: mc.scrollController.value,
                //           itemCount: mc.searchData[mc.searchType.value].length,
                //           itemBuilder: (BuildContext context, int index) {
                //             return Ink(
                //               child: InkWell(
                //                 onTap: () async {
                //                   await Get.toNamed(
                //                       "/board/${mc.searchData[mc.searchType.value][index].value.COMMUNITY_ID}/read/${mc.searchData[mc.searchType.value][index].value.BOARD_ID}",
                //                       arguments: {
                //                         "type": 0
                //                       }).then((value) async {
                //                     await mc.searchApi();
                //                   });
                //                 },
                //                 child: PostWidget(
                //                   c: null,
                //                   mailWriteController: null,
                //                   mailController: null,
                //                   item: mc.searchData[mc.searchType.value]
                //                       [index],
                //                   index: index,
                //                   mainController: mainController,
                //                 ),
                //               ),
                //             );

                //             // PostPreview(
                //             //   item: mc.searchData[mc.searchType.value][index],
                //             // );
                //           }));
                // }
                else {
                  return Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(color: const Color(0xffffffff)),
                      child: ListView.builder(
                          controller: mc.scrollController.value,
                          shrinkWrap: true,
                          itemCount: mc.searchData[mc.searchType.value].length,
                          itemBuilder: (BuildContext context, int index) {
                            print(mc.searchData[mc.searchType.value].length);
                            if (mc.searchData[mc.searchType.value].length ==
                                0) {
                              return Container(
                                height: size.height,
                                decoration: BoxDecoration(
                                    color: const Color(0xfff6f6f6)),
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      "No result",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Ink(
                                child: InkWell(
                                  onTap: () async {
                                    await Get.toNamed(
                                        "/board/${mc.searchData[mc.searchType.value][index].value.COMMUNITY_ID}/read/${mc.searchData[mc.searchType.value][index].value.BOARD_ID}",
                                        arguments: {
                                          "type": 0
                                        }).then((value) async {
                                      await mc.searchApi();
                                    });
                                  },
                                  child: PostWidget(
                                    item: mc.searchData[mc.searchType.value]
                                        [index],
                                    index: index,
                                    mainController: mainController,
                                  ),
                                ),
                              );
                            }

                            // PostPreview(
                            //   item: mc.searchData[mc.searchType.value][index],
                            // );
                          }));
                }
              }),
              // ! 전체 검색일때 필요한 코드(게시판, 공모전, 장학금)
              // Positioned(
              //     top: 0,
              //     right: 15,
              //     child: Container(
              //         height: 30,
              //         child: Obx(() {
              //           int selectedType = mc.searchType.value;
              //           List<bool> _isSelected = [false, false, false];
              //           _isSelected[selectedType] = true;
              //           return ToggleButtons(
              //               children: <Widget>[
              //                 Container(
              //                     margin: const EdgeInsets.symmetric(
              //                         horizontal: 10),
              //                     child: FittedBox(child: Text("커뮤니티"))),
              //                 Container(
              //                     margin: const EdgeInsets.symmetric(
              //                         horizontal: 10),
              //                     child: FittedBox(child: Text("장학금"))),
              //                 Container(
              //                     margin: const EdgeInsets.symmetric(
              //                         horizontal: 10),
              //                     child: FittedBox(child: Text("공모전"))),
              //               ],
              //               selectedBorderColor: Colors.blue,
              //               borderRadius: BorderRadius.circular(20),
              //               onPressed: (int index) {
              //                 if (index >= 0 && index <= 2) {
              //                   mc.searchType(index);
              //                 } else {
              //                   Get.snackbar("잘못된 타입입니다.", "잘못된 타입입니다.");
              //                 }
              //               },
              //               isSelected: _isSelected);
              //         })))
            ]),
          ),
        ),
      ),
    );
  }
}

class MainSearchBar extends StatelessWidget {
  const MainSearchBar(
      {Key key,
      @required this.size,
      @required this.searchText,
      @required this.mc})
      : super(key: key);

  final Size size;
  final TextEditingController searchText;
  final MainSearchController mc;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: searchText,
      onEditingComplete: () async {
        String text = searchText.text.trim();
        mc.searchText(text);
        await mc.clearAll();
        await mc.searchApi();
        FocusScope.of(context).unfocus();
      },
      autofocus: false,
      minLines: 1,
      maxLines: 1,
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        isDense: true,
        hintText: "新建立 韩国大学联合交流区",
        hintStyle: const TextStyle(
            color: const Color(0xffcecece),
            fontWeight: FontWeight.w500,
            fontFamily: "NotoSansSC",
            fontStyle: FontStyle.normal,
            fontSize: 14.0),
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
      ),
      style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontFamily: "NotoSansSC",
          fontStyle: FontStyle.normal,
          fontSize: 14.0),
    );
  }
}
