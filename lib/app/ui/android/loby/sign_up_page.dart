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
    final SignUpController signUpController = Get.find();

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xffffffff),
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
        body: SignUpInputs(
          signUpController: signUpController,
        ),
      ),
    );
  }
}

class SignUpInputs extends StatelessWidget {
  const SignUpInputs({Key key, this.signUpController}) : super(key: key);
  final SignUpController signUpController;

  @override
  Widget build(BuildContext context) {
    //final emailCodeController = TextEditingController();

    final _formKey = GlobalKey<FormState>();
    final _idKey = GlobalKey<FormState>();
    final _pwConfirmKey = GlobalKey<FormState>();
    final _nicknameKey = GlobalKey<FormState>();

    final _idFocusNode = FocusNode();
    final _nicknameFocusNode = FocusNode();

    final signUpScrollController = ScrollController(initialScrollOffset: 0.0);

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              controller: signUpScrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Text("设置ID",
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
                        Form(
                          key: _idKey,
                          child: SignUpTextForm(
                            focusNode: _idFocusNode,
                            onchange: (String value) {
                              signUpController.idOK.value = false;
                            },
                            textEditingController:
                                signUpController.idController,
                            obscureText: false,
                            hint: "请设置ID",
                            funcValidator: (String value) {
                              if (value.isEmpty ||
                                  signUpController.idOK.value == false) {
                                return "此ID已被注册，换一个再试试吧!";
                              }
                              // return checkEmpty(value);
                            },
                          ),
                        ),
                        Positioned(
                          right: 10.0,
                          top: 7.5,
                          child: InkWell(
                            onTap: () async {
                              _idFocusNode.unfocus();
                              await signUpController.IDTest(
                                  signUpController.idController.text);
                              _idKey.currentState.validate();
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
                                  "验证",
                                  style: const TextStyle(
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "NotoSansSC",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    return signUpController.idOK.value
                        ? Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, top: 6.0),
                            child: Text("此ID未被注册，可以使用!",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "NotoSansSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 10.0),
                                textAlign: TextAlign.left),
                          )
                        : Container();
                  }),
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
                    child: Text("设置密码",
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
                      textEditingController: signUpController.pwController,
                      obscureText: true,
                      hint: "请输入密码",
                      funcValidator: (String value) {
                        return checkEmpty(value);
                      },
                    ),
                  ),
                  Form(
                    key: _pwConfirmKey,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 18.0),
                      child: SignUpTextForm(
                        textEditingController:
                            signUpController.pwConfirmController,
                        obscureText: true,
                        hint: "请再次输入密码",
                        onchange: (String value) {
                          _pwConfirmKey.currentState.validate();
                        },
                        funcValidator: (String value) {
                          if (signUpController.pwController.text !=
                              signUpController.pwConfirmController.text) {
                            return "密码不一致";
                          }
                          // return checkEmpty(value);
                        },
                      ),
                    ),
                  ),

                  Text("设置昵称",
                      style: const TextStyle(
                          color: const Color(0xff4570ff),
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),
                  Stack(children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10.0, bottom: 4.0),
                      child: Form(
                        key: _nicknameKey,
                        child: SignUpTextForm(
                          focusNode: _nicknameFocusNode,
                          onchange: (String value) {
                            signUpController.nicknameOK.value = false;
                          },
                          textEditingController:
                              signUpController.nicknameController,
                          obscureText: false,
                          hint: "请设置昵称",
                          funcValidator: (String value) {
                            if (value.isEmpty ||
                                signUpController.nicknameOK.value == false) {
                              return "此昵称已被注册，换一个再试试吧!";
                            }
                            // return checkEmpty(value);
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10.0,
                      top: 20,
                      child: InkWell(
                        onTap: () async {
                          _nicknameFocusNode.unfocus();
                          await signUpController.nicknameTest(
                              signUpController.nicknameController.text);
                          _nicknameKey.currentState.validate();
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
                              "验证",
                              style: const TextStyle(
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "NotoSansSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                  Obx(() {
                    return signUpController.nicknameOK.value
                        ? Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, top: 6.0),
                            child: Text("此昵称未被注册，可以使用!",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "NotoSansSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 10.0),
                                textAlign: TextAlign.left),
                          )
                        : Container();
                  }),

                  // Container(
                  //   margin: const EdgeInsets.only(top: 18),
                  //   child: Text("选择专业",
                  //       style: const TextStyle(
                  //           color: const Color(0xff4570ff),
                  //           fontWeight: FontWeight.w500,
                  //           fontFamily: "NotoSansSC",
                  //           fontStyle: FontStyle.normal,
                  //           fontSize: 14.0),
                  //       textAlign: TextAlign.left),
                  // ),
                  // Container(
                  //     margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  //     child: TextFormField(
                  //       onTap: () async {
                  //         await Future.delayed(Duration(milliseconds: 100));
                  //         signUpScrollController.animateTo(
                  //             signUpScrollController.position.maxScrollExtent,
                  //             duration: Duration(milliseconds: 100),
                  //             curve: Curves.fastOutSlowIn);
                  //         signUpController.majorSelected.value = false;
                  //       },
                  //       style: const TextStyle(
                  //           color: const Color(0xff2f2f2f),
                  //           fontWeight: FontWeight.w400,
                  //           fontFamily: "Roboto",
                  //           fontStyle: FontStyle.normal,
                  //           fontSize: 14.0),
                  //       textAlign: TextAlign.left,
                  //       decoration: InputDecoration(
                  //           contentPadding:
                  //               EdgeInsets.fromLTRB(10.0, 11.0, 10.0, 11.0),
                  //           isDense: true,
                  //           hintText: "Search Your Major",
                  //           hintStyle: const TextStyle(
                  //               color: const Color(0xffd6d4d4),
                  //               fontWeight: FontWeight.w400,
                  //               fontFamily: "Roboto",
                  //               fontStyle: FontStyle.normal,
                  //               fontSize: 14.0),
                  //           enabledBorder: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(8),
                  //               borderSide: BorderSide(
                  //                   color: const Color(0xffeaeaea), width: 1)),
                  //           focusedBorder: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(8),
                  //               borderSide: BorderSide(
                  //                   color: const Color(0xffeaeaea), width: 1)),
                  //           border: InputBorder.none),
                  //       controller: majorController,
                  //       onChanged: (string) {
                  //         if (string.isEmpty) {
                  //           // if the search field is empty or only contains white-space, we'll display all users
                  //           signUpController.searchedMajorList.value = [];
                  //         } else {
                  //           signUpController.searchedMajorList(signUpController
                  //               .majorList
                  //               .where((major) => major.MAJOR_NAME
                  //                   .toLowerCase()
                  //                   .contains(string.toLowerCase()))
                  //               .toList());
                  //           // we use the toLowerCase() method to make it case-insensitive
                  //         }
                  //       },
                  //     )),

                  // Obx(() {
                  //   return signUpController.majorSelected.value
                  //       ? Container()
                  //       : LimitedBox(
                  //           maxHeight: 100.0,
                  //           child: Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.all(Radius.circular(8)),
                  //               border: Border.all(
                  //                   color: const Color(0xffeaeaea), width: 1),
                  //             ),
                  //             child: Obx(() => ListView.builder(
                  //                 shrinkWrap: true,
                  //                 itemCount:
                  //                     signUpController.searchedMajorList.length,
                  //                 itemBuilder: (context, index) {
                  //                   return Padding(
                  //                     padding: const EdgeInsets.all(8.0),
                  //                     child: InkWell(
                  //                       onTap: () {
                  //                         signUpController.majorSelected.value =
                  //                             true;
                  //                         majorController.text = signUpController
                  //                             .searchedMajorList[index].MAJOR_NAME;
                  //                         signUpController.selectedMajor(
                  //                             signUpController
                  //                                 .searchedMajorList[index]
                  //                                 .MAJOR_ID);
                  //                       },
                  //                       child: Text(
                  //                         signUpController
                  //                             .searchedMajorList[index].MAJOR_NAME,
                  //                         style: const TextStyle(
                  //                             color: const Color(0xff2f2f2f),
                  //                             fontWeight: FontWeight.w500,
                  //                             fontFamily: "NotoSansKR",
                  //                             fontStyle: FontStyle.normal,
                  //                             fontSize: 12.0),
                  //                       ),
                  //                     ),
                  //                   );
                  //                 })),
                  //           ),
                  //         );
                  // }),

                  // Padding(
                  //   padding: const EdgeInsets.only(top: 12),
                  //   child: Text("入学年份",
                  //       style: const TextStyle(
                  //           color: const Color(0xff4570ff),
                  //           fontWeight: FontWeight.w500,
                  //           fontFamily: "NotoSansSC",
                  //           fontStyle: FontStyle.normal,
                  //           fontSize: 14.0),
                  //       textAlign: TextAlign.left),
                  // ),
                  // Padding(
                  //     padding: const EdgeInsets.only(top: 10.0, bottom: 2.0),
                  //     child: Builder(builder: (context) {
                  //       List<int> addmissionYear = [
                  //         for (var i = 0; i < 13; i++) 2010 + i
                  //       ];
                  //       // addmissionYear = addmissionYear.reversed.toList();
                  //       return Obx(() {
                  //         return DecoratedBox(
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.all(Radius.circular(8)),
                  //             border: Border.all(
                  //                 color: const Color(0xffeaeaea), width: 1),
                  //           ),
                  //           child: DropdownButton(
                  //               underline: Container(),
                  //               isExpanded: true,
                  //               value: signUpController.admissionYear.value,
                  //               items: addmissionYear
                  //                   .map((e) => DropdownMenuItem(
                  //                         child: Container(
                  //                           margin: const EdgeInsets.only(left: 10),
                  //                           child: Text(
                  //                             "${e}",
                  //                             style: const TextStyle(
                  //                                 color: const Color(0xff2f2f2f),
                  //                                 fontWeight: FontWeight.w400,
                  //                                 fontFamily: "Roboto",
                  //                                 fontStyle: FontStyle.normal,
                  //                                 fontSize: 14.0),
                  //                           ),
                  //                         ),
                  //                         value: e,
                  //                       ))
                  //                   .toList(),
                  //               onChanged: (val) {
                  //                 signUpController.admissionYear.value = val;
                  //               }),
                  //         );
                  //       });
                  //     })

                  //     // SignUpTextForm(
                  //     //   onchange: (value) {
                  //     //     signUpController.idOK.value = false;
                  //     //   },
                  //     //   textEditingController: idController,
                  //     //   obscureText: false,
                  //     //   hint: "请输入入学年份",
                  //     //   funcValidator: (value) {
                  //     //     return checkEmpty(value);
                  //     //   },
                  //     // ),
                  //     ),

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
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0.0, bottom: 12.0),
                  child: InkWell(
                    onTap: () async {
                      if (_formKey.currentState.validate() &&
                          _idKey.currentState.validate() &&
                          _pwConfirmKey.currentState.validate() &&
                          _nicknameKey.currentState.validate() &&
                          signUpController.idOK.value &&
                          signUpController.nicknameOK.value) {
                        if (signUpController.selectIndexPK(
                                signUpController.selectedMajor.value) ==
                            null) {
                          Get.snackbar("注册错误", "专业选择错误",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.black.withOpacity(0.0),
                              colorText: Colors.white);
                          return;
                        }
                        await signUpController.signUp(
                            signUpController.idController.text,
                            signUpController.pwController.text,
                            signUpController.nicknameController.text,
                            signUpController.studentIDController.text,
                            signUpController.selectIndexPK(
                                signUpController.selectedMajor.value),
                            signUpController.admissionYear.value);
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
