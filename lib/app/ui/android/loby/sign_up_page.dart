import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:polarstar_flutter/app/controller/loby/sign_up_controller.dart';

import 'package:polarstar_flutter/app/ui/android/functions/form_validator.dart';

import 'package:polarstar_flutter/app/ui/android/widgets/custom_text_form_field.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        backgroundColor: Color(0xffffffff),
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 9.4,
              height: 16.7,
              margin: EdgeInsets.only(left: 15, right: 14.6),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Image.asset(
                  "assets/images/978.png",
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Text(
              'Sign Up',
              style: const TextStyle(
                  color: const Color(0xff333333),
                  fontWeight: FontWeight.bold,
                  fontFamily: "PingFangSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 21.0),
            ),
          ],
        ),
      ),
      body: SignUpInputs(),
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
    final emailController = TextEditingController();
    final nicknameController = TextEditingController();
    final studentIDController = TextEditingController();
    final emailCodeController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    final SignUpController signUpController = Get.find();

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: SignUpTextForm(
                        textEditingController: idController,
                        hint: "Please enter the ID",
                        funcValidator: (value) {
                          return checkEmpty(value);
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7.0),
                        child: InkWell(
                          onTap: () {},
                          child: Ink(
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xff1a4678)),
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
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.5),
                child: SignUpTextForm(
                  textEditingController: pwController,
                  hint: "Please enter the password",
                  funcValidator: (value) {
                    return checkEmpty(value);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.5),
                child: SignUpTextForm(
                  textEditingController: pwConfirmController,
                  hint: "Please enter your password",
                  funcValidator: (value) {
                    return checkEmpty(value);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.5),
                child: SignUpTextForm(
                  textEditingController: nicknameController,
                  hint: "Please enter the nickname",
                  funcValidator: (value) {
                    return checkEmpty(value);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.5),
                child: SignUpTextForm(
                  textEditingController: studentIDController,
                  hint: "Please enter the studentID",
                  funcValidator: (value) {
                    return checkEmpty(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: SignUpTextForm(
                        textEditingController: emailController,
                        hint: "Please enter the email",
                        funcValidator: (value) {
                          return checkEmpty(value);
                        },
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7.0),
                        child: InkWell(
                          onTap: () async {
                            signUpController
                                .emailAuthRequest(emailController.text);
                          },
                          child: Ink(
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xff1a4678)),
                            child: Center(
                              child: Text(
                                "Get Code",
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
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: SignUpTextForm(
                        textEditingController: emailCodeController,
                        hint: "Please enter code",
                        funcValidator: (value) {
                          return checkEmpty(value);
                        },
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7.0),
                        child: InkWell(
                          onTap: () async {
                            signUpController.emailAuthVerify(
                                emailController.text, emailCodeController.text);
                          },
                          child: Ink(
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xff1a4678)),
                            child: Center(
                              child: Text(
                                "Verify Code",
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
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 64, bottom: 48),
                child: InkWell(
                  onTap: () async {
                    if (_formKey.currentState.validate()) {
                      await signUpController.signUp(
                          idController.text,
                          pwController.text,
                          nicknameController.text,
                          studentIDController.text);
                    }
                  },
                  child: Ink(
                    width: 305,
                    height: 52,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xff1a4678)),
                    child: Center(
                      child: Text("Sign Up",
                          style: const TextStyle(
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w400,
                              fontFamily: "PingFangSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 18.0),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    style: const TextStyle(
                        color: const Color(0xff333333),
                        fontWeight: FontWeight.w700,
                        fontFamily: "PingFangSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    text: "Already have an account, click "),
                TextSpan(
                  style: const TextStyle(
                      color: const Color(0xff1a4678),
                      fontWeight: FontWeight.w700,
                      fontFamily: "PingFangSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                  text: "Log in",
                  recognizer: TapGestureRecognizer()..onTap = () => Get.back(),
                )
              ]))
            ],
          ),
        ),
      ),
    );
  }
}
