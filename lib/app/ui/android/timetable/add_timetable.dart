import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/add_class.dart';

class TimeTableAdd extends StatelessWidget {
  TimeTableAdd({Key key}) : super(key: key);

  final TimeTableController timeTableController = Get.find();
  final _formKey = GlobalKey<FormState>();
  final _formKeyDrop = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    timeTableController.addTimeTableYearSem.value =
        timeTableController.addTimeTableYearSemList.last;

    return SafeArea(
        child: GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xfff6f6f6),
          body: SingleChildScrollView(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 30.5,
                  child: Container(
                    child: Row(
                      children: [
                        // 패스 844
                        Container(
                          margin: const EdgeInsets.only(top: 6.5, bottom: 7.3),
                          padding: const EdgeInsets.only(right: 14.6),
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Image.asset("assets/images/891.png"),
                          ),
                        ),
                        Container(
                          width: 145.5,
                          height: 28,
                          margin: const EdgeInsets.only(bottom: 2.5),
                          child: Text("Add Timetable",
                              style: const TextStyle(
                                  color: const Color(0xff333333),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "PingFangSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 21.0),
                              textAlign: TextAlign.left),
                        ),
                        Spacer(),
                        Container(
                            margin: const EdgeInsets.only(top: 2.5),
                            height: 28,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(28)),
                                color: const Color(0xffdceafa)),
                            child: // 사각형 409
                                // complete
                                InkWell(
                              onTap: () async {
                                await timeTableController.createTimeTable(
                                    timeTableController.createYear.value,
                                    timeTableController.createSemester.value,
                                    timeTableController.createName.value);

                                Get.snackbar("complete", "complete");
                              },
                              child: Container(
                                height: 28,
                                width: 74.5,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 4, bottom: 5.5, left: 7.5, right: 7),
                                  child: FittedBox(
                                    child: Text("Complete",
                                        style: const TextStyle(
                                            color: const Color(0xff1a4678),
                                            fontWeight: FontWeight.w900,
                                            fontFamily: "PingFangSC",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0),
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 19),
                  height: 67.1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 21.5,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Text("Schedule name",
                            style: const TextStyle(
                                color: const Color(0xff333333),
                                fontWeight: FontWeight.w700,
                                fontFamily: "PingFangSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0),
                            textAlign: TextAlign.center),
                      ),
                      Container(
                        height: 18.5,
                        child: TextFormField(
                          key: _formKey,
                          onChanged: (value) {
                            timeTableController.createName.value = value;
                          },
                          maxLines: 1,
                          style: textStyle,
                          textAlign: TextAlign.left,
                          decoration: inputDecoration("schedule"),
                        ),
                      ),
                      // 선 41
                      Container(
                          height: 0.5,
                          margin: const EdgeInsets.only(top: 14.3),
                          decoration:
                              BoxDecoration(color: const Color(0xffdedede)))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Text("Semester",
                            style: const TextStyle(
                                color: const Color(0xff333333),
                                fontWeight: FontWeight.w700,
                                fontFamily: "PingFangSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0),
                            textAlign: TextAlign.center),
                      ),
                      Container(
                          child: // Please enter a schedule name
                              SelectSem(
                                  formKeyDrop: _formKeyDrop,
                                  timeTableController: timeTableController)),
                      // 선 41
                      Container(
                          height: 0.5,
                          margin: const EdgeInsets.only(top: 14.3),
                          decoration:
                              BoxDecoration(color: const Color(0xffdedede)))
                    ],
                  ),
                )
              ],
            ),
          ))),
    ));
  }
}

class SelectSem extends StatelessWidget {
  const SelectSem({
    Key key,
    @required GlobalKey<FormState> formKeyDrop,
    @required this.timeTableController,
  })  : _formKeyDrop = formKeyDrop,
        super(key: key);

  final GlobalKey<FormState> _formKeyDrop;
  final TimeTableController timeTableController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownButton(
          isExpanded: true,
          isDense: true,
          key: _formKeyDrop,
          underline: Container(),
          value: timeTableController.addTimeTableYearSem.value,
          icon: Container(
            height: 18.5,
            child: Container(
              width: 10.682647705078125,
              height: 5.931396484375,
              margin: const EdgeInsets.only(top: 10, bottom: 2.6, right: 6.6),
              child: Image.asset("assets/images/940.png"),
            ),
          ),
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onChanged: (value) {
            print("변경 _ ${value}");

            bool isNormal = setCreateNormal(value.split("년 ")[1])[0];
            String sem = setCreateNormal(value.split("년 ")[1])[1];

            print(sem);

            if (isNormal) {
              timeTableController.addTimeTableYearSem.value = value;

              timeTableController.createYear.value = value.split("년 ")[0];
              timeTableController.createSemester.value = "${sem}";
            } else {
              Get.snackbar("1학기, 여름학기, 2학기, 겨울학기 중 선택해주세요",
                  "1학기, 여름학기, 2학기, 겨울학기 중 선택해주세요");
            }
          },
          items: timeTableController.addTimeTableYearSemList
              .map((element) => DropdownMenuItem(
                    child: FittedBox(
                        child: Text(
                      "${element}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontFamily: "PingFangSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                    )),
                    value: "${element}",
                  ))
              .toList());
    });
  }
}

List<dynamic> setCreateNormal(String selectSemester) {
  bool isNormal = false;

  List<String> normalSemester = ["1학기", "여름학기", "2학기", "겨울학기"];

  int sem = 0;
  for (var item in normalSemester) {
    if (item == selectSemester) {
      isNormal = true;
      break;
    }
    sem++;
  }
  return [isNormal, "${sem}"];
}
