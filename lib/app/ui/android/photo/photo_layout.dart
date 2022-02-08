import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/board/post_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/ui/android/photo/see_photo.dart';
import 'package:video_player/video_player.dart';

class PhotoLayout extends StatefulWidget {
  const PhotoLayout({Key key, @required this.model, this.c}) : super(key: key);
  final model;
  final PostController c;
  @override
  State<PhotoLayout> createState() => _PhotoLayoutState(model: model);
}

class _PhotoLayoutState extends State<PhotoLayout> {
  _PhotoLayoutState({
    @required this.model,
  });
  final Post model;
  int photo_index = 0;

  @override
  void initState() {
    super.initState();
    photo_index = 0;
  }

  @override
  Widget build(BuildContext context) {
    // PhotoController pc = Get.put(PhotoController());
    final width = Get.mediaQuery.size.width - 34 * 2;
    print(widget.c == null);
    return Stack(children: [
      Container(
        width: width,
        height: width * 0.8,
        margin: EdgeInsets.only(top: 10),
        child: PageView.builder(
            scrollDirection: Axis.horizontal,
            physics: widget.c == null
                ? NeverScrollableScrollPhysics()
                : AlwaysScrollableScrollPhysics(),
            itemCount: model.MEDIA.length,
            allowImplicitScrolling: true,
            onPageChanged: (value) {
              setState(() {
                photo_index = value;
              });
              // pc.index.value = value;
            },
            itemBuilder: (BuildContext context, int index) {
              if (widget.c == null) {
                return model.MEDIA[index].PHOTO;
              }
              // if (model.MEDIA[index].isVideo) {
              //   return Container(
              //       child: InkWell(
              //           onTap: widget.c != null
              //               ? () {
              //                   setState(() {
              //                     if (!model
              //                         .MEDIA[index].VIDEO.value.isPlaying) {
              //                       model.MEDIA[index].VIDEO.play();
              //                     } else {
              //                       model.MEDIA[index].VIDEO.pause();
              //                     }
              //                   });
              //                 }
              //               : null,
              //           child:
              //               Ink(child: VideoPlayer(model.MEDIA[index].VIDEO))));
              // } else {
              return model.MEDIA[index].isVideo
                  ? Ink(
                      child: InkWell(
                          onTap: () {
                            Get.to(
                                () =>
                                    SeeMedia(media: model.MEDIA, index: index),
                                transition: Transition.cupertino);
                          },
                          child: FittedBox(
                              fit: BoxFit.contain,
                              // aspectRatio:
                              //     model.MEDIA[index].VIDEO.value.aspectRatio,
                              child: Container(
                                  width: width,
                                  height: width * 0.8,
                                  child:
                                      VideoPlayer(model.MEDIA[index].VIDEO)))))
                  : Ink(
                      child: InkWell(
                          onTap: () {}, child: model.MEDIA[index].PHOTO));
              // }
              // CachedNetworkImage(
              //     imageUrl: "${model.PHOTO[index]}",
              //     // ! fade in 별로라서 뺌
              //     // placeholder: (context, url) => Container(
              //     //       width: width,
              //     //       height: width,
              //     //       color: Colors.white,
              //     //     ),
              //     errorWidget: (context, url, error) {
              //       return Icon(Icons.error);
              //     },
              //     imageBuilder: (context, imageProvider) => Ink(
              //           child: InkWell(
              //             onTap: widget.c == null
              //                 ? null
              //                 : () {
              //                     Get.to(
              //                         () => SeePhoto(
              //                             photo: model.PHOTO, index: index),
              //                         transition: Transition.cupertino);
              //                   },
              //             child: Container(
              //               // margin: EdgeInsets.only(right: 4.2),
              //               width: width,
              //               height: width * 0.8,

              //               decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(10),
              //                   image: DecorationImage(
              //                       image: imageProvider, fit: BoxFit.cover)),
              //             ),
              //           ),
              //         )),
            }),
      ),
      Positioned(
          right: 10,
          top: 20,
          child: // Rectangle 53
              Container(
                  // width: width / 8.5,
                  width: 39,
                  height: 19,
                  // height: width / 13,
                  child: // 1/5
                      Center(
                    child: Text("${photo_index + 1}/${model.MEDIA.length}",
                        style: const TextStyle(
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0),
                        textAlign: TextAlign.left),
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

// class PhotoController extends GetxController {
//   RxInt index = 0.obs;
// }
