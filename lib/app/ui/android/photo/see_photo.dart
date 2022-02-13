import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/ui/android/class/widgets/app_bars.dart';
import 'package:polarstar_flutter/main.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:polarstar_flutter/app/ui/android/class/widgets/app_bars.dart';
import 'package:polarstar_flutter/main.dart';
import 'package:path/path.dart' as p;
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class SeeMedia extends StatefulWidget {
  SeeMedia({Key key, @required this.media, @required this.index})
      : super(key: key);
  final List<POST_MEDIA> media;
  int index;

  @override
  _SeeMediaState createState() => _SeeMediaState();
}

class _SeeMediaState extends State<SeeMedia> {
  bool appBarShow = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller =
        PageController(initialPage: widget.index, viewportFraction: 1.0);
    DownloadProgress downloadProgress;
    final Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        for (POST_MEDIA item in widget.media) {
          if (item.isVideo) {
            item.VIDEO.pause();
          }
        }
        return true;
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0.0,
            elevation: 0.0,
          ),
          body: Container(
            child: Stack(children: [
              Ink(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      appBarShow = !appBarShow;
                      // Future.delayed(Duration(milliseconds: 1500), () {
                      //   setState(() {
                      //     appBarShow = false;
                      //   });
                      //   print("??!!!!!@!@#");
                      // });
                    });
                  },
                  child: PageView.builder(
                      itemCount: widget.media.length,
                      controller: controller,
                      // pageSnapping: false,
                      allowImplicitScrolling: true,
                      onPageChanged: (value) {
                        setState(() {
                          widget.index = value;
                        });
                      },
                      itemBuilder: (context, int index) {
                        if (widget.media[index].isVideo) {
                          return InkWell(
                              child: Ink(
                                  child: Container(
                                      child: VideoPlayer(
                                          widget.media[index].VIDEO))));
                        }
                        return InteractiveViewer(
                          maxScale: 4,
                          minScale: 0.5,

                          // constrained: false,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Container(
                                width: size.width,
                                child: widget.media[index].PHOTO

                                // CachedNetworkImage(
                                //     imageUrl: "${widget.media[index]}",
                                //     fit: BoxFit.fitWidth,
                                //     fadeInDuration: Duration(milliseconds: 0),
                                //     progressIndicatorBuilder:
                                //         (context, url, downloadProgress) => Center(
                                //               child: CircularProgressIndicator(
                                //                 value: downloadProgress.progress,
                                //               ),
                                //             ),
                                //     errorWidget: (context, url, error) {
                                //       return Icon(Icons.error);
                                //     },
                                //     imageBuilder: (context, imageProvider) =>
                                //         Container(
                                //           decoration: BoxDecoration(
                                //               borderRadius: BorderRadius.circular(10),
                                //               image: DecorationImage(
                                //                   image: imageProvider,
                                //                   fit: BoxFit.fitWidth)),
                                //         ))
                                ),
                          ),
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
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Ink(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 16, 20, 16),
                              child: Image.asset(
                                "assets/images/848.png",
                                color: Colors.white,
                                width: 12,
                                height: 24,
                              ),
                            ),
                          ),
                          // ! 1.0.0 버전에선 보류
                          // Container(
                          //   margin: const EdgeInsets.only(right: 20),
                          //   child: Ink(
                          //     child: InkWell(
                          //       onTap: () async {
                          //         final status =
                          //             await Permission.storage.request();

                          //         if (status.isGranted) {
                          //           String dirloc = "";
                          //           if (Platform.isAndroid) {
                          //             dirloc = "/sdcard/download/";
                          //           } else {
                          //             dirloc =
                          //                 (await getApplicationDocumentsDirectory())
                          //                     .absolute
                          //                     .path;
                          //           }

                          //           if (!Directory(dirloc).existsSync()) {
                          //             dirloc =
                          //                 (await getApplicationDocumentsDirectory())
                          //                     .absolute
                          //                     .path;
                          //             if (!Directory(dirloc).existsSync()) {
                          //               Directory(dirloc)
                          //                   .create(recursive: true);
                          //             }
                          //           }

                          //           String file_name = widget
                          //               .media[widget.index].URL
                          //               .split("/")
                          //               .last;
                          //           // * 파일 이름 중복
                          //           if (File(p.join(dirloc, file_name))
                          //               .existsSync()) {
                          //             int i = 1;
                          //             int string_length = file_name.length;
                          //             String a = "aa.aa";
                          //             a.lastIndexOf(".");
                          //             int extend_length =
                          //                 file_name.split(".").last.length + 1;
                          //             int add_number_index =
                          //                 string_length - extend_length - 1;
                          //             // String dupliacte_file_name = file_name
                          //             while (File(p.join(
                          //                     dirloc,
                          //                     file_name.substring(
                          //                             0,
                          //                             file_name
                          //                                 .lastIndexOf(".")) +
                          //                         "(${i})." +
                          //                         file_name.split(".").last))
                          //                 .existsSync()) {
                          //               i += 1;
                          //             }

                          //             file_name = file_name.substring(
                          //                     0, file_name.lastIndexOf(".")) +
                          //                 "(${i})." +
                          //                 file_name.split(".").last;
                          //           }

                          //           // print(dirloc);
                          //           // print("==============================");

                          //           final String taskID =
                          //               await FlutterDownloader.enqueue(
                          //                   url: widget.media[widget.index].URL,
                          //                   savedDir: dirloc,
                          //                   fileName: file_name,
                          //                   showNotification: true,
                          //                   openFileFromNotification: true,
                          //                   saveInPublicStorage: true);

                          //           print("downloaded!!");
                          //         } else {
                          //           print('Permission Denied');
                          //         }
                          //       },
                          //       child: Image.asset(
                          //         "assets/images/file_after_download.png",
                          //         height: 24,
                          //         width: 24,
                          //         color: Colors.white,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      )),
                ),
              ),
              appBarShow && widget.media[widget.index].isVideo
                  ? AnimatedOpacity(
                      opacity: appBarShow ? 1 : 0,
                      duration: Duration(milliseconds: 100),
                      child: Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (widget
                                  .media[widget.index].VIDEO.value.isPlaying) {
                                widget.media[widget.index].VIDEO.pause();
                              } else {
                                widget.media[widget.index].VIDEO.play();
                              }
                            });
                          },
                          child: Ink(
                            padding: const EdgeInsets.all(50.0),
                            child: Icon(
                              widget.media[widget.index].VIDEO.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white60,
                              size: 100,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              widget.media[widget.index].isVideo
                  ? Positioned(
                      bottom: 0,
                      child: widget
                              .media[widget.index].VIDEO.value.isInitialized
                          ? Container(
                              width: Get.mediaQuery.size.width,
                              child: VideoProgressIndicator(
                                widget.media[widget.index].VIDEO,
                                allowScrubbing: true,
                                colors: VideoProgressColors(
                                    backgroundColor: const Color(0xffffffff),
                                    bufferedColor: const Color(0xffe6f1ff),
                                    playedColor: const Color(0xff4570ff)),
                              ),
                            )
                          : Container(
                              height: 10,
                            ))
                  : Container()
            ]),
          ),
        ),
      ),
    );
  }
}

