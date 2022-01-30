import 'dart:convert';

import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/model/class/class_model.dart';
import 'package:polarstar_flutter/app/data/model/main_model.dart';

import 'package:polarstar_flutter/session.dart';

class MainApiClient {
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

    List<BoardInfo> listBoardInfo =
        boardInfo.map((model) => BoardInfo.fromJson(model)).toList();

    List<Rx<Post>> listHotBoard =
        hotBoard.map((model) => Post.fromJson(model).obs).toList();

    List<LikeListModel> listLikeList =
        likeList.map((e) => LikeListModel.fromJson(e)).toList();

    List<ScrapListModel> listScrapList =
        scrapList.map((e) => ScrapListModel.fromJson(e)).toList();

    List<ClassModel> listClassList =
        classList.map((e) => ClassModel.fromJson(e)).toList();

    return {
      "statusCode": getResponse.statusCode,
      "boardInfo": listBoardInfo,
      "hotBoard": listHotBoard,
      "likeList": listLikeList,
      "scrapList": listScrapList,
      "classList": listClassList,
      "year_sem": jsonResponse["YEAR_SEM"],
      "MAX_BOARDS_LIMIT": jsonResponse["MAX_BOARDS_LIMIT"],
      "PROFILE": jsonResponse["PROFILE"]
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
