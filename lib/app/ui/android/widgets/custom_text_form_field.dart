import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {Key key,
      @required this.textController,
      @required this.hint,
      @required this.funcValidator})
      : super(key: key);

  final TextEditingController textController;
  final String hint;
  final funcValidator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        obscureText:
            hint == "Enter Your PASSWORD" || hint == "PW" ? true : false,
        validator: funcValidator,
        controller: textController,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
            hintText: hint,
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            errorBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            focusedErrorBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      ),
    );
  }
}

class SignUpTextForm extends StatelessWidget {
  const SignUpTextForm(
      {Key key,
      @required this.textEditingController,
      @required this.hint,
      @required this.funcValidator})
      : super(key: key);

  final TextEditingController textEditingController;
  final String hint;
  final funcValidator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      validator: funcValidator,
      style: const TextStyle(
        color: const Color(0xff333333),
        fontWeight: FontWeight.w400,
        fontFamily: "PingFangSC",
        fontStyle: FontStyle.normal,
        fontSize: 14.0,
      ),
      textAlign: TextAlign.left,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(13.5, 9.5, 13.5, 12),
          isDense: true,
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: const Color(0xff1a4678), width: 2))),
    );
  }
}
