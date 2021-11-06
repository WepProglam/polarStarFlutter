import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OutsidePreview extends StatelessWidget {
  const OutsidePreview({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return

        // Container(
        //     width: Get.size.width - 30,
        //     height: 150,
        //     child: Image.asset("assets/images/main_card_temp.png"));
        // Todo: container위에 사진 포개기(포개면 자꾸 사진이 작게 나옴)
        Container(
            width: Get.mediaQuery.size.width - 30,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            height: 182.5,
            child: Container(
              margin: const EdgeInsets.only(top: 6),
              child: Image.asset(
                // "assets/images/main_card_temp.png",
                "assets/images/main_card_expanded.png",
                fit: BoxFit.fitWidth,
              ),
            ),
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
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xff426690),
                      offset: Offset(0, 9),
                      blurRadius: 0,
                      spreadRadius: 0)
                ],
                color: const Color(0xff1a4678)));
  }
}
