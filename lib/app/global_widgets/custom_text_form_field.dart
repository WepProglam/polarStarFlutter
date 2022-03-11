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
      @required this.funcValidator,
      @required this.obscureText,
      this.onchange,
      this.focusNode})
      : super(key: key);

  final TextEditingController textEditingController;
  final String hint;
  final funcValidator;
  final bool obscureText;
  final Function onchange;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onchange,
      focusNode: focusNode,
      controller: textEditingController,
      validator: funcValidator,
      obscureText: obscureText,
      style: const TextStyle(
          color: const Color(0xff4570ff),
          fontWeight: FontWeight.w400,
          fontFamily: "Roboto",
          fontStyle: FontStyle.normal,
          fontSize: 14.0),
      textAlign: TextAlign.left,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 11.0, 10.0, 11.0),
          isDense: true,
          hintText: hint,
          hintStyle: const TextStyle(
              color: const Color(0xffd6d4d4),
              fontWeight: FontWeight.w400,
              fontFamily: "Roboto",
              fontStyle: FontStyle.normal,
              fontSize: 14.0),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xffeaeaea), width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xffeaeaea), width: 1)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xffeaeaea), width: 1)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xffeaeaea), width: 1)),
          errorStyle: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w500,
              fontFamily: "NotoSansSC",
              fontStyle: FontStyle.normal,
              fontSize: 10.0)),
    );
  }
}