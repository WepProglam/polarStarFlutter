import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/board/board_controller.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/search/search_controller.dart';
import 'package:polarstar_flutter/app/ui/android/board/board.dart';
import 'package:polarstar_flutter/app/ui/android/board/widgets/board_layout.dart';
import 'package:polarstar_flutter/app/ui/android/search/widgets/search_bar.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/app_bar.dart';

class HotBoard extends StatelessWidget {
  HotBoard({Key key}) : super(key: key);
  final BoardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xffffffff),
              foregroundColor: Color(0xff333333),
              elevation: 0,
              automaticallyImplyLeading: false,
              leadingWidth: 15 + 13.1 + 9.4,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 13.1),
                  child: Ink(
                    child: Image.asset(
                      'assets/images/848.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              titleSpacing: 0,
              title: Container(
                height: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("핫보드",
                        style: const TextStyle(
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.bold,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
                        textAlign: TextAlign.left),
                    Text("Sungkyunkwan University",
                        style: const TextStyle(
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.normal,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 11.0),
                        textAlign: TextAlign.left),
                  ],
                ),
              ),
            ),
            body: Obx(() {
              if (controller.dataAvailablePostPreview.value) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await MainUpdateModule.updateHotMain();
                  },
                  child: ListView.builder(
                      controller: controller.scrollController.value,
                      itemCount: controller.postBody.length,
                      physics: AlwaysScrollableScrollPhysics(),
                      cacheExtent: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return PostPreview(
                          item: controller.postBody[index],
                        );
                      }),
                );
              } else if (controller.httpStatus == 404) {
                return Container(
                  color: Colors.white,
                );
              } else {
                return Container(
                  color: Colors.white,
                );
              }
            })));
  }
}
