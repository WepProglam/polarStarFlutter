import 'dart:convert';

import 'package:polarstar_flutter/app/data/model/board/post_model.dart';

import 'package:polarstar_flutter/session.dart';

class PostApiClient {
  Future<Map<String, dynamic>> getPostData(
      int COMMUNITY_ID, int BOARD_ID) async {
    var response = await Session().getX("/board/$COMMUNITY_ID/read/$BOARD_ID");
    if (response.statusCode != 200) {
      return {"status": response.statusCode, "listBoard": []};
    }

    Iterable jsonReponse = jsonDecode(response.body);

    List<Post> listPost =
        jsonReponse.map((model) => Post.fromJson(model)).toList();

    return {"statusCode": response.statusCode, "listPost": listPost};
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