// class SeePhoto extends StatefulWidget {
//   SeePhoto({Key key, @required this.photo, @required this.index})
//       : super(key: key);
//   final List<dynamic> photo;
//   int index;

//   @override
//   _SeePhotoState createState() => _SeePhotoState();
// }

// class _SeePhotoState extends State<SeePhoto> {
//   bool appBarShow = true;
//   @override
//   Widget build(BuildContext context) {
//     final PageController controller =
//         PageController(initialPage: widget.index, viewportFraction: 1.0);
//     DownloadProgress downloadProgress;
//     final Size size = MediaQuery.of(context).size;
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           child: Stack(children: [
//             Ink(
//               child: InkWell(
//                 onTap: () {
//                   setState(() {
//                     appBarShow = !appBarShow;
//                   });
//                 },
//                 child: PageView.builder(
//                     itemCount: widget.photo.length,
//                     controller: controller,
//                     allowImplicitScrolling: true,
//                     onPageChanged: (value) {
//                       setState(() {
//                         widget.index = value;
//                       });
//                     },
//                     itemBuilder: (context, int index) {
//                       return InteractiveViewer(
//                         maxScale: 4,
//                         minScale: 0.5,
//                         // constrained: false,
//                         // boundaryMargin: EdgeInsets.all(0),
//                         child: Container(
//                             width: size.width,
//                             child: CachedNetworkImage(
//                                 imageUrl: "${widget.photo[index]}",
//                                 fit: BoxFit.fitWidth,
//                                 fadeInDuration: Duration(milliseconds: 0),
//                                 progressIndicatorBuilder:
//                                     (context, url, downloadProgress) => Center(
//                                           child: CircularProgressIndicator(
//                                             value: downloadProgress.progress,
//                                           ),
//                                         ),
//                                 errorWidget: (context, url, error) {
//                                   return Icon(Icons.error);
//                                 },
//                                 imageBuilder: (context, imageProvider) =>
//                                     Container(
//                                       decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                           image: DecorationImage(
//                                               image: imageProvider,
//                                               fit: BoxFit.fitWidth)),
//                                     ))),
//                       );
//                     }),
//               ),
//             ),
//             Positioned(
//               top: 0,
//               child: AnimatedOpacity(
//                 opacity: appBarShow ? 1 : 0,
//                 duration: Duration(milliseconds: 100),
//                 child: Container(
//                     height: 56,
//                     width: Get.mediaQuery.size.width,
//                     color: Get.theme.primaryColor,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             Get.back();
//                           },
//                           child: Ink(
//                             padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
//                             child: Image.asset(
//                               "assets/images/848.png",
//                               color: Colors.white,
//                               width: 12,
//                               height: 24,
//                             ),
//                           ),
//                         ),
//                         //! 다운로드 일단 제거
//                         // Container(
//                         //   margin: const EdgeInsets.only(right: 20),
//                         //   child: Ink(
//                         //     child: InkWell(
//                         //       onTap: () {},
//                         //       child: Image.asset(
//                         //         "assets/images/file_after_download.png",
//                         //         height: 24,
//                         //         width: 24,
//                         //         color: Colors.white,
//                         //       ),
//                         //     ),
//                         //   ),
//                         // ),
//                       ],
//                     )),
//               ),
//             )
//           ]),
//         ),
//       ),
//     );
//   }
// }

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
      top: false,
      child: Scaffold(
        backgroundColor: Color(0xffffffff),
        appBar: AppBar(
          toolbarHeight: 0.0,
          elevation: 0.0,
        ),
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
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Ink(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16.0),
                            child: Image.asset(
                              "assets/images/848.png",
                              color: Colors.white,
                              width: 12,
                              height: 24,
                            ),
                          ),
                        ),
                        //! 사진 다운로드 일단 제거
                        // InkWell(
                        //   onTap: () {},
                        //   child: Ink(
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 20, vertical: 16.0),
                        //     child: Image.asset(
                        //       "assets/images/file_after_download.png",
                        //       height: 24,
                        //       width: 24,
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // ),
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
