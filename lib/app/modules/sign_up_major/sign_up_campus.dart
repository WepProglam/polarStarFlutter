import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:polarstar_flutter/app/modules/sign_up_major/widgets/campus_input.dart';
import 'package:polarstar_flutter/app/modules/sign_up_major/widgets/major_input.dart';
import 'package:polarstar_flutter/app/modules/sign_up_page/sign_up_controller.dart';
import 'package:polarstar_flutter/app/global_functions/form_validator.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path/path.dart' as p;

class SignUpCampus extends StatelessWidget {
  const SignUpCampus({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignUpController signUpController = Get.find();
    return Container(
      color: Colors.white,
      child: SafeArea(
          top: false,
          child: Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                  automaticallyImplyLeading: false,
                  titleSpacing: 0,
                  elevation: 0,
                  leading: InkWell(
                    child: Image.asset("assets/images/icn_back_white.png"),
                    onTap: () => Get.back(),
                  ),
                  centerTitle: true,
                  title: Text("注册会员",
                      style: const TextStyle(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                      textAlign: TextAlign.center)),
              body: CampusInputs(
                signUpController: signUpController,
              ))),
    );
  }
}
