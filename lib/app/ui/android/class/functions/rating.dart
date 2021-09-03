import 'package:flutter/material.dart';

List<Widget> rate_star(String AVG_RATE, double size) {
  List<Widget> retList = [];
  for (int i = 0; i < 5; i++) {
    retList.add(Container(
      width: size,
      height: size,
      child: Image.asset(
        i + 1 <= double.parse(AVG_RATE)
            ? 'assets/images/897.png'
            : 'assets/images/898.png',
        fit: BoxFit.fitHeight,
      ),
    ));
  }
  return retList;
}

List<Widget> rate_heart(String AVG_RATE, double size) {
  List<Widget> retList = [];
  for (int i = 0; i < 5; i++) {
    retList.add(Container(
      width: size,
      height: size,
      child: Image.asset(
        i + 1 <= double.parse(AVG_RATE)
            ? 'assets/images/897.png'
            : 'assets/images/898.png',
        fit: BoxFit.fitHeight,
      ),
    ));
  }
  return retList;
}
