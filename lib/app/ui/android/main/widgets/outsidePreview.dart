import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const mainColor = 0xff4570ff;
const subColor = 0xff91bbff;
const whiteColor = 0xfff7fbff;
const textColor = 0xff2f2f2f;

class OutsidePreview extends StatelessWidget {
  const OutsidePreview({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 100,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("2022学年度第1学期已结业",
                    style: const TextStyle(
                        color: const Color(whiteColor),
                        fontWeight: FontWeight.w500,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.left),
                Text("业者替代论文学分取得制实行通",
                    style: const TextStyle(
                        color: const Color(subColor),
                        fontWeight: FontWeight.w400,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0),
                    textAlign: TextAlign.left)
              ],
            ),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 24.1),
                child: Image.asset("assets/images/371.png"),
              ))
        ],
      ),
      // child: Container(
      //   margin: const EdgeInsets.only(top: 6),
      //   child: Image.asset(
      //     // "assets/images/main_card_temp.png",
      //     "assets/images/main_card_expanded.png",
      //     fit: BoxFit.fitWidth,
      //   ),
      // ),
      // Center(
      //   child: Text(
      //     " T E S T ",
      //     style: TextStyle(
      //         color: Colors.white,
      //         fontSize: 20,
      //         fontWeight: FontWeight.normal),
      //   ),
      // ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
                color: const Color(0x33000000),
                offset: Offset(0, 3),
                blurRadius: 10,
                spreadRadius: 0)
          ],
          color: Get.theme.primaryColor),
    );
  }
}
