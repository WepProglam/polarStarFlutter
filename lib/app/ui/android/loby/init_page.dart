import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:polarstar_flutter/app/ui/android/functions/form_validator.dart';

import 'package:polarstar_flutter/app/controller/loby/init_controller.dart';

class InitPage extends GetView<InitController> {
  InitPage({Key key}) : super(key: key);
  final InitController initController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Center(
              child: Container(
                  width: 281.2,
                  height: 232.4,
                  margin: EdgeInsets.fromLTRB(37.3, 35.1, 56.5, 122.5),
                  child: Image.asset("assets/images/636.png")),
            ),
            InkWell(
              onTap: () {
                Get.toNamed("/login");
              },
              child: Container(
                width: 305,
                height: 52,
                margin: EdgeInsets.symmetric(horizontal: 35),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xff1a4678))),
                child: Center(
                  child: Text(
                    "Log in",
                    style: const TextStyle(
                        color: const Color(0xff1a4678),
                        fontWeight: FontWeight.bold,
                        fontFamily: "PingFangSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 21.0),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed("/signUp");
              },
              child: Container(
                width: 305,
                height: 52,
                margin: EdgeInsets.fromLTRB(35, 39, 35, 121.5),
                decoration: BoxDecoration(
                    color: Color(0xff1a4678),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xff1a4678))),
                child: Center(
                  child: Text(
                    "Sign Up",
                    style: const TextStyle(
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.bold,
                        fontFamily: "PingFangSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 21.0),
                  ),
                ),
              ),
            ),
            Text(
              "Having trouble loggin in?",
              style: const TextStyle(
                  color: const Color(0xff333333),
                  fontWeight: FontWeight.bold,
                  fontFamily: "PingFangSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0),
            )
          ],
        ),
      ),
    );
  }
}
