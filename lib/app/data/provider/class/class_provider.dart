import 'dart:convert';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';

import 'package:polarstar_flutter/session.dart';

class ClassApiClient {
  Future getClassList() async {
    final response = await Session().getX('/class');
    return response;
  }

  Future getClassSearchList(String searchText) async {
    final response = await Session().getX('/class/search?search=$searchText');
    return response;
  }

  Future getClassView(int classid) async {
    final response = await Session().getX('/class/view/$classid');
    return response;
  }

  Future getCommentLike(int CLASS_ID, int CLASS_COMMENT_ID) async {
    final response = await Session()
        .getX('/class/view/$CLASS_ID/like?CLASS_COMMENT_ID=$CLASS_COMMENT_ID');
    return response;
  }
}
