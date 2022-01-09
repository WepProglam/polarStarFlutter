import 'package:flutter/material.dart';

List<Widget> rate_star(String AVG_RATE, double size) {
  List<Widget> retList = [];
  for (int i = 0; i < 5; i++) {
    retList.add(Container(
      width: size,
      height: size,
      child: Image.asset(
        i + 1 <= double.parse(AVG_RATE)
            ? 'assets/images/icn_star_selected_fill.png'
            : 'assets/images/icn_star_normal_white.png',
        fit: BoxFit.fitHeight,
      ),
    ));
  }
  return retList;
}

List<Widget> rate_heart(String AVG_RATE, double size) {
  List<Widget> retList = [];
  double rate = double.parse(AVG_RATE);
  for (int i = 0; i < 5; i++) {
    double fraction;
    if (rate - (i) > 1) {
      fraction = 1.0;
    } else if (rate - (i) <= -1) {
      fraction = 0.0;
    } else {
      fraction = rate - (i);
    }
    String img;
    switch (fraction.toString()) {
      case "0.0":
        img = "687";
        break;
      case "0.1":
        img = "688";
        break;
      case "0.2":
        img = "675";
        break;
      case "0.3":
        img = "674";
        break;
      case "0.4":
        img = "673";
        break;
      case "0.5":
        img = "672";
        break;
      case "0.6":
        img = "678";
        break;
      case "0.7":
        img = "681";
        break;
      case "0.8":
        img = "726";
        break;
      case "0.9":
        img = "725";
        break;
      case "1.0":
        img = "733";
        break;
      default:
        img = "733";
        break;
    }
    retList.add(Container(
      width: size,
      height: size,
      child: Image.asset(
        "assets/images/" + img + ".png",
        fit: BoxFit.fitHeight,
      ),
    ));
  }
  return retList;
}
