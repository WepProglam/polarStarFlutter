import 'dart:convert';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/data/model/board/board_model.dart';
import 'package:polarstar_flutter/app/data/model/board/post_model.dart';
import 'package:polarstar_flutter/app/data/model/profile/mypage_model.dart';
import 'package:polarstar_flutter/session.dart';
import 'package:http/http.dart' as http;

const UNDEFINED = {
  "PROFILE_ID": null,
  "LOGIN_ID": null,
  "PROFILE_NICKNAME": null,
  "PROFILE_SCHOOL": null,
  "PROFILE_PHOTO": null,
  "PROFILE_MESSAGE": null,
  "PROFILE_ARREST_AMOUNT": null,
  "PROFILE_TYPE": null,
  "CLASS_POINT": null,
  "IS_ACCUSED": null,
  "TIME_IN_JAIL": null,
  "IS_DELETED": null,
  "EMAIL": null
};

class MyPageApiClient {
  Future<Map<String, dynamic>> getMineWrite() async {
    var response = await Session().getX("/info");
    var responseBody = jsonDecode(response.body);

    var profileData;
    try {
      profileData = responseBody["PROFILE"];
    } catch (e) {
      profileData = UNDEFINED;
    }
    Iterable listMyPageBoard;
    try {
      listMyPageBoard = responseBody["WritePost"];
    } catch (e) {
      listMyPageBoard = [];
    }

    List<Rx<Post>> listMyPageBoardVal;
    MyProfileModel myProfile;

    listMyPageBoardVal =
        listMyPageBoard.map((model) => Post.fromJson(model).obs).toList();
    myProfile = MyProfileModel.fromJson(profileData);

    return {
      "status": response.statusCode,
      "myPageBoard": listMyPageBoardVal,
      "myProfile": myProfile
    };
    // } catch (e) {
    //   return {
    //     "status": response.statusCode,
    //     "myPageBoard": [],
    //     "myProfile": []
    //   };
    // }
  }

  Future<Map<String, dynamic>> getMineLike() async {
    var response = await Session().getX("/info/like");

    if (response.statusCode != 200) {
      return {"status": response.statusCode, "myPageBoard": []};
    }

    var responseBody = jsonDecode(response.body);
    List<Rx<Post>> listMyPageBoardVal;
    Iterable listMyPageBoard = responseBody["LIKE"];
    listMyPageBoardVal =
        listMyPageBoard.map((model) => Post.fromJson(model).obs).toList();
    return {"status": response.statusCode, "myPageBoard": listMyPageBoardVal};
  }

  Future<Map<String, dynamic>> getMineScrap() async {
    var response = await Session().getX("/info/scrap");

    if (response.statusCode != 200) {
      return {"status": response.statusCode, "myPageBoard": []};
    }

    var responseBody = jsonDecode(response.body);
    List<Rx<Post>> listMyPageBoardVal;
    Iterable listMyPageBoard = responseBody["SCRAP"];
    listMyPageBoardVal =
        listMyPageBoard.map((model) => Post.fromJson(model).obs).toList();
    return {"status": response.statusCode, "myPageBoard": listMyPageBoardVal};
  }

  Future<Map<String, dynamic>> uploadProfileImage(
      http.MultipartFile photo) async {
    var request = Session().multipartReq('PATCH', '/info/modify/photo');

    request.files.add(photo);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return {
      "status": response.statusCode,
      "src": jsonDecode(response.body)["src"]
    };
  }
}
