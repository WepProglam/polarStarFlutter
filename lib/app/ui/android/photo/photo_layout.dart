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
    return Container(
      width: Get.mediaQuery.size.width,
      height: 110,
      margin: EdgeInsets.symmetric(vertical: 5.6),
      child: ListView.builder(
          cacheExtent: 10,
          scrollDirection: Axis.horizontal,
          itemCount: model.PHOTO.length,
          itemBuilder: (BuildContext context, int index) {
            return CachedNetworkImage(
                imageUrl: "${model.PHOTO[index]}",
                // progressIndicatorBuilder: (context, url, downloadProgress) =>
                //     Container(
                //       margin: EdgeInsets.only(right: 4.2),
                //       width: 110,
                //       height: 110,
                //       color: Colors.lightBlue[50],
                //       // child: Image(
                //       //     image: AssetImage(
                //       //         'assets/images/photo_placeholder.jpg')),
                //     ),
                placeholder: (context, url) => Container(
                      margin: EdgeInsets.only(right: 4.2),
                      width: 110,
                      height: 110,
                      color: Colors.black38,
                      // color: const Color(0xff194678),
                    ),
                errorWidget: (context, url, error) {
                  print(error);
                  return Icon(Icons.error);
                },
                imageBuilder: (context, imageProvider) => Ink(
                      child: InkWell(
                        onTap: () {
                          print(index);
                          Get.to(
                              () => SeePhoto(photo: model.PHOTO, index: index));
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 4.2),
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover)),
                        ),
                      ),
                    ));
          }),
    );
  }
}
