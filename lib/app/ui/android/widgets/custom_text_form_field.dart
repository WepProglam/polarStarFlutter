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
