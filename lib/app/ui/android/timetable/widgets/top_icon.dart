import 'package:flutter/material.dart';

class TopIcon extends StatelessWidget {
  const TopIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 15),
          child: Text("Third Grade",
              style: const TextStyle(
                  color: const Color(0xff333333),
                  fontWeight: FontWeight.w700,
                  fontFamily: "PingFangSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 21.0),
              textAlign: TextAlign.left),
        ),
        Container(
          margin: const EdgeInsets.only(left: 12, top: 14.8, bottom: 7.3),
          child: // 패스 940
              Container(
            width: 10.68267822265625,
            height: 5.931396484375,
            child: Image.asset(
              "assets/images/940.png",
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        Spacer(),
        Container(
          margin: const EdgeInsets.only(top: 9.7, bottom: 2.3, right: 15),
          child: // 패스 940
              Container(
            width: 16,
            height: 16,
            child: Image.asset(
              "assets/images/941.png",
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 9.7, bottom: 2.3, right: 15),
          child: // 패스 940
              Container(
            width: 16,
            height: 16,
            child: Image.asset(
              "assets/images/17_2.png",
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 9.7, bottom: 2.3, right: 15),
          child: // 패스 940
              Container(
            width: 16,
            height: 16,
            child: Image.asset(
              "assets/images/16_12.png",
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ],
    );
  }
}
