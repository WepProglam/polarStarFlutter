import 'dart:convert';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/board/board_model.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';

import 'package:polarstar_flutter/session.dart';

class SearchApiClient {
  Future<Map<String, dynamic>> getSearchBoard(
      String searchText, int COMMUNITY_ID, String from) async {
    var response = await Session()
        .getX("/$from/$COMMUNITY_ID/search/page/1?search=$searchText");
    if (response.statusCode != 200) {
      return {"status": response.statusCode, "listBoard": []};
    }
    Iterable jsonResponse = jsonDecode(response.body);

    List<Rx<Post>> listBoard =
        jsonResponse.map((model) => Post.fromJson(model).obs).toList();

    return {"status": response.statusCode, "listBoard": listBoard};
  }
}
