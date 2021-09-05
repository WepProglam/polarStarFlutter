import 'dart:convert';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';

import 'package:polarstar_flutter/session.dart';

class ClassApiClient {
  Future getClassList() async {
    final response = await Session().getX('/class');
    return response;
  }

  Future getRecentClass() async {
    final response = await Session().getX('/class/recentClass');
    return response;
  }

  Future getRecentClassComment() async {
    final response = await Session().getX('/class/recentClassComment');
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

  Future getClassExam(int CLASS_ID) async {
    final response = await Session().getX('/class/exam/$CLASS_ID');
    return response;
  }

  Future getExamLike(int CLASS_ID, int CLASS_EXAM_ID) async {
    final response = await Session()
        .getX('/class/exam/$CLASS_ID/like?CLASS_EXAM_ID=$CLASS_EXAM_ID');
    return response;
  }

  Future postComment(int CLASS_ID, Map data) async {
    final response = await Session().postX("/class/view/$CLASS_ID", data);
    return response;
  }

  Future postExam(int CLASS_ID, Map data) async {
    final response = await Session().postX("/class/exam/$CLASS_ID", data);
    return response;
  }
}
