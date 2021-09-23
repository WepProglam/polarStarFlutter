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

  // login 함수

  @override
  Widget build(BuildContext context) {
    // final notiController = Get.put(NotiController());
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 로고 이미지
            Center(
              child: Container(
                  width: 281.2,
                  height: 232.4,
                  margin: EdgeInsets.fromLTRB(2.3, 35.1, 21.5, 20),
                  child: Image.asset("assets/images/636.png")),
            ),

            // 아이디 입력
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Account",
                  style: const TextStyle(
                      color: const Color(0xff999999),
                      fontWeight: FontWeight.normal,
                      fontFamily: "PingFangSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 13.5),
                ),
                Container(
                  width: 305,
                  height: 48.1,
                  child: Stack(
                    children: [
                      TextFormField(
                        controller: loginIdContoller,
                        obscureText: false,
                        validator: (value) {
                          return checkEmpty(value);
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 11.6),
                          hintStyle: const TextStyle(
                              color: const Color(0xff999999),
                              fontWeight: FontWeight.w400,
                              fontFamily: "PingFangSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          hintText: "Enter Your ID",
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
                ),
              ],
            ),

            // 비밀번호 입력
            Padding(
              padding: const EdgeInsets.only(top: 24.6, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Password",
                    style: const TextStyle(
                        color: const Color(0xff999999),
                        fontWeight: FontWeight.normal,
                        fontFamily: "PingFangSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 13.5),
                  ),
                  Stack(
                    children: [
                      Obx(() => TextFormField(
                            controller: loginPwContoller,
                            obscureText: controller.isObscured.value,
                            validator: (value) {
                              return checkEmpty(value);
                            },
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 0.0, vertical: 11.6),
                                hintStyle: const TextStyle(
                                    color: const Color(0xff999999),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "PingFangSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                hintText: "Enter the PW"),
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
            Row(children: [
              Obx(
                () => Checkbox(
                    value: controller.isAutoLogin.value,
                    // splashRadius: 0,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    onChanged: (value) {
                      controller.isAutoLogin(value);
                    }),
              ),
              InkWell(
                  onTap: () {
                    controller.isAutoLogin(!controller.isAutoLogin.value);
                  },
                  child: Text('자동 로그인')),
              Spacer(),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "Having trouble logging in?",
                  style: const TextStyle(
                      color: const Color(0xff333333),
                      fontWeight: FontWeight.bold,
                      fontFamily: "PingFangSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                ),
              ),
            ]),

            // 로그인 버튼
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: InkWell(
                onTap: () async {
                  print(_formKey.currentState.validate());
                  if (_formKey.currentState.validate()) {
                    await controller.login(loginIdContoller.text,
                        loginPwContoller.text, "1123123123");
                    // await userLogin(notiController.tokenFCM.value);
                  }
                },
                child: Ink(
                  width: Get.mediaQuery.size.width - 70,
                  height: 52,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff1a4678)),
                  child: Center(
                      child: Text(
                    "Log in",
                    style: const TextStyle(
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.normal,
                        fontFamily: "PingFangSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 18),
                  )),
                ),
              ),
            ),

            // 회원가입 버튼
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: InkWell(
                onTap: () {
                  Get.toNamed("/signUp");
                },
                child: Ink(
                  width: Get.mediaQuery.size.width - 70,
                  height: 52,
                  decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xff1a4678), width: 2)),
                  child: Center(
                    child: Text(
                      "Sign Up",
                      style: const TextStyle(
                          color: const Color(0xff1a4678),
                          fontWeight: FontWeight.normal,
                          fontFamily: "PingFangSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 18.0),
                    ),
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
