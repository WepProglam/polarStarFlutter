import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/mail/mail_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MailHistory extends StatelessWidget {
  final MailController mailController = Get.find();
  final commentWriteController = TextEditingController();
  //스크롤 초기 설정 필요함
  ScrollController controller =
      new ScrollController(initialScrollOffset: 10000);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            leading: InkWell(
              child: Icon(Icons.arrow_back_ios_new, color: Colors.black),
              onTap: () {
                Get.back();
              },
            ),
            leadingWidth: 35,
            titleSpacing: 0,
            title: Text(
                "${mailController.opponentProfile.value.PROFILE_NICKNAME}",
                style: const TextStyle(
                    color: const Color(0xff333333),
                    fontWeight: FontWeight.w700,
                    fontFamily: "PingFangSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 21.0),
                textAlign: TextAlign.left),
          ),
          body: RefreshIndicator(
            onRefresh: mailController.getMail,
            child: Stack(
              children: [
                ListView(),
                Obx(() {
                  if (mailController.dataAvailableMailSendPage) {
                    //data가 available한 상태인지 확인
                    return Container(
                      child: ListView.builder(
                        controller: controller,
                        itemCount: mailController.mailHistory.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 10, bottom: 97),
                        itemBuilder: (context, index) {
                          if (index == mailController.mailHistory.length - 1) {
                            print((mailController.mailHistory[index].FROM_ME));
                          }
                          return Container(
                              padding: (mailController.mailHistory[index].FROM_ME == 0
                                  ? EdgeInsets.only(left: 15, bottom: 33.5)
                                  : EdgeInsets.only(right: 15, bottom: 26.5)),
                              child: Align(
                                  alignment:
                                      (mailController.mailHistory[index].FROM_ME == 0
                                          ? Alignment.topLeft
                                          : Alignment.topRight),
                                  child: (mailController
                                              .mailHistory[index].FROM_ME ==
                                          0
                                      ? Row(children: [
                                          Container(
                                              width: 41.5,
                                              height: 41.5,
                                              margin:
                                                  EdgeInsets.only(right: 14),
                                              child: CachedNetworkImage(
                                                  imageUrl:
                                                      'http://ec2-3-37-156-121.ap-northeast-2.compute.amazonaws.com:3000/uploads/${mailController.opponentProfile.value.PROFILE_PHOTO}',
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image: DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .fill))),
                                                  fadeInDuration:
                                                      Duration(milliseconds: 0),
                                                  progressIndicatorBuilder: (context,
                                                          url,
                                                          downloadProgress) =>
                                                      Image(
                                                          image: AssetImage(
                                                              'assets/images/spinner.gif')),
                                                  errorWidget:
                                                      (context, url, error) {
                                                    print(error);
                                                    return Icon(Icons.error);
                                                  })),
                                          Container(
                                              constraints:
                                                  BoxConstraints(maxWidth: 260),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(36),
                                                      topRight:
                                                          Radius.circular(36),
                                                      bottomRight:
                                                          Radius.circular(36)),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xffdcdcdc),
                                                      width: 1),
                                                  color:
                                                      const Color(0xfff2f2f2)),
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 11.5,
                                                      top: 13,
                                                      right: 13,
                                                      bottom: 16),
                                                  child: Text(
                                                      "${mailController.mailHistory[index].CONTENT}",
                                                      style: const TextStyle(
                                                          color:
                                                              const Color(0xff333333),
                                                          fontWeight: FontWeight.w700,
                                                          fontFamily: "PingFangSC",
                                                          fontStyle: FontStyle.normal,
                                                          fontSize: 16.0),
                                                      textAlign: TextAlign.left)))
                                        ])
                                      : Container(
                                          constraints:
                                              BoxConstraints(maxWidth: 260),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(36),
                                                  topRight: Radius.circular(36),
                                                  bottomLeft:
                                                      Radius.circular(36)),
                                              border: Border.all(
                                                  color:
                                                      const Color(0xffdcdcdc),
                                                  width: 1),
                                              color: const Color(0xff1a4678)),
                                          child: Container(
                                              margin: EdgeInsets.only(left: 11.5, top: 13, right: 13, bottom: 16),
                                              child: Text("${mailController.mailHistory[index].CONTENT}", style: const TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w700, fontFamily: "PingFangSC", fontStyle: FontStyle.normal, fontSize: 16.0), textAlign: TextAlign.left))))));
                        },
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                })
              ],
            ),
          ),
          //입력창
          bottomSheet: Container(
              height: 117,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: const Color(0xffffffff)),
              child:
                  //키보드
                  Column(children: [
                Container(
                    margin: EdgeInsets.only(top: 10, bottom: 55),
                    width: MediaQuery.of(context).size.width - 30,
                    height: 52,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(52)),
                        border: Border.all(
                            color: const Color(0xffd4d4d4), width: 1),
                        color: const Color(0x05333333)),
                    child: Row(children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: 18.5,
                          right: 18.5,
                        ),
                        width: MediaQuery.of(context).size.width -
                            30 -
                            37 -
                            38 -
                            15,
                        child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: commentWriteController,
                            style: const TextStyle(
                                color: const Color(0xff333333),
                                fontWeight: FontWeight.w500,
                                fontFamily: "PingFangSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0),
                            onFieldSubmitted: (value) {
                              mailController.sendMailIn(
                                  commentWriteController.text, controller);
                            },
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: "Please enter content",
                              border: InputBorder.none,
                            )),
                      ),
                      InkWell(
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                                color: const Color(0xff1a4678),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage('assets/images/869.png'),
                                    scale: 1.8)),
                          ),
                          onTap: () {
                            mailController.sendMailIn(
                                commentWriteController.text, controller);

                            commentWriteController.clear();
                          }),
                    ]))
              ]))),
    );
  }
}
