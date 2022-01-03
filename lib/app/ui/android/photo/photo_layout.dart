import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/ui/android/photo/see_photo.dart';

class PhotoLayout extends StatelessWidget {
  const PhotoLayout({
    Key key,
    @required this.model,
  }) : super(key: key);

  final model;

  @override
  Widget build(BuildContext context) {
    PhotoController pc = Get.put(PhotoController());
    final width = Get.mediaQuery.size.width - 34 * 2;

    print(width);
    print(Get.mediaQuery.size.width);
    print(MediaQuery.of(context).size);
    return Stack(children: [
      Container(
        width: width,
        height: width,
        margin: EdgeInsets.only(top: 10),
        child: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: model.PHOTO.length,
            onPageChanged: (value) {
              pc.index.value = value;
            },
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: CachedNetworkImage(
                    imageUrl: "${model.PHOTO[index]}",
                    placeholder: (context, url) => Container(
                          margin: EdgeInsets.only(right: 4.2),
                          width: width,
                          height: width,
                          color: Colors.black38,
                        ),
                    errorWidget: (context, url, error) {
                      return Icon(Icons.error);
                    },
                    imageBuilder: (context, imageProvider) => Ink(
                          child: InkWell(
                            onTap: () {
                              Get.to(
                                  () => SeePhoto(photo: model.PHOTO, index: 0));
                            },
                            child: Container(
                              // margin: EdgeInsets.only(right: 4.2),
                              width: width,
                              height: width,

                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover)),
                            ),
                          ),
                        )),
              );
            }),
      ),
      Positioned(
          right: 10,
          top: 20,
          child: // Rectangle 53
              Container(
                  width: width / 8.5,
                  height: width / 13,
                  child: // 1/5
                      Center(
                    child: Obx(() {
                      return Text("${pc.index.value + 1}/${model.PHOTO.length}",
                          style: const TextStyle(
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w600,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          textAlign: TextAlign.left);
                    }),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: const Color(0xff2f2f2f)))),
    ]);

    // ListView.builder(
    //     cacheExtent: 10,
    //     scrollDirection: Axis.horizontal,
    //     itemCount: model.PHOTO.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       return CachedNetworkImage(
    //           imageUrl: "${model.PHOTO[index]}",
    //           // progressIndicatorBuilder: (context, url, downloadProgress) =>
    //           //     Container(
    //           //       margin: EdgeInsets.only(right: 4.2),
    //           //       width: 110,
    //           //       height: 110,
    //           //       color: Colors.lightBlue[50],
    //           //       // child: Image(
    //           //       //     image: AssetImage(
    //           //       //         'assets/images/photo_placeholder.jpg')),
    //           //     ),
    //           placeholder: (context, url) => Container(
    //                 margin: EdgeInsets.only(right: 4.2),
    //                 width: 110,
    //                 height: 110,
    //                 color: Colors.black38,
    //                 // color: const Color(0xff194678),
    //               ),
    //           errorWidget: (context, url, error) {
    //             print(error);
    //             return Icon(Icons.error);
    //           },
    //           imageBuilder: (context, imageProvider) => Ink(
    //                 child: InkWell(
    //                   onTap: () {
    //                     print(index);
    //                     Get.to(
    //                         () => SeePhoto(photo: model.PHOTO, index: index));
    //                   },
    //                   child: Container(
    //                     margin: EdgeInsets.only(right: 4.2),
    //                     width: 110,
    //                     height: 110,
    //                     decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(10),
    //                         image: DecorationImage(
    //                             image: imageProvider, fit: BoxFit.cover)),
    //                   ),
    //                 ),
    //               ));
    //     }),
    // );
  }
}

class PhotoController extends GetxController {
  RxInt index = 0.obs;
}
