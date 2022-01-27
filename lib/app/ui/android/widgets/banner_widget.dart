import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/ui/android/main/widgets/outsidePreview.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BannerWidget extends StatelessWidget {
  BannerWidget({Key key, this.isScrollAble}) : super(key: key);

  bool isScrollAble;
  @override
  Widget build(BuildContext context) {
    if (isScrollAble == null) {
      isScrollAble = true;
    }
    final PageController outsidePageController = PageController();

    return Column(
      children: [
        InkWell(
          onTap: () {
            Get.to(SafeArea(
              child: WebView(
                initialUrl: 'https://flutter.dev',
                javascriptMode: JavascriptMode.unrestricted,
              ),
            ));
          },
          child: Container(
            height: 100,
            margin: const EdgeInsets.only(bottom: 12),
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              physics: PageScrollPhysics(),
              controller: outsidePageController,
              itemCount: isScrollAble ? 5 : 1,
              itemBuilder: (context, index) {
                return OutsidePreview();
              },
            ),
          ),
        ),
        isScrollAble
            ? Center(
                child: SmoothPageIndicator(
                  controller: outsidePageController,
                  count: 5,
                  effect: ExpandingDotsEffect(
                      dotWidth: 6,
                      dotHeight: 6,
                      expansionFactor: 2,
                      dotColor: const Color(0xffcecece),
                      activeDotColor: const Color(mainColor)),
                ),
              )
            : Container(),
      ],
    );
  }
}
