import 'dart:convert';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/board/board_model.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';

import 'package:polarstar_flutter/session.dart';

class BoardApiClient {
  Future<Map<String, dynamic>> getBoard(int COMMUNITY_ID, int page) async {
    var response = await Session().getX("/board/$COMMUNITY_ID/page/$page");

    if (response.statusCode != 200) {
      return {"status": response.statusCode, "listBoard": <Rx<Post>>[]};
    }

    Iterable jsonResponse = jsonDecode(response.body);

    List<Rx<Post>> listBoard =
        jsonResponse.map((model) => Post.fromJson(model).obs).toList();

    return {"status": response.statusCode, "listBoard": listBoard};
  }

  Future<Map<String, dynamic>> getHotBoard(int page) async {
    var response = await Session().getX("/board/hot/page/$page");

    if (response.statusCode != 200) {
      return {"status": response.statusCode, "listBoard": []};
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
