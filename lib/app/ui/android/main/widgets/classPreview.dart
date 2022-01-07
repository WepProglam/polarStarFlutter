import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/data/model/class/class_model.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:polarstar_flutter/app/ui/android/main/main_page_scroll.dart';

class ClassItem_Content extends StatelessWidget {
  const ClassItem_Content({
    Key key,
    @required this.mainController,
  }) : super(key: key);

  final MainController mainController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.symmetric(vertical: 23 - 13.5 / 2, horizontal: 15),
      child: Column(
        children: [
          Container(
            height: (52 + 13.5) * mainController.classList.length,
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: mainController.classList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: 52,
                      margin: const EdgeInsets.symmetric(vertical: 13.5 / 2),
                      child: ClassPreview_Main(
                          mainController: mainController,
                          model: mainController.classList[index],
                          index: index));
                }),
          )
        ],
      ),
    );
  }
}

class ClassItem_TOP extends StatelessWidget {
  const ClassItem_TOP({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        // height: 24,
        child: // 我选的课程
            Text("我选的课程",
                style: const TextStyle(
                    color: const Color(0xff2f2f2f),
                    fontWeight: FontWeight.w500,
                    fontFamily: "NotoSansSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0),
                textAlign: TextAlign.left),
      ),
      Spacer(),
      InkWell(
        child: SeeMore(),
        onTap: () {
          Get.toNamed("/class");
        },
      ),
    ]);
  }
}

class ClassPreview_Main extends StatelessWidget {
  const ClassPreview_Main(
      {Key key,
      @required this.model,
      @required this.index,
      @required this.mainController})
      : super(key: key);

  final ClassModel model;
  final int index;
  final MainController mainController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 사각형 565
        Container(
            width: 52,
            height: 52,
            child: Center(
              child: Container(
                width: 24,
                height: 24,
                child: Image.asset(mainController.classIconList[index % 10]),
              ),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: const Color(0xff1a4678)
                // color: mainController.classColorList[index % 10],
                )),
        Container(
          height: 47,
          margin: const EdgeInsets.only(left: 18, top: 2.5, bottom: 2.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 21.5,
                width: 150,
                child: Text("${model.CLASS_NAME}",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: const Color(0xff333333),
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                    textAlign: TextAlign.left),
              ),
              Container(
                margin: const EdgeInsets.only(top: 7),
                height: 18.5,
                child: Text("${model.PROFESSOR}",
                    style: const TextStyle(
                        color: const Color(0xff999999),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.left),
              )
            ],
          ),
        ),
        Spacer(),
        Container(
            padding: const EdgeInsets.fromLTRB(7.5, 4, 7, 5.5),
            child: Ink(
              child: InkWell(
                onTap: () {
                  Get.toNamed("/class/view/${model.CLASS_ID}");
                },
                child: Text("Evaluate",
                    style: const TextStyle(
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w700,
                        fontFamily: "PingFangSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0),
                    textAlign: TextAlign.center),
              ),
            ),
            margin: const EdgeInsets.only(top: 14.5, bottom: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(26)),
                color: const Color(0xff1a4678)))
      ],
    );
  }
}
