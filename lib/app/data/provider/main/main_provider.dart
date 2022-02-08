import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/model/class/class_model.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';
import 'package:polarstar_flutter/app/ui/android/functions/photoOrVideo.dart';

import 'package:polarstar_flutter/session.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MainApiClient {
  // final MainController mainController = Get.find();
  Future<Map<String, dynamic>> getBoardInfo(
      List<String> follwingCommunity) async {
    print(follwingCommunity);
    var getResponse = await Session().getX('/?follow=${follwingCommunity}');

    final jsonResponse = jsonDecode(getResponse.body);

    Iterable boardInfo = jsonResponse["board"];
    Iterable hotBoard = jsonResponse["HotBoard"];
    Iterable likeList = jsonResponse["LikeList"];
    Iterable scrapList = jsonResponse["ScrapList"];
    Iterable classList = jsonResponse["CLASSES"];
    Iterable bannerList = jsonResponse["bannerList"];

    List<BoardInfo> listBoardInfo =
        boardInfo.map((model) => BoardInfo.fromJson(model)).toList();

    List<Rx<Post>> listHotBoard =
        hotBoard.map((model) => Post.fromJson(model).obs).toList();

    for (Rx<Post> post in listHotBoard) {
      // post.value.isScraped = mainController.isScrapped(post.value);
      // post.value.isLiked = mainController.isLiked(post.value);
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
        } else if (isPhoto(item)) {
          post.value.MEDIA.add(POST_MEDIA(
              URL: item,
              isVideo: false,
              PHOTO: Image(
                  image: CachedNetworkImageProvider(item, scale: 1.0),
                  fit: BoxFit.cover),
              VIDEO: null));
        }
      }
      // }
    }

    List<LikeListModel> listLikeList =
        likeList.map((e) => LikeListModel.fromJson(e)).toList();

    List<ScrapListModel> listScrapList =
        scrapList.map((e) => ScrapListModel.fromJson(e)).toList();

    List<ClassModel> listClassList =
        classList.map((e) => ClassModel.fromJson(e)).toList();

    List<BannerListModel> listBannerList =
        bannerList.map((e) => BannerListModel.fromJson(e)).toList();

    return {
      "statusCode": getResponse.statusCode,
      "boardInfo": listBoardInfo,
      "hotBoard": listHotBoard,
      "likeList": listLikeList,
      "scrapList": listScrapList,
      "bannerList": listBannerList,
      "classList": listClassList,
      "year_sem": jsonResponse["YEAR_SEM"],
      "MAX_BOARDS_LIMIT": jsonResponse["MAX_BOARDS_LIMIT"],
      "PROFILE": jsonResponse["PROFILE"],
      "MIN_CLASS_REVIEW_LENGTH": jsonResponse["MIN_CLASS_REVIEW_LENGTH"]
    };
  }

  Future<Map<String, dynamic>> getNewBoard(int page) async {
    var response = await Session().getX("/board/new/page/$page");

    if (response.statusCode != 200) {
      return {"status": response.statusCode, "listBoard": <Rx<Post>>[]};
    }

    Iterable jsonResponse = jsonDecode(response.body);

    List<Rx<Post>> listBoard =
        jsonResponse.map((model) => Post.fromJson(model).obs).toList();

    for (Rx<Post> post in listBoard) {
      // post.value.isScraped = mainController.isScrapped(post.value);
      // post.value.isLiked = mainController.isLiked(post.value);
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
        } else if (isPhoto(item)) {
          post.value.MEDIA.add(POST_MEDIA(
              URL: item,
              isVideo: false,
              PHOTO: Image(
                  image: CachedNetworkImageProvider(item, scale: 1.0),
                  fit: BoxFit.cover),
              VIDEO: null));
        }
      }
      // }
    }

    return {"status": response.statusCode, "listBoard": listBoard};
  }

  Future<Map<String, String>> versionCheck() async {
    final response = await Session().getX('/versionCheck');
    final jsonResponse = jsonDecode(response.body);

    return {
      "status": response.statusCode.toString(),
      "min_version": jsonResponse["min_version"],
      "latest_version": jsonResponse["latest_version"]
    };
  }

  Future<List<dynamic>> refreshLikeList() async {
    final response = await Session().getX('/main/refresh/like');
    final jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }

  Future<List<dynamic>> refreshScrapList() async {
    final response = await Session().getX('/main/refresh/scrap');
    final jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }

  Future<Map<String, dynamic>> createCommunity(
      String COMMUNITY_NAME, String COMMUNITY_DESCRIPTION) async {
    var response = await Session().postX('/board', {
      'COMMUNITY_NAME': COMMUNITY_NAME,
      "COMMUNITY_DESCRIPTION": COMMUNITY_DESCRIPTION
    });

    return {"status": response.statusCode};
  }
}
