import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/ui/android/main/widgets/main_page_board.dart';

class MainPageScroll extends StatelessWidget {
  final box = GetStorage();
  final MainController mainController = Get.find();
  final TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final deviceWidth = size.width;

    return Obx(() {
      if (!mainController.dataAvailalbe) {
        return CircularProgressIndicator();
      } else {
        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                // 검색창
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 8,
                        child: TextFormField(
                          controller: searchText,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Search',
                              isDense: true,
                              contentPadding: EdgeInsets.all(8)),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Container(
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                Map arg = {
                                  'search': searchText.text,
                                };

                                Get.toNamed('/board/searchAll/page/1',
                                    arguments: arg);
                              },
                              icon: Icon(Icons.search_outlined),
                              iconSize: 20,
                            ),
                          )),
                    ],
                  ),
                ),

                // 취업정보
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: PageScrollPhysics(), // 하나씩 스크롤 되게 해줌
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          child: Container(
                            width: deviceWidth - 16,
                            color: Colors.amber[600],
                            child: Center(
                              child: Text("취업 정보$index"),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // 빌보드(핫게)
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Container(
                                  child: Text(
                                '핫보드',
                              )),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                Get.toNamed("/board/hot/page/1");
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Container(
                                    child: Text(
                                  '더 보기',
                                  style: TextStyle(color: Colors.redAccent),
                                )),
                              ),
                            ),
                          ],
                        ),
                        for (var item in mainController.hotBoard)
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              child: billboardContent(item),
                              width: deviceWidth,
                              height: 50,
                              decoration: BoxDecoration(color: Colors.orange),
                            ),
                          ),
                      ],
                    ))),

                // 게시판
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      children: [
                        Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '게시판',
                              ),
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Get.toNamed("board/boardList");
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '더 보기',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          )
                        ]),
                        Container(child: boards(mainController.boardInfo))
                      ],
                    ),
                  ),
                ),

                //시간표 & 강의평가
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '시간표/강의평가',
                          ),
                        ),
                      ),
                      Container(
                        width: deviceWidth - 16,
                        height: 200,
                        margin: EdgeInsets.only(top: 2, bottom: 2),
                        decoration: BoxDecoration(border: Border.all()),
                        child: null,
                      ),
                    ],
                  ),
                ),

                // 유니티
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '유니티',
                          ),
                        ),
                      ),
                      Container(
                        width: deviceWidth - 16,
                        height: 200,
                        margin: EdgeInsets.only(top: 2, bottom: 2),
                        decoration: BoxDecoration(border: Border.all()),
                        child: null,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    });
  }
}
