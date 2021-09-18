import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          PageView.builder(
              itemCount: widget.photo.length,
              onPageChanged: (value) {
                setState(() {
                  widget.index = value;
                });
              },
              itemBuilder: (context, int index) {
                return InteractiveViewer(
                  maxScale: 4,
                  minScale: 0.5,
                  panEnabled: false,
                  boundaryMargin: EdgeInsets.all(80),
                  child: Container(
                      width: size.width,
                      child: CachedNetworkImage(
                          imageUrl: "${widget.photo[index]}",
                          fadeInDuration: Duration(milliseconds: 0),
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Container(
                                    child: Image(
                                        image: AssetImage(
                                            'assets/images/spinner.gif')),
                                  ),
                          errorWidget: (context, url, error) {
                            return Icon(Icons.error);
                          },
                          imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fitWidth)),
                              ))),
                );
              }),
          Positioned(
              top: 10,
              left: 4,
              child: Ink(
                  width: 20,
                  height: 20,
                  child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Image.asset("assets/images/848.png"))))
        ]),
      ),
    );
  }
}
