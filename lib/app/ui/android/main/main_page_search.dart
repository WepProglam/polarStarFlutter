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
      height: size.height,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color(0xfff6f6f6),
          elevation: 0,
          toolbarHeight: 37 + 13.0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Container(
            margin:
                const EdgeInsets.only(left: 15, right: 15, top: 7, bottom: 5),
            width: size.width - 15 * 2,
            height: 32,
            child: MainSearchBar(size: size, searchText: searchText, mc: mc),
          ),
        ),
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
                    height: size.height,
                    decoration: BoxDecoration(color: const Color(0xfff6f6f6)),
                    child: ListView.builder(
                        controller: mc.scrollController.value,
                        itemCount: mc.searchData[mc.searchType.value].length,
                        itemBuilder: (BuildContext context, int index) {
                          print(mc.searchData[mc.searchType.value].length);
                          if (mc.searchData[mc.searchType.value].length == 0) {
                            return Container(
                              height: size.height,
                              decoration:
                                  BoxDecoration(color: const Color(0xfff6f6f6)),
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
                                  c: null,
                                  mailWriteController: null,
                                  mailController: null,
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
    return Container(
        // width: size.width - 38.5 - 15 - 20 - 19.4 - 15,
        // margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 20,
            ),
            Expanded(
              child: TextFormField(
                controller: searchText,
                onEditingComplete: () async {
                  String text = searchText.text.trim();
                  mc.searchText(text);
                  await mc.clearAll();
                  await mc.searchApi();
                  FocusScope.of(context).unfocus();
                },
                maxLines: 1,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: "PingFangSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: ""),
              ),
            ),
            // Spacer(),
            // 패스 894
            Container(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 19.4, 7.7),
              child: Container(
                  width: 14.2841796875,
                  height: 14.29736328125,
                  child: InkWell(
                    onTap: () async {
                      String text = searchText.text.trim();
                      mc.searchText(text);
                      await mc.clearAll();
                      await mc.searchApi();
                      FocusScope.of(context).unfocus();
                    },
                    child: Image.asset(
                      "assets/images/894.png",
                      fit: BoxFit.fitHeight,
                    ),
                  )),
            )
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: const Color(0xffeeeeee)));
  }
}
