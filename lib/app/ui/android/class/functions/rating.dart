import 'package:flutter/material.dart';

List<Widget> rate_star(String AVG_RATE, double size) {
  List<Widget> retList = [];
  double rate = double.parse(AVG_RATE);
  for (int i = 0; i < 5; i++) {
    print(rate - i);
    String image_path = "assets/images/star_100.png";
    if (rate - i >= 1) {
      image_path = "assets/images/star_100.png";
    } else if ((rate - i) < 1 && (rate - i) >= 0) {
      image_path = "assets/images/star_${((rate - i) * 10).floor() * 10}.png";
    } else {
      image_path = "assets/images/star_0.png";
    }
    retList.add(Container(
      width: size,
      height: size,
      child: Image.asset(
        image_path,
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
        img = "star_0";
        break;
      case "0.1":
        img = "star_10";
        break;
      case "0.2":
        img = "star_20";
        break;
      case "0.3":
        img = "star_30";
        break;
      case "0.4":
        img = "star_40";
        break;
      case "0.5":
        img = "star_50";
        break;
      case "0.6":
        img = "star_60";
        break;
      case "0.7":
        img = "star_70";
        break;
      case "0.8":
        img = "star_80";
        break;
      case "0.9":
        img = "star_90";
        break;
      case "1.0":
        img = "star_100";
        break;
      default:
        img = "star_0";
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
