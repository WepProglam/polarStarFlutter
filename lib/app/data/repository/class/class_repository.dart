import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:polarstar_flutter/app/data/model/class/class_model.dart';
import 'package:polarstar_flutter/app/data/model/class/class_view_model.dart';

import 'package:polarstar_flutter/app/data/provider/class/class_provider.dart';

class ClassRepository {
  final ClassApiClient apiClient;

  ClassRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<Map<String, dynamic>> getRecentClass() async {
    final response = await apiClient.getRecentClass();

    if (response.statusCode != 200) {
      return {"statusCode": response.statusCode};
    } else {
      var jsonResponse = jsonDecode(response.body);

      // Map List를 Class model List로 만듦
      Iterable recentClass = jsonResponse["class"];
      Iterable recentReview = jsonResponse["review"];

      List<ClassModel> classList =
          recentClass.map((e) => ClassModel.fromJson(e)).toList();
      List<ClassRecentReviewModel> reviewList =
          recentReview.map((e) => ClassRecentReviewModel.fromJson(e)).toList();

      return {
        "statusCode": 200,
        "classList": classList,
        "reviewList": reviewList
      };
    }
  }

  Future<Map<String, dynamic>> arrestClassComment(
      int CLASS_ID, int CLASS_COMMENT_ID, int ARREST_TYPE) async {
    final response = await apiClient.arrestClassComment(
        CLASS_ID, CLASS_COMMENT_ID, ARREST_TYPE);

    return {"statusCode": response.statusCode};
  }

  Future<Map<String, dynamic>> arrestClassExam(
      int CLASS_ID, int CLASS_EXAM_ID, int ARREST_TYPE) async {
    final response =
        await apiClient.arrestClassExam(CLASS_ID, CLASS_EXAM_ID, ARREST_TYPE);

    return {"statusCode": response.statusCode};
  }

  Future<Map<String, dynamic>> getClassSearchList(
      String searchText, int page) async {
    final response = await apiClient.getClassSearchList(searchText, page);

    if (response.statusCode != 200) {
      return {"statusCode": response.statusCode};
    } else {
      // Map List를 Class model List로 만듦
      Iterable jsonResponse = json.decode(response.body);

      List<ClassModel> tempClassList =
          jsonResponse.map((e) => ClassModel.fromJson(e)).toList();
      List<ClassModel> classList =
          jsonResponse.map((e) => ClassModel.fromJson(e)).toList();

      // ! 검색 시 중복된 값 나오는거 해결 필요
      // for (ClassModel element in tempClassList) {
      //   tempClassList.firstWhere((element) => false)
      //   for (ClassModel item in classList) {
      //     if (element.PROFESSOR == item.PROFESSOR &&
      //         element.CLASS_NUMBER == item.CLASS_NUMBER) {}
      //   }
      // }

      return {"statusCode": 200, "classList": classList};
    }
  }

  Future<Map<String, dynamic>> getClassView(int classid) async {
    final response = await apiClient.getClassView(classid);

    if (response.statusCode != 200) {
      return {"statusCode": response.statusCode};
    } else {
      Map responseBody = json.decode(response.body);

      ClassInfoModel classInfo =
          ClassInfoModel.fromJson(responseBody["classInfo"]);
      Iterable classReviewList = responseBody["classReview"];

      List classReview =
          classReviewList.map((e) => ClassReviewModel.fromJson(e)).toList();

      return {
        "statusCode": 200,
        "classInfo": classInfo,
        "classReview": classReview
      };
    }
  }

  Future<Map<String, dynamic>> getCommentLike(
      int CLASS_ID, int CLASS_COMMENT_ID) async {
    final response = await apiClient.getCommentLike(CLASS_ID, CLASS_COMMENT_ID);

    return {"statusCode": response.statusCode};
  }

  Future<Map<String, dynamic>> getClassExam(int CLASS_ID) async {
    final response = await apiClient.getClassExam(CLASS_ID);
    if (response.statusCode != 200) {
      return {"statusCode": response.statusCode};
    } else {
      Iterable responseBody = json.decode(response.body);

      List classExamList =
          responseBody.map((e) => ClassExamModel.fromJson(e)).toList();

      return {
        "statusCode": response.statusCode,
        "classExamList": classExamList
      };
    }
  }

  Future<Map<String, dynamic>> getExamLike(
      int CLASS_ID, int CLASS_COMMENT_ID) async {
    final response = await apiClient.getExamLike(CLASS_ID, CLASS_COMMENT_ID);

    return {"statusCode": response.statusCode};
  }

  Future<Map<String, dynamic>> postComment(
      int CLASS_ID, Map<String, String> data) async {
    final response = await apiClient.postComment(CLASS_ID, data);

    return {"statusCode": response.statusCode};
  }

  Future<Map<String, dynamic>> postExam(
      int CLASS_ID, Map<String, dynamic> data) async {
    final response = await apiClient.postExam(CLASS_ID, data);

    return {"statusCode": response.statusCode};
  }

  Future<Map<String, dynamic>> buyExamInfo(
      int CLASS_ID, int CLASS_EXAM_ID) async {
    final response = await apiClient.buyExamInfo(CLASS_ID, CLASS_EXAM_ID);

    return {"statusCode": response.statusCode};
  }
}
