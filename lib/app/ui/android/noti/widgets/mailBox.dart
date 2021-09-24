import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/mail/mail_controller.dart';
import 'package:polarstar_flutter/app/controller/noti/noti_controller.dart';
import 'package:polarstar_flutter/app/data/model/mail/mailBox_model.dart';
import 'package:polarstar_flutter/app/ui/android/functions/time_pretty.dart';

class NotiMailBox extends StatelessWidget {
  const NotiMailBox({Key key, @required this.notiController}) : super(key: key);

  final NotiController notiController;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await notiController.getMailBox();
      },
      child: Obx(() {
        if (notiController.notiMailFetched.value) {
          return ListView.builder(
              itemCount: notiController.mailBox.length,
              itemBuilder: (BuildContext context, int index) {
                Rx<MailBoxModel> model = notiController.mailBox[index];
                return Ink(
                  child: InkWell(
                    onTap: () async {
                      Get.toNamed("/mail/${model.value.MAIL_BOX_ID}");
                    },
                    child: Container(
                      height: 56 + 10.0,
                      // margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      padding:
                          const EdgeInsets.only(top: 10, left: 15, right: 15),
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
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.black),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 16),
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
                                                  "${model.value.PROFILE_NICKNAME}",
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff333333),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily: "PingFangSC",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 15.0),
                                                  textAlign: TextAlign.left),
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
                                                          FontWeight.w400,
                                                      fontFamily: "PingFangSC",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 9.0),
                                                  textAlign: TextAlign.left),
                                            )
                                          ]),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 2.5, right: 37),
                                            child: Text(
                                                "${model.value.CONTENT}",
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff333333),
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "PingFangSC",
                                                    fontStyle: FontStyle.normal,
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
        } else {
          return Container(
            color: Colors.white,
          );
        }
      }),
    );
  }
}
