import 'dart:convert';

import 'package:polarstar_flutter/app/data/model/main_model.dart';

import 'package:polarstar_flutter/session.dart';

class MainApiClient {
  Future<Map<String, List<dynamic>>> getBoardInfo() async {
    var getResponse = await Session().getX('/');
    final jsonResponse = jsonDecode(getResponse.body);

    Iterable boardInfo = jsonResponse["board"];
    Iterable hotBoard = jsonResponse["HotBoard"];

    List<BoardInfo> listBoardInfo =
        boardInfo.map((model) => BoardInfo.fromJson(model)).toList();

    List<HotBoard> listHotBoard =
        hotBoard.map((model) => HotBoard.fromJson(model)).toList();

    return {"boardInfo": listBoardInfo, "hotBoard": listHotBoard};
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
