import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:polarstar_flutter/app/controller/sign_up/sign_up_controller.dart';

import 'package:polarstar_flutter/app/ui/android/functions/form_validator.dart';

import 'package:polarstar_flutter/app/ui/android/widgets/custom_text_form_field.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SignUpInputs(),
    );
  }
}

class SignUpInputs extends StatelessWidget {
  const SignUpInputs({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signUpIdController = TextEditingController();
    final signUpPwController = TextEditingController();
    final signUpNicknameController = TextEditingController();
    final signUpStudentIDController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    final SignUpController signUpController = Get.find();

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextFormField(
              hint: "ID",
              textController: signUpIdController,
              funcValidator: (value) {
                return checkEmpty(value);
              },
            ),
            CustomTextFormField(
              hint: "PW",
              textController: signUpPwController,
              funcValidator: (value) {
                return checkEmpty(value);
              },
            ),
            CustomTextFormField(
              hint: "Nickname",
              textController: signUpNicknameController,
              funcValidator: (value) {
                return checkEmpty(value);
              },
            ),
            CustomTextFormField(
              hint: "Student ID",
              textController: signUpStudentIDController,
              funcValidator: (value) {
                return checkEmpty(value);
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    await signUpController.signUp(
                        signUpIdController.text,
                        signUpPwController.text,
                        signUpNicknameController.text,
                        signUpStudentIDController.text);
                  }
                },
                child: Text("Sign Up"))
          ],
        ),
      ),
    );
  }
}
