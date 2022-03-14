import 'dart:convert';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';
import 'package:http/http.dart' as http;
import 'package:polarstar_flutter/session.dart';

class ClassApiClient {
  Future getRecentClass() async {
    final response = await Session().getX('/class/recentClass');
    return response;
  }

  Future arrestClassComment(
      int CLASS_ID, int CLASS_COMMENT_ID, int ARREST_TYPE) async {
    final response = await Session().getX(
        '/class/arrest/class_id/${CLASS_ID}/comment_id/${CLASS_COMMENT_ID}?ARREST_TYPE=${ARREST_TYPE}');
    return response;
  }

  Future arrestClassExam(
      int CLASS_ID, int CLASS_EXAM_ID, int ARREST_TYPE) async {
    final response = await Session().getX(
        '/class/exam/arrest/class_id/${CLASS_ID}/exam_id/${CLASS_EXAM_ID}?ARREST_TYPE=${ARREST_TYPE}');
    return response;
  }

  Future getRecentClassComment() async {
    final response = await Session().getX('/class/recentClassComment');
    return response;
  }

  Future getClassSearchList(String searchText, int page) async {
    final response =
        await Session().getX('/class/search/page/$page?search=$searchText');
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

  Future postComment(int CLASS_ID, Map<String, dynamic> data) async {
    final response = await Session().postX("/class/view/$CLASS_ID", data);
    return response;
  }

  Future postExam(int CLASS_ID, Map<String, dynamic> data) async {
    final response = await Session().postX("/class/exam/$CLASS_ID", data);
    return response;
  }

  Future postExamWithPhotoOrFile(int CLASS_ID, List<http.MultipartFile> pic,
      Map<String, dynamic> data) async {
    http.MultipartRequest request =
        await Session().multipartReq("POST", "/class/exam/$CLASS_ID");
    request.files.addAll(pic);
    data.forEach((key, value) {
      request.fields[key] = value;
    });

    var response = await request.send();
    return response.statusCode;
  }

  Future buyExamInfo(int CLASS_ID, int CLASS_EXAM_ID) async {
    final response = await Session()
        .getX("/class/exam/$CLASS_ID/buy?CLASS_EXAM_ID=$CLASS_EXAM_ID");

    return response;
  }
}
