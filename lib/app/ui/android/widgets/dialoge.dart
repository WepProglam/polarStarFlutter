import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> TFdialogue(BuildContext context) async {
  await showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          //Dialog Main Title
          title: Column(
            children: <Widget>[
              new Text("Dialog Title"),
            ],
          ),
          //
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Dialog Content",
              ),
            ],
          ),

          actions: <Widget>[
            TextButton(
              child: new Text("否"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: new Text("是"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}
