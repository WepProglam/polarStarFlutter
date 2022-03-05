import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/modules/main_page/main_controller.dart';
import 'package:polarstar_flutter/app/modules/main_page/widgets/outsidePreview.dart';
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
    final MainController mainController = Get.find();
    return Column(
      children: [
        Container(
          height: 124,
          margin: const EdgeInsets.only(bottom: 12),
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            physics: PageScrollPhysics(),
            controller: outsidePageController,
            itemCount: isScrollAble ? mainController.bannerList.length : 1,
            itemBuilder: (context, index) {
              return OutsidePreview(
                  index: index, mainController: mainController);
            },
          ),
        ),
        isScrollAble
            ? Center(
                child: SmoothPageIndicator(
                  controller: outsidePageController,
                  count: mainController.bannerList.length,
                  effect: ExpandingDotsEffect(
                      dotWidth: 6,
                      dotHeight: 6,
                      expansionFactor: 2,
                      dotColor: const Color(0xffcecece),
                      activeDotColor: Get.theme.primaryColor),
                ),
              )
            : Container(),
      ],
    );
  }
}
