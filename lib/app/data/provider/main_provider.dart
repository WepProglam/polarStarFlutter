import 'dart:convert';

import 'package:polarstar_flutter/app/data/model/main_model.dart';

import 'package:polarstar_flutter/session.dart';

class MainApiClient {
  Future<Map<String, dynamic>> getBoardInfo(
      List<String> follwingCommunity) async {
    var getResponse = await Session().getX('/?follow=${follwingCommunity}');

    final jsonResponse = jsonDecode(getResponse.body);

    Iterable boardInfo = jsonResponse["board"];
    Iterable hotBoard = jsonResponse["HotBoard"];
    Iterable likeList = jsonResponse["LikeList"];
    Iterable scrapList = jsonResponse["ScrapList"];
    Iterable classList = jsonResponse["CLASSES"];

    List<BoardInfo> listBoardInfo =
        boardInfo.map((model) => BoardInfo.fromJson(model)).toList();

    List<HotBoard> listHotBoard =
        hotBoard.map((model) => HotBoard.fromJson(model)).toList();

    List<LikeListModel> listLikeList =
        likeList.map((e) => LikeListModel.fromJson(e)).toList();

    List<ScrapListModel> listScrapList =
        scrapList.map((e) => ScrapListModel.fromJson(e)).toList();

    List<MainClassModel> listClassList =
        classList.map((e) => MainClassModel.fromJson(e)).toList();

    return {
      "statusCode": getResponse.statusCode,
      "boardInfo": listBoardInfo,
      "hotBoard": listHotBoard,
      "likeList": listLikeList,
      "scrapList": listScrapList,
      "classList": listClassList
    };
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
