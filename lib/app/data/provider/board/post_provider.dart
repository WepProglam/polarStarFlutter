import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/ui/android/functions/photoOrVideo.dart';

import 'package:polarstar_flutter/session.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class PostApiClient {
  MainController mainController = Get.find();

  Future<Map<String, dynamic>> getPostData(
      int COMMUNITY_ID, int BOARD_ID) async {
    var response = await Session().getX("/board/$COMMUNITY_ID/read/$BOARD_ID");
    if (response.statusCode != 200) {
      return {"status": response.statusCode, "listBoard": []};
    }

    Iterable jsonReponse = jsonDecode(response.body);

    List<Post> tempListPost =
        jsonReponse.map((model) => Post.fromJson(model)).toList();

    for (Post post in tempListPost) {
      post.isScraped = mainController.isScrapped(post);
      post.isLiked = mainController.isLiked(post);
      print(post.PHOTO_URL);
      for (var item in post.PHOTO_URL) {
        if (isVideo(item)) {
          // final Uint8List data = await VideoThumbnail.thumbnailData(
          //   video: item,
          //   imageFormat: ImageFormat.JPEG,
          //   quality: 25,
          // );

          // post.MEDIA.add(POST_MEDIA(
          //     isVideo: true,
          //     PHOTO: Image.memory(
          //       data,
          //       fit: BoxFit.cover,
          //     ),
          //     VIDEO: null));

          post.MEDIA.add(POST_MEDIA(
              URL: item,
              isVideo: true,
              PHOTO: null,
              VIDEO: VideoPlayerController.network(item)
                ..initialize().then((_) {
                  // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                })));
        } else if (isPhoto(item)) {
          post.MEDIA.add(POST_MEDIA(
              URL: item,
              isVideo: false,
              PHOTO: Image(
                  image: CachedNetworkImageProvider(item, scale: 1.0),
                  fit: BoxFit.cover),
              VIDEO: null));
        }
      }
    }

    return {"statusCode": response.statusCode, "listPost": tempListPost};
  }

  // Future<int> deletePost(int COMMUNITY_ID, int BOARD_ID) async {
  //   var response =
  //       await Session().deleteX('/board/$COMMUNITY_ID/bid/$BOARD_ID');
  //   return response.statusCode;
  // }

  Future<int> deleteResource(
      int COMMUNITY_ID, int UNIQUE_ID, String tag) async {
    var response =
        await Session().deleteX('/board/$COMMUNITY_ID/$tag/$UNIQUE_ID');
    return response.statusCode;
  }

  Future<int> postComment(String url, var data) async {
    var response = await Session().postX(url, data);
    return response.statusCode;
  }

  Future<int> putComment(String url, var data) async {
    var response = await Session().putX(url, data);
    return response.statusCode;
  }
}
