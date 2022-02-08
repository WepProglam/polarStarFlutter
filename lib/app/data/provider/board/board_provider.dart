import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/board_model.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/ui/android/functions/photoOrVideo.dart';

import 'package:polarstar_flutter/session.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class BoardApiClient {
  MainController mainController = Get.find();
  Future<Map<String, dynamic>> getBoard(int COMMUNITY_ID, int page) async {
    var response = await Session().getX("/board/$COMMUNITY_ID/page/$page");
    print("/board/$COMMUNITY_ID/page/$page");

    if (response.statusCode != 200) {
      return {"status": response.statusCode, "listBoard": <Rx<Post>>[]};
    }

    Iterable jsonResponse = jsonDecode(response.body);

    print(jsonResponse);

    List<Rx<Post>> listBoard =
        jsonResponse.map((model) => Post.fromJson(model).obs).toList();

    for (Rx<Post> post in listBoard) {
      post.value.isScraped = mainController.isScrapped(post.value);
      post.value.isLiked = mainController.isLiked(post.value);
      if (post.value.PHOTO_URL != null && post.value.PHOTO_URL.length > 0) {
        // for (var item in post.value.PHOTO_URL) {
        var item = post.value.PHOTO_URL.first;
        if (isVideo(item)) {
          Uint8List data = await VideoThumbnail.thumbnailData(
            video: item,
            imageFormat: ImageFormat.JPEG,
            quality: 25,
          );
          post.value.MEDIA.add(POST_MEDIA(
              URL: item,
              isVideo: true,
              PHOTO: Image.memory(
                data,
                fit: BoxFit.cover,
              ),
              VIDEO: null));
          // VideoThumbnail.thumbnailData(
          //   video: item,
          //   imageFormat: ImageFormat.JPEG,
          //   quality: 25,
          // ).then((value) => {
          //       post.update((val) {
          //         val.MEDIA = [
          //           POST_MEDIA(
          //               isVideo: true,
          //               PHOTO: Image.memory(
          //                 value,
          //                 fit: BoxFit.cover,
          //               ),
          //               VIDEO: null)
          //         ];
          //       })
          //     });
        } else if (isPhoto(item)) {
          post.value.MEDIA.add(POST_MEDIA(
              URL: item,
              isVideo: false,
              PHOTO: Image(
                  image: CachedNetworkImageProvider(item, scale: 1.0),
                  fit: BoxFit.cover),
              VIDEO: null));
          // post.value.PHOTO.add(Image(
          //     image: CachedNetworkImageProvider(
          //       item,
          //       scale: 1.0,
          //     ),
          //     fit: BoxFit.cover));
        }
      }
      // }
    }

    return {"status": response.statusCode, "listBoard": listBoard};
  }

  Future<Map<String, dynamic>> getHotBoard(int page) async {
    var response = await Session().getX("/board/hot/page/$page");

    if (response.statusCode != 200) {
      return {"status": response.statusCode, "listBoard": <Rx<Post>>[].obs};
    }

    Iterable jsonResponse = jsonDecode(response.body);

    List<Rx<Post>> listBoard =
        jsonResponse.map((model) => Post.fromJson(model).obs).toList();

    return {"status": response.statusCode, "listBoard": listBoard};
  }

  Future<Map<String, dynamic>> getNewBoard(int page) async {
    var response = await Session().getX("/board/new/page/$page");

    if (response.statusCode != 200) {
      return {"status": response.statusCode, "listBoard": <Rx<Post>>[]};
    }

    Iterable jsonResponse = jsonDecode(response.body);

    List<Rx<Post>> listBoard =
        jsonResponse.map((model) => Post.fromJson(model).obs).toList();

    return {"status": response.statusCode, "listBoard": listBoard};
  }

  Future<Map<String, dynamic>> getSearchAll(String searchText) async {
    var response =
        await Session().getX("/board/searchAll/page/1?search=$searchText");

    if (response.statusCode != 200) {
      return {"status": response.statusCode, "listBoard": []};
    }

    Iterable jsonResponse = jsonDecode(response.body);

    List<Rx<Post>> listBoard =
        jsonResponse.map((model) => Post.fromJson(model).obs).toList();

    return {"status": response.statusCode, "listBoard": listBoard};
  }

  Future<Map<String, dynamic>> getSearchBoard(
      String searchText, int COMMUNITY_ID) async {
    var response = await Session()
        .getX("/board/$COMMUNITY_ID/search/page/1?search=$searchText");

    if (response.statusCode != 200) {
      return {"status": response.statusCode, "listBoard": []};
    }

    Iterable jsonResponse = jsonDecode(response.body);

    List<Rx<Post>> listBoard =
        jsonResponse.map((model) => Post.fromJson(model).obs).toList();

    return {"status": response.statusCode, "listBoard": listBoard};
  }
}
