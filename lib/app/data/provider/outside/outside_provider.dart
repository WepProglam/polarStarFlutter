import 'dart:convert';
import 'package:polarstar_flutter/app/data/model/board/board_model.dart';

import 'package:polarstar_flutter/session.dart';

class OutSideApiClient {
  Future<Map<String, dynamic>> getBoard(int COMMUNITY_ID, int page) async {
    var response = await Session().getX("/outside/$COMMUNITY_ID/page/$page");
    if (response.statusCode != 200) {
      return {"status": response.statusCode, "listBoard": []};
    }

    Iterable jsonResponse = jsonDecode(response.body);

    List<Board> listBoard =
        jsonResponse.map((model) => Board.fromJson(model)).toList();

    return {"status": response.statusCode, "listBoard": listBoard};
  }

  Future<Map<String, dynamic>> getSearchAll(String searchText) async {
    var response =
        await Session().getX("/outside/searchAll/page/1?search=$searchText");
    if (response.statusCode != 200) {
      return {"status": response.statusCode, "listBoard": []};
    }
    Iterable jsonResponse = jsonDecode(response.body);

    List<Board> listBoard =
        jsonResponse.map((model) => Board.fromJson(model)).toList();

    return {"status": response.statusCode, "listBoard": listBoard};
  }

  Future<Map<String, dynamic>> getSearchBoard(
      String searchText, int COMMUNITY_ID) async {
    var response = await Session()
        .getX("/outside/$COMMUNITY_ID/search/page/1?search=$searchText");

    if (response.statusCode != 200) {
      return {"status": response.statusCode, "listBoard": []};
    }
    Iterable jsonResponse = jsonDecode(response.body);

    List<Board> listBoard =
        jsonResponse.map((model) => Board.fromJson(model)).toList();

    return {"status": response.statusCode, "listBoard": listBoard};
  }
}
