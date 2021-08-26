import 'package:flutter/material.dart';
import 'package:polarstar_flutter/app/ui/android/functions/form_validator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/custom_text_form_field.dart';
import '';

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
                onPressed: () {
                  if (_formKey.currentState.validate()) {}
                },
                child: Text("Sign Up"))
          ],
        ),
      ),
    );
  }
}
