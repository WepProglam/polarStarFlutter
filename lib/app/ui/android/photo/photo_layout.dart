import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/board/post_controller.dart';
import 'package:polarstar_flutter/app/controller/photo/photo_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/ui/android/photo/see_photo.dart';
import 'package:video_player/video_player.dart';

class PhotoLayout extends StatelessWidget {
  PhotoLayout({Key key, @required this.model, this.c}) : super(key: key);
  Post model;
  final PostController c;
  final PhotoController pc = Get.put(PhotoController());

  @override
  Widget build(BuildContext context) {
    print("photo");
    print("${model.TITLE} | ${model.PHOTO_URL}");
    // PhotoController pc = Get.put(PhotoController());
    final width = Get.mediaQuery.size.width - 34 * 2;
    print(c == null);
    return Stack(children: [
      Container(
        width: width,
        height: width * 0.8,
        margin: EdgeInsets.only(top: 10),
        child: PageView.builder(
            scrollDirection: Axis.horizontal,
            physics: c == null
                ? NeverScrollableScrollPhysics()
                : AlwaysScrollableScrollPhysics(),
            itemCount: model.MEDIA.length,
            allowImplicitScrolling: true,
            onPageChanged: (value) {
              pc.photo_index.value = value;
              // setState(() {
              //   photo_index = value;
              // });
              // pc.index.value = value;
            },
            itemBuilder: (BuildContext context, int index) {
              if (c == null) {
                // return Image.network(
                //   model.PHOTO_URL[0],
                //   fit: BoxFit.cover,
                // );
                return model.MEDIA[0].PHOTO;
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
                          onTap: () {
                            Get.to(
                                () =>
                                    SeeMedia(media: model.MEDIA, index: index),
                                transition: Transition.cupertino);
                          },
                          child: model.MEDIA[index].PHOTO));
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
                    child: c == null
                        ? Text("1/${model.PHOTO_URL.length}",
                            style: const TextStyle(
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            textAlign: TextAlign.left)
                        : Obx(() {
                            return Text(
                                "${pc.photo_index.value + 1}/${model.PHOTO_URL.length}",
                                style: const TextStyle(
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Roboto",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12.0),
                                textAlign: TextAlign.left);
                          }),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: const Color(0xff2f2f2f)))),
    ]);
  }
}
