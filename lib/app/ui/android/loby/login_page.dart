import 'package:flutter/material.dart';

import 'package:polarstar_flutter/app/ui/android/functions/form_validator.dart';

import 'package:polarstar_flutter/app/controller/loby/login_controller.dart';

// import 'crypt.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/custom_text_form_field.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff4570ff),
        resizeToAvoidBottomInset: false,
        body: LoginInputs(),
      ),
    );
  }
}

class LoginInputs extends GetView<LoginController> {
  LoginInputs({Key key}) : super(key: key);

  final loginIdContoller = TextEditingController();
  final loginPwContoller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final box = GetStorage();

  final focus = FocusNode();
  // login 함수
  @override
  Widget build(BuildContext context) {
    // final notiController = Get.put(NotiController());
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 로고 이미지
            // Center(
            //   child: Container(
            //       width: 281.2,
            //       height: 232.4,
            //       margin: EdgeInsets.fromLTRB(2.3, 35.1, 21.5, 20),
            //       child: Image.asset("assets/images/636.png")),
            // ),

            // 아이디 입력
            Padding(
              padding: const EdgeInsets.only(top: 331.0, bottom: 14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "Account",
                  //   style: const TextStyle(
                  //       color: const Color(0xff999999),
                  //       fontWeight: FontWeight.normal,
                  //       fontFamily: "PingFangSC",
                  //       fontStyle: FontStyle.normal,
                  //       fontSize: 13.5),
                  // ),
                  Stack(
                    children: [
                      TextFormField(
                        controller: loginIdContoller,
                        obscureText: false,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        onChanged: (e) {
                          // print(MediaQuery.of(context).viewInsets.bottom);
                          // * 유저 키보드 사이즈 저장
                          box.write("keyBoardHeight",
                              MediaQuery.of(context).viewInsets.bottom);
                        },
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(focus),
                        validator: (value) {
                          return checkEmpty(value);
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          hintStyle: const TextStyle(
                              color: const Color(0xff9b9b9b),
                              fontWeight: FontWeight.w500,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          hintText: "输入ID",
                          filled: true,
                          fillColor: const Color(0xffffffff),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(
                                  color: const Color(0xffeaeaea), width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(
                                  color: const Color(0xffeaeaea), width: 1)),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 43.4 - 35),
                            child: Ink(
                              width: 15.3,
                              height: 15.3,
                              child: InkWell(
                                onTap: () {
                                  loginIdContoller.clear();
                                },
                                child: Image.asset(
                                  "assets/images/982.png",
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            // 비밀번호 입력
            Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "Password",
                  //   style: const TextStyle(
                  //       color: const Color(0xff999999),
                  //       fontWeight: FontWeight.normal,
                  //       fontFamily: "PingFangSC",
                  //       fontStyle: FontStyle.normal,
                  //       fontSize: 13.5),
                  // ),
                  Stack(
                    children: [
                      Obx(() => TextFormField(
                            controller: loginPwContoller,
                            obscureText: controller.isObscured.value,
                            textInputAction: TextInputAction.send,
                            focusNode: focus,
                            onFieldSubmitted: (_) async {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState.validate()) {
                                await controller.login(loginIdContoller.text,
                                    loginPwContoller.text);
                                // await userLogin(notiController.tokenFCM.value);
                              }
                            },
                            validator: (value) {
                              return checkEmpty(value);
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              hintStyle: const TextStyle(
                                  color: const Color(0xff9b9b9b),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "NotoSansSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0),
                              hintText: "输入密码",
                              filled: true,
                              fillColor: const Color(0xffffffff),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(
                                    color: const Color(0xffeaeaea), width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(
                                      color: const Color(0xffeaeaea),
                                      width: 1)),
                            ),
                          )),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 43.4 - 35),
                            child: Ink(
                              width: 15.3,
                              height: 15.3,
                              child: InkWell(
                                onTap: () {
                                  controller
                                      .isObscured(!controller.isObscured.value);
                                },
                                child: Image.asset(
                                  "assets/images/eye_off_fill.png",
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            // 자동로그인 선택버튼
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Obx(
                      () => SizedBox(
                        height: 12.0,
                        width: 12.0,
                        child: Transform.scale(
                          scale: 0.7,
                          child: Checkbox(
                              // fillColor: ,
                              checkColor: const Color(0xffd6d4d4),
                              activeColor: const Color(0xffffffff),
                              value: controller.isAutoLogin.value,
                              // splashRadius: 0,
                              // materialTapTargetSize:
                              //     MaterialTapTargetSize.shrinkWrap,
                              // visualDensity: VisualDensity.compact,
                              onChanged: (value) {
                                controller.isAutoLogin(value);
                              }),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: GestureDetector(
                        onTap: () {
                          controller.isAutoLogin(!controller.isAutoLogin.value);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text('自动登录',
                              style: const TextStyle(
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "NotoSansSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 10.0),
                              textAlign: TextAlign.left),
                        )),
                  ),
                  Spacer(),
                  //! 비번찾기 버튼
                  // GestureDetector(
                  //   onTap: () {
                  //     // ! 우선 막음
                  //     // ! email 인증 사용할 때부터
                  //     // Get.toNamed("/findPw");
                  //   },
                  //   child: Text(
                  //     "找回密码",
                  //     style: const TextStyle(
                  //         color: const Color(0xffffffff),
                  //         fontWeight: FontWeight.w400,
                  //         fontFamily: "NotoSansSC",
                  //         fontStyle: FontStyle.normal,
                  //         fontSize: 10.0),
                  //   ),
                  // ),
                ]),

            // 로그인 버튼
            Padding(
              padding: const EdgeInsets.only(top: 68),
              child: InkWell(
                onTap: () async {
                  print(_formKey.currentState.validate());
                  if (_formKey.currentState.validate()) {
                    await controller.login(
                        loginIdContoller.text, loginPwContoller.text);
                    // await userLogin(notiController.tokenFCM.value);
                  }
                },
                child: Ink(
                  height: 40.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border:
                          Border.all(color: const Color(0xffeaeaea), width: 1),
                      color: const Color(0x4dffffff)),
                  child: Center(
                      child: Text("登录",
                          style: const TextStyle(
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w700,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          textAlign: TextAlign.center)),
                ),
              ),
            ),

            // 회원가입 버튼
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: InkWell(
                onTap: () {
                  Get.toNamed("/signUpMajor");
                },
                child: Ink(
                  height: 40.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border:
                          Border.all(color: const Color(0xffeaeaea), width: 1)),
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
          ],
        ),
      ),
    );
  }
}
