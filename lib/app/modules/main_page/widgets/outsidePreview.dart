import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/modules/main_page/main_controller.dart';
import 'package:polarstar_flutter/app/modules/claa_view/widgets/app_bars.dart';
import 'package:webview_flutter/webview_flutter.dart';

const mainColor = 0xff4570ff;
const subColor = 0xff91bbff;
const whiteColor = 0xfff7fbff;
const textColor = 0xff2f2f2f;

class OutsidePreview extends StatelessWidget {
  OutsidePreview({Key key, @required this.index, @required this.mainController})
      : super(key: key);
  final int index;
  final MainController mainController;
  @override
  Widget build(BuildContext context) {
    print(mainController.bannerList[index].IMAGE);
    return InkWell(
        onTap: () {
          mainController.bannerList[index].URL == null ||
                  mainController.bannerList[index].URL.trim().isEmpty
              ? print("null link")
              : Get.to(Container(
                  color: Colors.white,
                  child: SafeArea(
                    top: false,
                    child: Scaffold(
                      appBar: AppBars().WebViewAppBar(),
                      body: WebView(
                        initialUrl: mainController.bannerList[index].URL,
                        javascriptMode: JavascriptMode.unrestricted,
                      ),
                    ),
                  ),
                ));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: 124,
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 35),
                        constraints: BoxConstraints(
                            maxWidth:
                                Get.mediaQuery.size.width - 34 * 2 - 133.5),
                        child: Text(mainController.bannerList[index].TITLE,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: const Color(whiteColor),
                                fontWeight: FontWeight.w500,
                                fontFamily: "NotoSansSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                            textAlign: TextAlign.left)),
                    Container(
                        margin: const EdgeInsets.only(top: 2),
                        constraints: BoxConstraints(
                            maxWidth:
                                Get.mediaQuery.size.width - 34 * 2 - 133.5),
                        child: Text(mainController.bannerList[index].CONTENT,
                            maxLines: 2,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: const Color(subColor),
                                fontWeight: FontWeight.w400,
                                fontFamily: "NotoSansSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            textAlign: TextAlign.left))
                  ],
                ),
              ),
              Positioned(
                right: 12,
                bottom: 0,
                child: mainController.bannerList[index].IMAGE == null
                    ? Image.asset(
                        "assets/images/banner_panda_hello.png",
                        // width: 133.5,
                        // height: 109.5,
                        // height: 121,
                        // fit: BoxFit.fitHeight,
                      )
                    : CachedNetworkImage(
                        height: 115,
                        fit: BoxFit.fitHeight,
                        imageUrl: mainController.bannerList[index].IMAGE),
              )
              // Align(
              //     alignment: Alignment.bottomRight,
              //     child: Padding(
              //       padding: const EdgeInsets.only(right: 0),
              //       child: Image.asset(
              //         "assets/images/banner_panda_hello.png",
              //         width: 133,
              //         height: 109,
              //         fit: BoxFit.fitHeight,
              //       ),

              //     Image.asset(
              //   "assets/images/panda.png",
              //   fit: BoxFit.cover,
              // ),
              // ))
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
        ));
  }
}