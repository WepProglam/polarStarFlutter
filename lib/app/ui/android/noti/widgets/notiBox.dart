import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/noti/noti_controller.dart';
import 'package:polarstar_flutter/app/data/model/noti/noti_model.dart';
import 'package:polarstar_flutter/app/ui/android/functions/board_name.dart';
import 'package:polarstar_flutter/app/ui/android/functions/time_pretty.dart';

class NotiNotiBox extends StatelessWidget {
  const NotiNotiBox({
    Key key,
    @required this.notiController,
  }) : super(key: key);

  final NotiController notiController;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await notiController.getNoties();
      },
      child: Obx(() {
        if (notiController.notiNotiFetched.value) {
          if (notiController.noties.length == 0) {
            return Stack(children: [
              ListView(),
              Center(
                child: Text(
                  "아직 알림이 없습니다.",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ]);
          } else {
            return ListView.builder(
                itemCount: notiController.noties.length,
                itemBuilder: (BuildContext context, int index) {
                  Rx<NotiModel> model = notiController.noties[index];
                  return Obx(() {
                    return Ink(
                      child: InkWell(
                        onTap: () async {
                          if (model.value.NOTI_TYPE == 0) {
                            String COMMUNITY_ID = model.value.URL.split("/")[1];
                            String BOARD_ID = model.value.URL.split("/")[3];
                            Get.toNamed(
                                "/board/${COMMUNITY_ID}/read/${BOARD_ID}");
                          } else {
                            Get.toNamed("/board/32/read/20");
                          }
                          if (!model.value.isReaded) {
                            model.update((val) {
                              val.isReaded = true;
                            });
                            notiController.setReadNotied(
                                SaveNotiModel.fromJson({
                              "NOTI_ID": model.value.NOTI_ID,
                              "LOOKUP_DATE": "${DateTime.now()}"
                            }));
                          }
                        },
                        child: Container(
                          height: 56 + 10.0,
                          padding: const EdgeInsets.only(
                              top: 10, left: 15, right: 15),
                          // margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          color: model.value.isReaded
                              ? Color(0xfff6f6f6)
                              : Colors.lightBlue[50],
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                    height: 46,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 46,
                                          width: 46,
                                          child: Image.asset(
                                              "assets/images/temp_pencil.png"),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 16),
                                          height: 46,
                                          width: Get.mediaQuery.size.width -
                                              16 -
                                              46 -
                                              30,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 1.5),
                                                  child: Text(
                                                      //게시판일 경우
                                                      model.value.NOTI_TYPE == 0
                                                          ? "${communityBoardName(int.parse(model.value.TITLE))}"
                                                          : "${model.value.TITLE}",
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff333333),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily:
                                                              "PingFangSC",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 15.0),
                                                      textAlign:
                                                          TextAlign.left),
                                                ),
                                                Spacer(),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 2, right: 0.5),
                                                  child: Text(
                                                      "${prettyDate(model.value.TIME_CREATED)}",
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff333333),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily:
                                                              "PingFangSC",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 9.0),
                                                      textAlign:
                                                          TextAlign.left),
                                                )
                                              ]),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 2.5, right: 37),
                                                child: Text(
                                                    "${model.value.CONTENT}",
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        color: const Color(
                                                            0xff333333),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily:
                                                            "PingFangSC",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 13.0),
                                                    textAlign: TextAlign.left),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                                Spacer(),
                                Container(
                                    height: 0.5,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffdedede)))
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                });
          }
        } else {
          return Container(
            color: Colors.white,
          );
        }
      }),
    );
  }
}