import 'dart:convert';

import 'package:polarstar_flutter/app/data/model/board/post_model.dart';

import 'package:polarstar_flutter/session.dart';

class OutSidePostApiClient {
  Future<Map<String, dynamic>> getPostData(
      int COMMUNITY_ID, int BOARD_ID) async {
    var response =
        await Session().getX("/outside/$COMMUNITY_ID/read/$BOARD_ID");

    if (response.statusCode != 200) {
      return {"status": response.statusCode, "listBoard": []};
    }

    Iterable jsonReponse = jsonDecode(response.body);

    List<Post> listPost =
        jsonReponse.map((model) => Post.fromJson(model)).toList();

    return {"statusCode": response.statusCode, "listPost": listPost};
  }
}
