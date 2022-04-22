import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/global_functions/form_validator.dart';
import 'package:polarstar_flutter/app/modules/sign_up_major/sign_up_major.dart';
import 'package:polarstar_flutter/app/modules/sign_up_page/sign_up_controller.dart';

class CampusInputs extends StatelessWidget {
  const CampusInputs({Key key, this.signUpController}) : super(key: key);
  final SignUpController signUpController;

  @override
  Widget build(BuildContext context) {
    final universityController = TextEditingController(text: "성균관대학교");

    final _formKey = GlobalKey<FormState>();
    final majorScrollController = ScrollController(initialScrollOffset: 0.0);
    final campusFocus = FocusNode();

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              controller: majorScrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        focusNode: campusFocus,
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
                            hintText: "대학교를 입력하세요",
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
                        controller: signUpController.campusController,
                        onChanged: (string) {
                          signUpController.campusSelected.value = false;
                          print(string);
                          if (string.isEmpty) {
                            // if the search field is empty or only contains white-space, we'll display all users
                            signUpController.searchedCampusList.value = [];
                          } else {
                            signUpController.searchedCampusList(signUpController
                                .campusList
                                .where((campus) => campus.CAMPUS_NAME
                                    .toLowerCase()
                                    .contains(string.toLowerCase()))
                                .toList());

                            print(signUpController.searchedCampusList);
                            // we use the toLowerCase() method to make it case-insensitive
                          }
                        },
                      )),
                  Obx(() {
                    return signUpController.campusSelected.value
                        ? Container()
                        : LimitedBox(
                            maxHeight: 100.0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                border: Border.all(
                                    color: const Color(0xffeaeaea), width: 1),
                              ),
                              child: Obx(() => CupertinoScrollbar(
                                  isAlwaysShown: true,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: signUpController
                                          .searchedCampusList.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              campusFocus.unfocus();
                                              signUpController
                                                  .campusSelected.value = true;
                                              // * 캠퍼스 선택(이름)
                                              signUpController
                                                      .campusController.text =
                                                  signUpController
                                                      .searchedCampusList[index]
                                                      .CAMPUS_NAME;

                                              // * 캠퍼스 선택(아이디)

                                              signUpController.selectedCampus(
                                                  signUpController
                                                      .searchedCampusList[index]
                                                      .CAMPUS_ID);
                                            },
                                            child: Text(
                                              signUpController
                                                  .searchedCampusList[index]
                                                  .CAMPUS_NAME,
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff2f2f2f),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "NotoSansKR",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 12.0),
                                            ),
                                          ),
                                        );
                                      }))),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
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
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "${e}",
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff2f2f2f),
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
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0.0, bottom: 12.0),
                  child: InkWell(
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        if (signUpController.selectMajorIndexPK(
                                signUpController.selectedMajor.value) ==
                            null) {
                          Get.snackbar(
                              "Major not selected", "Major not selected.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.white,
                              colorText: Colors.black);
                          return;
                        }

                        if (signUpController.selectedMajor.value ==
                            signUpController.selectedDoubleMajor.value) {
                          Get.snackbar("Duplicate Double Major",
                              "Duplicate Double Major",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.white,
                              colorText: Colors.black);
                          return;
                        }

                        // Get.to(
                        //     CommunityRule(
                        //       isSignUp: true,
                        //     ),
                        //     transition: Transition.cupertino);

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
                      // print("${signUpController.selectedMajor.value}");
                      // print(
                      //     "${signUpController.selectDoubleMajorIndexPK(signUpController.selectedMajor.value)}");
                      // print("${signUpController.selectedDoubleMajor.value}");
                      // print(
                      //     "${signUpController.selectDoubleMajorIndexPK(signUpController.selectedDoubleMajor.value)}");
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 100.0),
                  child: Center(
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
                          ..onTap = () => Get.until(
                              (route) => Get.currentRoute == '/login'),
                      )
                    ])),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
