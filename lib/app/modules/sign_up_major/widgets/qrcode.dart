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

class QRCODE extends StatefulWidget {
  @override
  State<QRCODE> createState() => _QRCODE();
}

class _QRCODE extends State<QRCODE> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
          top: false,
          child: Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                elevation: 0,
                leading: InkWell(
                  child: Image.asset("assets/images/icn_back_white.png"),
                  onTap: () => Get.back(),
                ),
                centerTitle: true,
                title: Text("",
                    style: const TextStyle(
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w500,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                    textAlign: TextAlign.center)),
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: SafeArea(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                      child: Text("WeChat ID: bb17024395",
                          style: const TextStyle(
                              color: const Color(0xff6f6e6e),
                              fontWeight: FontWeight.w500,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          textAlign: TextAlign.center)),
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      child: CupertinoButton(
                        color: const Color(0xff6f6e6e),
                        child: Text("COPY",
                            style: const TextStyle(
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w500,
                                fontFamily: "NotoSansSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 13.0),
                            textAlign: TextAlign.center),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: "bb17024395"));
                        },
                      )),
                ]),
                Container(
                  height: 300,
                  width: 300,
                  child: CachedNetworkImage(
                      imageUrl:
                          'https://polarstar-image.s3.ap-northeast-2.amazonaws.com/qr.png',
                      fadeInDuration: Duration(milliseconds: 0),
                      progressIndicatorBuilder: (context, url,
                              downloadProgress) =>
                          Image(image: AssetImage('assets/images/spinner.gif')),
                      errorWidget: (context, url, error) {
                        print(error);
                        return Icon(Icons.error);
                      }),
                ),
                Container(
                    child: CupertinoButton(
                  color: const Color(0xff6f6e6e),
                  child: Text("  DOWNLOAD QR     ",
                      style: const TextStyle(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 13.0),
                      textAlign: TextAlign.center),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.center,
                  onPressed: () async {
                    final status = await Permission.storage.request();

                    if (status.isGranted) {
                      String dirloc = "";
                      if (Platform.isAndroid) {
                        dirloc = "/sdcard/download/";
                      } else {
                        dirloc = (await getApplicationDocumentsDirectory())
                            .absolute
                            .path;
                      }

                      if (!Directory(dirloc).existsSync()) {
                        dirloc = (await getApplicationDocumentsDirectory())
                            .absolute
                            .path;
                        if (!Directory(dirloc).existsSync()) {
                          Directory(dirloc).create(recursive: true);
                        }
                      }

                      String file_name = "qrcode.png";
                      // * 파일 이름 중복
                      if (File(p.join(dirloc, file_name)).existsSync()) {
                        int i = 1;
                        int string_length = file_name.length;
                        String a = "aa.aa";
                        a.lastIndexOf(".");
                        int extend_length =
                            file_name.split(".").last.length + 1;
                        int add_number_index =
                            string_length - extend_length - 1;
                        // String dupliacte_file_name = file_name
                        while (File(p.join(
                                dirloc,
                                file_name.substring(
                                        0, file_name.lastIndexOf(".")) +
                                    "(${i})." +
                                    file_name.split(".").last))
                            .existsSync()) {
                          i += 1;
                        }

                        file_name =
                            file_name.substring(0, file_name.lastIndexOf(".")) +
                                "(${i})." +
                                file_name.split(".").last;
                      }

                      // print(dirloc);
                      // print("==============================");

                      final String taskID = await FlutterDownloader.enqueue(
                          url:
                              "https://polarstar-image.s3.ap-northeast-2.amazonaws.com/qr.png",
                          savedDir: dirloc,
                          fileName: file_name,
                          showNotification: true,
                          openFileFromNotification: true,
                          saveInPublicStorage: true);

                      print("downloaded!!");
                    } else {
                      print('Permission Denied');
                    }
                  },
                ))
              ],
            )),
          )),
    );
  }
}
