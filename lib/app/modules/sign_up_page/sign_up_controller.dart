import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'package:polarstar_flutter/app/data/model/sign_up_model.dart';
import 'package:polarstar_flutter/app/data/repository/sign_up_repository.dart';
import 'package:polarstar_flutter/session.dart';

class SignUpController extends GetxController {
  final SignUpRepository repository;
  final box = GetStorage();

  SignUpController({@required this.repository}) : assert(repository != null);

  RxBool campusSelected = false.obs;
  RxBool majorSelected = false.obs;
  RxBool doubleMajorSelected = false.obs;

  final idController = TextEditingController();
  final pwController = TextEditingController();
  final pwConfirmController = TextEditingController();
  //final emailController = TextEditingController();
  final nicknameController = TextEditingController();
  final studentIDController = TextEditingController();
  final campusController = TextEditingController();
  final majorController = TextEditingController();
  final doubleMajorController = TextEditingController();

  // ! 나중엔 신학기 3월마다 숫자 바꾸는 로직 추가해야할듯
  RxInt admissionYear = 2022.obs;
  Future signUp(
      String id,
      String pw,
      String nickname,
      String studentID,
      int CAMPUS_ID,
      int MAJOR_ID,
      int DOUBLE_MAJOR_ID,
      int ADMISSION_YEAR) async {
    Map<String, String> data = {
      "id": id,
      "pw": pw,
      "nickname": nickname,
      "studentID": studentID,
      "CAMPUS_ID": "${CAMPUS_ID}",
      "MAJOR_ID": "${MAJOR_ID}",
      "DOUBLE_MAJOR_ID": "${DOUBLE_MAJOR_ID}",
      "ADMISSION_YEAR": "${ADMISSION_YEAR}"
    };

    final response = await repository.signUp(data);

    switch (response["statusCode"]) {
      case 200:
        Get.until((route) => Get.currentRoute == '/login');
        // * 회원가입 성공
        await Get.snackbar(
          "会员注册成功",
          "会员注册成功",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black,
          colorText: Colors.white,
        );
        break;
      default:
        Get.snackbar("注册失败", "注册失败",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black,
            colorText: Colors.white);
    }
  }

  RxBool idOK = false.obs;
  RxBool pwOK = false.obs;

  Future IDTest(String id) async {
    Map<String, String> data = {"id": id};

    final response = await repository.IDTest(data);

    switch (response["statusCode"]) {
      case 200:
        print("ID not duplicate");
        idOK.value = true;
        // Get.snackbar("ID not duplicate", "ID not duplicate");

        break;
      default:
        print("ID duplicate");
        idOK.value = false;

      // Get.snackbar("ID duplicate", "ID duplicate");
    }
  }

  RxBool nicknameOK = false.obs;

  Future nicknameTest(String nickname) async {
    Map<String, String> data = {"nickname": nickname};

    final response = await repository.nicknameTest(data);

    switch (response["statusCode"]) {
      case 200:
        print("nickname not duplicate");
        nicknameOK.value = true;
        // Get.snackbar("ID not duplicate", "ID not duplicate");

        break;
      default:
        print("nickname duplicate");
        nicknameOK.value = false;

      // Get.snackbar("ID duplicate", "ID duplicate");
    }
  }

  RxInt selectedCampus = 0.obs;
  RxInt selectedCollege = 0.obs;
  RxInt selectedMajor = 0.obs;
  RxInt selectedDoubleMajor = 0.obs;

  RxList<CampusModel> campusList = <CampusModel>[].obs;
  RxList<CollegeMajorModel> collegeList = <CollegeMajorModel>[].obs;
  RxList<CollegeMajorModel> majorList = <CollegeMajorModel>[].obs;

  RxList<CampusModel> searchedCampusList = <CampusModel>[].obs;
  RxList<CollegeMajorModel> searchedMajorList = <CollegeMajorModel>[].obs;
  RxList<CollegeMajorModel> searchedDoubleMajorList = <CollegeMajorModel>[].obs;

  Future<void> getCampusInfo() async {
    var response = await Session().getX("/signup/campusInfo");
    var json = jsonDecode(response.body);
    Iterable tempCampusList = json["campus"];

    campusList.value =
        tempCampusList.map((e) => CampusModel.fromJson(e)).toList();
  }

  Future<void> getMajorInfo(int CAMPUS_ID) async {
    var response =
        await Session().getX("/signup/majorInfo?CAMPUS_ID=${CAMPUS_ID}");
    var json = jsonDecode(response.body);
    Iterable tempCollegeList = json["college"];
    Iterable tempMajorList = json["major"];

    collegeList.value =
        tempCollegeList.map((e) => CollegeMajorModel.fromJson(e)).toList();
    majorList.value =
        tempMajorList.map((e) => CollegeMajorModel.fromJson(e)).toList();

    selectedCollege.value =
        collegeList.length > 0 ? collegeList.first.COLLEGE_ID : 0;
  }

  Future emailAuthRequest(String email) async {
    Map<String, String> data = {"email": email};

    final response = await repository.emailAuthRequest(data);

    switch (response["statusCode"]) {
      case 200:
        print("emailAuthRequest 성공");
        Get.snackbar("emailAuthRequest 성공", "emailAuthRequest 성공");

        break;
      default:
        print("emailAuthRequest 실패");
        Get.snackbar("emailAuthRequest 실패", "emailAuthRequest 실패");
    }
  }

  Future emailAuthVerify(String email, String code) async {
    Map<String, String> data = {"email": email, "code": code};

    final response = await repository.emailAuthVerify(data);

    switch (response["statusCode"]) {
      case 200:
        print("emailAuthVerify 성공");
        Get.snackbar("emailAuthVerify 성공", "emailAuthVerify 성공");

        break;
      default:
        print("emailAuthRequest 실패");
        Get.snackbar("emailAuthVerify 실패", "emailAuthVerify 실패");
    }
  }

  @override
  void onInit() async {
    super.onInit();
  }

  int selectMajorIndexPK(int INDEX) {
    int PK = null;
    for (CollegeMajorModel item in majorList) {
      if (item.MAJOR_ID == INDEX) {
        PK = item.MAJOR_ID;
      }
    }
    return PK;
  }

  int selectDoubleMajorIndexPK(int INDEX) {
    if (INDEX == 0) {
      return 0;
    }
    int PK = null;
    for (CollegeMajorModel item in majorList) {
      if (item.MAJOR_ID == INDEX) {
        PK = item.MAJOR_ID;
      }
    }
    return PK;
  }
}
