import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/ui/android/class/widgets/app_bars.dart';
import 'package:polarstar_flutter/main.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class SeePhoto extends StatefulWidget {
  SeePhoto({Key key, @required this.photo, @required this.index})
      : super(key: key);
  final List<dynamic> photo;
  int index;

  @override
  _SeePhotoState createState() => _SeePhotoState();
}

class _SeePhotoState extends State<SeePhoto> {
  bool appBarShow = true;
  @override
  Widget build(BuildContext context) {
    final PageController controller =
        PageController(initialPage: widget.index, viewportFraction: 1.0);

    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Stack(children: [
            Ink(
              child: InkWell(
                onTap: () {
                  setState(() {
                    appBarShow = !appBarShow;
                  });
                },
                child: PageView.builder(
                    itemCount: widget.photo.length,
                    controller: controller,
                    allowImplicitScrolling: true,
                    onPageChanged: (value) {
                      setState(() {
                        widget.index = value;
                      });
                    },
                    itemBuilder: (context, int index) {
                      return InteractiveViewer(
                        maxScale: 4,
                        minScale: 0.5,
                        // constrained: false,
                        // boundaryMargin: EdgeInsets.all(0),
                        child: Container(
                            width: size.width,
                            child: CachedNetworkImage(
                                imageUrl: "${widget.photo[index]}",
                                fit: BoxFit.fitWidth,
                                fadeInDuration: Duration(milliseconds: 0),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        Container(
                                          child: Image(
                                              image: AssetImage(
                                                  'assets/images/spinner.gif')),
                                        ),
                                errorWidget: (context, url, error) {
                                  return Icon(Icons.error);
                                },
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fitWidth)),
                                    ))),
                      );
                    }),
              ),
            ),
            Positioned(
              top: 0,
              child: AnimatedOpacity(
                opacity: appBarShow ? 1 : 0,
                duration: Duration(milliseconds: 100),
                child: Container(
                    height: 56,
                    width: Get.mediaQuery.size.width,
                    color: Get.theme.primaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: Ink(
                            child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Image.asset(
                                  "assets/images/848.png",
                                  color: Colors.white,
                                  width: 12,
                                  height: 24,
                                )),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: Ink(
                            child: InkWell(
                              onTap: () {},
                              child: Image.asset(
                                "assets/images/file_after_download.png",
                                height: 24,
                                width: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class SeePhotoDirect extends StatefulWidget {
  SeePhotoDirect({Key key, @required this.photo, @required this.index})
      : super(key: key);
  final Image photo;
  int index;

  @override
  _SeePhotoDirectState createState() => _SeePhotoDirectState();
}

class _SeePhotoDirectState extends State<SeePhotoDirect> {
  bool appBarShow = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller =
        PageController(initialPage: widget.index, viewportFraction: 1.0);

    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffffffff),
        body: Container(
          child: Stack(children: [
            Ink(
              child: InkWell(
                onTap: () {
                  setState(() {
                    appBarShow = !appBarShow;
                  });
                },
                child: PageView.builder(
                    itemCount: 1,
                    controller: controller,
                    allowImplicitScrolling: true,
                    onPageChanged: (value) {
                      setState(() {
                        widget.index = value;
                      });
                    },
                    itemBuilder: (context, int index) {
                      return InteractiveViewer(
                        maxScale: 4,
                        minScale: 0.5,

                        // constrained: false,
                        // boundaryMargin: EdgeInsets.all(0),
                        child:
                            Container(width: size.width, child: widget.photo),
                      );
                    }),
              ),
            ),
            Positioned(
              top: 0,
              child: AnimatedOpacity(
                opacity: appBarShow ? 1 : 0,
                duration: Duration(milliseconds: 100),
                child: Container(
                    height: 56,
                    width: Get.mediaQuery.size.width,
                    color: Get.theme.primaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: Ink(
                            child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Image.asset(
                                  "assets/images/848.png",
                                  color: Colors.white,
                                  width: 12,
                                  height: 24,
                                )),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: Ink(
                            child: InkWell(
                              onTap: () {},
                              child: Image.asset(
                                "assets/images/file_after_download.png",
                                height: 24,
                                width: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
