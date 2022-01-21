import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:polarstar_flutter/app/controller/loby/sign_up_controller.dart';
import 'package:polarstar_flutter/app/data/model/sign_up_model.dart';

import 'package:polarstar_flutter/app/ui/android/functions/form_validator.dart';

import 'package:polarstar_flutter/app/ui/android/widgets/custom_text_form_field.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        body: SignUpInputs(),
      ),
    );
  }
}

class SignUpInputs extends StatelessWidget {
  const SignUpInputs({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final idController = TextEditingController();
    final pwController = TextEditingController();
    final pwConfirmController = TextEditingController();
    //final emailController = TextEditingController();
    final nicknameController = TextEditingController();
    final studentIDController = TextEditingController();
    //final emailCodeController = TextEditingController();
    final majorController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    final SignUpController signUpController = Get.find();
    final signUpScrollController = ScrollController(initialScrollOffset: 0.0);

    return SingleChildScrollView(
      controller: signUpScrollController,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Text("ID 重复确认",
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
                child: Stack(
                  children: [
                    SignUpTextForm(
                      textEditingController: idController,
                      hint: "Please enter the ID",
                      funcValidator: (value) {
                        return checkEmpty(value);
                      },
                    ),
                    Positioned(
                      right: 10.0,
                      top: 7.5,
                      child: InkWell(
                        onTap: () async {
                          signUpController.IDTest(idController.text);
                        },
                        child: Ink(
                          height: 24.0,
                          width: 52.0,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              color: const Color(0xff4570ff)),
                          child: Center(
                            child: Text(
                              "Test",
                              style: const TextStyle(
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "PingFangSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text("代码ID不重复，可以使用",
                  style: const TextStyle(
                      color: const Color(0xff9b9b9b),
                      fontWeight: FontWeight.w500,
                      fontFamily: "NotoSansSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 10.0),
                  textAlign: TextAlign.left),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 8.5),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         flex: 4,
              //         child: SignUpTextForm(
              //           textEditingController: idController,
              //           hint: "Please enter the ID",
              //           funcValidator: (value) {
              //             return checkEmpty(value);
              //           },
              //         ),
              //       ),
              //       Expanded(
              //         flex: 1,
              //         child: Padding(
              //           padding: const EdgeInsets.only(left: 7.0),
              //           child: InkWell(
              //             onTap: () async {
              //               signUpController.IDTest(idController.text);
              //             },
              //             child: Ink(
              //               height: 40,
              //               decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(10),
              //                   color: const Color(0xff1a4678)),
              //               child: Center(
              //                 child: Text(
              //                   "Test",
              //                   style: const TextStyle(
              //                       color: const Color(0xffffffff),
              //                       fontWeight: FontWeight.w400,
              //                       fontFamily: "PingFangSC",
              //                       fontStyle: FontStyle.normal,
              //                       fontSize: 16.0),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text("输入密码",
                    style: const TextStyle(
                        color: const Color(0xff4570ff),
                        fontWeight: FontWeight.w500,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.left),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 8.0),
                child: SignUpTextForm(
                  textEditingController: pwController,
                  hint: "Please enter the password",
                  funcValidator: (value) {
                    return checkEmpty(value);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 18.0),
                child: SignUpTextForm(
                  textEditingController: pwConfirmController,
                  hint: "Please confirm your password",
                  funcValidator: (value) {
                    return checkEmpty(value);
                  },
                ),
              ),

              Text("请设置昵称",
                  style: const TextStyle(
                      color: const Color(0xff4570ff),
                      fontWeight: FontWeight.w500,
                      fontFamily: "NotoSansSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  textAlign: TextAlign.left),
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 18.0),
                child: SignUpTextForm(
                  textEditingController: nicknameController,
                  hint: "Please enter the nickname",
                  funcValidator: (value) {
                    return checkEmpty(value);
                  },
                ),
              ),

              Text("主要的",
                  style: const TextStyle(
                      color: const Color(0xff4570ff),
                      fontWeight: FontWeight.w500,
                      fontFamily: "NotoSansSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  textAlign: TextAlign.left),
              Container(
                  margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: TextFormField(
                    onTap: () async {
                      await Future.delayed(Duration(milliseconds: 500));
                      signUpScrollController.animateTo(
                          signUpScrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn);
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
                    controller: majorController,
                    onChanged: (string) {
                      if (string.isEmpty) {
                        // if the search field is empty or only contains white-space, we'll display all users
                        signUpController.searchedMajorList.value = [];
                      } else {
                        signUpController.searchedMajorList(signUpController
                            .majorList
                            .where((major) => major.NAME
                                .toLowerCase()
                                .contains(string.toLowerCase()))
                            .toList());
                        // we use the toLowerCase() method to make it case-insensitive
                      }
                    },
                  )),
              LimitedBox(
                maxHeight: 100.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border:
                        Border.all(color: const Color(0xffeaeaea), width: 1),
                  ),
                  child: Obx(() => ListView.builder(
                      shrinkWrap: true,
                      itemCount: signUpController.searchedMajorList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              majorController.text = signUpController
                                  .searchedMajorList[index].NAME;
                              signUpController.selectedMajor(signUpController
                                  .searchedMajorList[index].INDEX);
                            },
                            child: Text(
                              signUpController.searchedMajorList[index].NAME,
                              style: const TextStyle(
                                  color: const Color(0xff2f2f2f),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "NotoSansKR-Medium",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                            ),
                          ),
                        );
                      })),
                ),
              ),

              // Container(
              //     margin: const EdgeInsets.symmetric(vertical: 8.5),
              //     child: Row(children: [
              //       Container(
              //         width: 100,
              //         child: Obx(() {
              //           return DropdownButton(
              //             hint: Text("전공을 선택해주세요"),
              //             value: signUpController.selectedCollege.value,
              //             isExpanded: true,
              //             items: [
              //               for (CollegeMajorModel item
              //                   in signUpController.collegeList)
              //                 DropdownMenuItem(
              //                   child: Center(
              //                     child: Text("${item.NAME}"),
              //                   ),
              //                   value: item.INDEX,
              //                 ),
              //             ],
              //             onChanged: (value) {
              //               signUpController.selectedCollege.value = value;
              //             },
              //           );
              //         }),
              //       ),
              //       Container(
              //         width: 100,
              //         margin: const EdgeInsets.only(left: 100),
              //         child: Obx(() {
              //           return DropdownButton(
              //             hint: Text("전공을 선택해주세요"),
              //             value: signUpController.selectedMajor.value,
              //             isExpanded: true,
              //             items: [
              //               for (CollegeMajorModel item
              //                   in signUpController.matchMajorList)
              //                 DropdownMenuItem(
              //                   child: Center(
              //                     child: Text("${item.NAME}"),
              //                   ),
              //                   value: item.INDEX,
              //                 ),
              //             ],
              //             onChanged: (value) {
              //               signUpController.selectedMajor.value = value;
              //             },
              //           );
              //         }),
              //       ),
              //     ])),
              // Container(
              //   margin: const EdgeInsets.symmetric(vertical: 8.5),
              //   child: SignUpTextForm(
              //     textEditingController: studentIDController,
              //     hint: "Please enter the studentID",
              //     funcValidator: (value) {
              //       return checkEmpty(value);
              //     },
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 8.5),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         flex: 5,
              //         child: SignUpTextForm(
              //           textEditingController: emailController,
              //           hint: "Please enter the email",
              //           funcValidator: (value) {
              //             return checkEmpty(value);
              //           },
              //         ),
              //       ),
              //       Expanded(
              //         flex: 2,
              //         child: Padding(
              //           padding: const EdgeInsets.only(left: 7.0),
              //           child: InkWell(
              //             onTap: () async {
              //               signUpController
              //                   .emailAuthRequest(emailController.text);
              //             },
              //             child: Ink(
              //               height: 40,
              //               decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(10),
              //                   color: const Color(0xff1a4678)),
              //               child: Center(
              //                 child: Text(
              //                   "Get Code",
              //                   style: const TextStyle(
              //                       color: const Color(0xffffffff),
              //                       fontWeight: FontWeight.w400,
              //                       fontFamily: "PingFangSC",
              //                       fontStyle: FontStyle.normal,
              //                       fontSize: 16.0),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 8.5),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         flex: 5,
              //         child: SignUpTextForm(
              //           textEditingController: emailCodeController,
              //           hint: "Please enter code",
              //           funcValidator: (value) {
              //             return checkEmpty(value);
              //           },
              //         ),
              //       ),
              //       Expanded(
              //         flex: 2,
              //         child: Padding(
              //           padding: const EdgeInsets.only(left: 7.0),
              //           child: InkWell(
              //             onTap: () async {
              //               signUpController.emailAuthVerify(
              //                   emailController.text, emailCodeController.text);
              //             },
              //             child: Ink(
              //               height: 40,
              //               decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(10),
              //                   color: const Color(0xff1a4678)),
              //               child: Center(
              //                 child: Text(
              //                   "Verify Code",
              //                   style: const TextStyle(
              //                       color: const Color(0xffffffff),
              //                       fontWeight: FontWeight.w400,
              //                       fontFamily: "PingFangSC",
              //                       fontStyle: FontStyle.normal,
              //                       fontSize: 16.0),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 48.0, bottom: 12.0),
                child: InkWell(
                  onTap: () async {
                    if (_formKey.currentState.validate()) {
                      if (signUpController.selectIndexPK(
                              signUpController.selectedMajor.value) ==
                          null) {
                        Get.snackbar("회원 가입 오류", "전공이 잘못 선택되었습니다.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.black,
                            colorText: Colors.white);
                        return;
                      }
                      await signUpController.signUp(
                          idController.text,
                          pwController.text,
                          nicknameController.text,
                          studentIDController.text,
                          signUpController.selectIndexPK(
                              signUpController.selectedMajor.value));
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
                      child: Text("注册会员",
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
                      text: "如果有账号, "),
                  TextSpan(
                    style: const TextStyle(
                        color: const Color(0xff4570ff),
                        fontWeight: FontWeight.w500,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 10.0),
                    text: "请登录",
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
