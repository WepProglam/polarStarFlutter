import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OutsidePreview extends StatelessWidget {
  const OutsidePreview({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Get.size.width - 30,
        height: 150,
        child: Image.asset("assets/images/main_card_temp.png"));
    // Container(
    //     margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
    //     width: Get.mediaQuery.size.width - 30,
    //     height: 148.5,
    //     decoration: BoxDecoration(
    //         borderRadius: BorderRadius.all(Radius.circular(20)),
    //         boxShadow: [
    //           BoxShadow(
    //               color: const Color(0xff426690),
    //               offset: Offset(0, 0),
    //               blurRadius: 20,
    //               spreadRadius: 0)
    //         ],
    //         color: const Color(0xff1a4678)));
  }
}
