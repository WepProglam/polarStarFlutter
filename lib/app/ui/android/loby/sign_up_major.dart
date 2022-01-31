import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:polarstar_flutter/app/controller/loby/sign_up_controller.dart';
import 'package:polarstar_flutter/app/data/model/sign_up_model.dart';

import 'package:polarstar_flutter/app/ui/android/functions/form_validator.dart';

import 'package:polarstar_flutter/app/ui/android/widgets/custom_text_form_field.dart';

class SignUpMajor extends StatelessWidget {
  const SignUpMajor({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignUpController signUpController = Get.find();
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          elevation: 0,
          leading: InkWell(
            child: Image.asset("assets/images/icn_back_white.png"),
            onTap: () => Get.back(),
          ),
          centerTitle: true,
          title: Text("注册会员",
              style: const TextStyle(
                  color: const Color(0xffffffff),
                  fontWeight: FontWeight.w500,
                  fontFamily: "NotoSansSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0),
              textAlign: TextAlign.center)),
      body: MajorInputs(
        signUpController: signUpController,
      ),
    ));
  }
}

class MajorInputs extends StatelessWidget {
  const MajorInputs({Key key, this.signUpController}) : super(key: key);
  final SignUpController signUpController;

  @override
  Widget build(BuildContext context) {
    final universityController = TextEditingController(text: "성균관대학교");

    final _formKey = GlobalKey<FormState>();
    final majorScrollController = ScrollController(initialScrollOffset: 0.0);

    return SingleChildScrollView(
      controller: majorScrollController,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40.0),
                child: Text("大学",
                    style: const TextStyle(
                        color: const Color(0xff4570ff),
                        fontWeight: FontWeight.w500,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.left),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: TextFormField(
                  // initialValue: "성균관대학교",
                  readOnly: true,
                  controller: universityController,
                  validator: (value) {
                    return checkEmpty(value);
                  },
                  style: const TextStyle(
                      color: const Color(0xffd6d4d4),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(10.0, 11.0, 10.0, 11.0),
                      isDense: true,
                      hintText: "Search Your University",
                      hintStyle: const TextStyle(
                          color: const Color(0xffd6d4d4),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: const Color(0xffeaeaea), width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: const Color(0xffeaeaea), width: 1)),
                      border: InputBorder.none),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 18),
                child: Text("选择专业",
                    style: const TextStyle(
                        color: const Color(0xff4570ff),
                        fontWeight: FontWeight.w500,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.left),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: TextFormField(
                    onTap: () async {
                      await Future.delayed(Duration(milliseconds: 100));
                      majorScrollController.animateTo(
                          majorScrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 100),
                          curve: Curves.fastOutSlowIn);
                      signUpController.majorSelected.value = false;
                    },
                    style: const TextStyle(
                        color: const Color(0xff2f2f2f),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Roboto",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 11.0, 10.0, 11.0),
                        isDense: true,
                        hintText: "Search Your Major",
                        hintStyle: const TextStyle(
                            color: const Color(0xffd6d4d4),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: const Color(0xffeaeaea), width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: const Color(0xffeaeaea), width: 1)),
                        border: InputBorder.none),
                    controller: signUpController.majorController,
                    onChanged: (string) {
                      if (string.isEmpty) {
                        // if the search field is empty or only contains white-space, we'll display all users
                        signUpController.searchedMajorList.value = [];
                      } else {
                        signUpController.searchedMajorList(signUpController
                            .majorList
                            .where((major) => major.MAJOR_NAME
                                .toLowerCase()
                                .contains(string.toLowerCase()))
                            .toList());
                        // we use the toLowerCase() method to make it case-insensitive
                      }
                    },
                  )),
              Obx(() {
                return signUpController.majorSelected.value
                    ? Container()
                    : LimitedBox(
                        maxHeight: 100.0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                                color: const Color(0xffeaeaea), width: 1),
                          ),
                          child: Obx(() => ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  signUpController.searchedMajorList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      signUpController.majorSelected.value =
                                          true;
                                      signUpController.majorController.text =
                                          signUpController
                                              .searchedMajorList[index]
                                              .MAJOR_NAME;
                                      signUpController.selectedMajor(
                                          signUpController
                                              .searchedMajorList[index]
                                              .MAJOR_ID);
                                    },
                                    child: Text(
                                      signUpController
                                          .searchedMajorList[index].MAJOR_NAME,
                                      style: const TextStyle(
                                          color: const Color(0xff2f2f2f),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "NotoSansKR",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12.0),
                                    ),
                                  ),
                                );
                              })),
                        ),
                      );
              }),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text("入学年份",
                    style: const TextStyle(
                        color: const Color(0xff4570ff),
                        fontWeight: FontWeight.w500,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.left),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 2.0),
                  child: Builder(builder: (context) {
                    List<int> addmissionYear = [
                      for (var i = 0; i < 13; i++) 2010 + i
                    ];
                    // addmissionYear = addmissionYear.reversed.toList();
                    return Obx(() {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: const Color(0xffeaeaea), width: 1),
                        ),
                        child: DropdownButton(
                            underline: Container(),
                            isExpanded: true,
                            value: signUpController.admissionYear.value,
                            items: addmissionYear
                                .map((e) => DropdownMenuItem(
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Text(
                                          "${e}",
                                          style: const TextStyle(
                                              color: const Color(0xff2f2f2f),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Roboto",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 14.0),
                                        ),
                                      ),
                                      value: e,
                                    ))
                                .toList(),
                            onChanged: (val) {
                              signUpController.admissionYear.value = val;
                            }),
                      );
                    });
                  })),
              Padding(
                padding: const EdgeInsets.only(top: 48.0, bottom: 12.0),
                child: InkWell(
                  onTap: () async {
                    if (_formKey.currentState.validate()) {
                      if (signUpController.selectIndexPK(
                              signUpController.selectedMajor.value) ==
                          null) {
                        Get.snackbar(
                            "Major not selected", "Major not selected.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.black,
                            colorText: Colors.white);
                        return;
                      }
                      Get.toNamed('/signUp');
                      // await signUpController.signUp(
                      //     idController.text,
                      //     pwController.text,
                      //     nicknameController.text,
                      //     studentIDController.text,
                      //     signUpController.selectIndexPK(
                      //         signUpController.selectedMajor.value),
                      //     signUpController.admissionYear.value);
                    }
                  },
                  child: Ink(
                    height: 48.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0x33000000),
                              offset: Offset(0, 3),
                              blurRadius: 10,
                              spreadRadius: 0)
                        ],
                        color: const Color(0xff4570ff)),
                    child: Center(
                      child: Text("注册",
                          style: const TextStyle(
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w700,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ),
              Center(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      style: const TextStyle(
                          color: const Color(0xff6f6e6e),
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 10.0),
                      text: "已有账号, "),
                  TextSpan(
                    style: const TextStyle(
                        color: const Color(0xff4570ff),
                        fontWeight: FontWeight.w500,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 10.0),
                    text: "登录",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.back(),
                  )
                ])),
              )
            ],
          ),
        ),
      ),
    );
  }
}
