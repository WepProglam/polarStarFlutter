import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FindPw extends StatelessWidget {
  const FindPw({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          backgroundColor: Color(0xffffffff),
          elevation: 0,
          leadingWidth: 9.4 + 15 + 14.6,
          leading: Container(
            width: 9.4,
            height: 16.7,
            margin: EdgeInsets.only(left: 15, right: 14.6),
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Image.asset(
                "assets/images/978.png",
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          title: Text(
            'Find Password',
            style: const TextStyle(
                color: const Color(0xff333333),
                fontWeight: FontWeight.bold,
                fontFamily: "PingFangSC",
                fontStyle: FontStyle.normal,
                fontSize: 21.0),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 39),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // phon number
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: InkWell(
                  onTap: () {
                    // Get.toNamed("/signUp");
                  },
                  child: Ink(
                    width: Get.mediaQuery.size.width - 78,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Color(0xff1a4678),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xffffffff))),
                    child: Center(
                      child: Text(
                        "Find By Phone Number",
                        style: const TextStyle(
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.bold,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ),

              Text(
                "Or",
                style: const TextStyle(
                    color: const Color(0xff1a4678),
                    fontWeight: FontWeight.bold,
                    fontFamily: "PingFangSC",
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0),
              ),

              // phon number
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 50),
                child: InkWell(
                  onTap: () {
                    // Get.toNamed("/signUp");
                  },
                  child: Ink(
                    width: Get.mediaQuery.size.width - 78,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Color(0xffffffff),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xff1a4678))),
                    child: Center(
                      child: Text(
                        "Find Via Email",
                        style: const TextStyle(
                            color: const Color(0xff1a4678),
                            fontWeight: FontWeight.bold,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
