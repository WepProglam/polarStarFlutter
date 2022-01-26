import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/main/main_controller.dart';
import 'package:polarstar_flutter/app/controller/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/routes/app_pages.dart';
import 'package:polarstar_flutter/app/ui/android/functions/timetable_semester.dart';
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

    timeTableController.createYear.value =
        timeTableController.addTimeTableYearSemList.last.split("学年度 ")[0];
    print(timeTableController.addTimeTableYearSemList.last.split("学年度 ")[0]);
    timeTableController.createSemester.value = setCreateNormal(
        timeTableController.addTimeTableYearSemList.last
            .split("学年度 ")[1]
            .substring(1, 1))[1];
    ;

    print(timeTableController.createYear.value);
    print(timeTableController.createSemester.value);

    return SafeArea(
        child: GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 56,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Container(
              child: Container(
                child: Stack(children: [
                  Row(
                    children: [
                      Ink(
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Image.asset(
                                "assets/images/back_icon.png",
                                width: 24,
                                height: 24,
                              )),
                        ),
                      ),
                      Spacer(),

                      // 사각형 4
                      Container(
                          width: 52,
                          height: 28,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Ink(
                            child: InkWell(
                              onTap: () async {
                                int year = int.parse(
                                    timeTableController.createYear.value);
                                int sem = flutterToServerSemChanger(int.parse(
                                    timeTableController.createSemester.value));

                                await timeTableController.createTimeTable(year,
                                    sem, timeTableController.createName.value);

                                Get.until((route) =>
                                    Get.currentRoute == Routes.MAIN_PAGE);
                              },
                              child: Center(
                                child: Text("添加",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Get.theme.primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "NotoSansSC",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12.0),
                                    textAlign: TextAlign.right),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14)),
                              border: Border.all(
                                  color: const Color(0xff99bbf9), width: 1),
                              color: const Color(0xffffffff))),
                    ],
                  ),
                  Center(
                    child: Text("新时间表",
                        style: const TextStyle(
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w500,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
                        textAlign: TextAlign.center),
                  )
                ]),
              ),
            ),
          ),
          backgroundColor: const Color(0xffffffff),
          body: SingleChildScrollView(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: // 时间表名称
                            Text("时间表名称",
                                style: const TextStyle(
                                    color: const Color(0xff6f6e6e),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "NotoSansSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.left),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: TextFormField(
                          key: _formKey,
                          onChanged: (value) {
                            timeTableController.createName.value = value;
                          },
                          maxLines: 1,
                          style: textStyle,
                          textAlign: TextAlign.left,
                          decoration: addTimetablenputDecoration("请输入名称"),
                        ),
                      ),
                      // 선 83
                      Container(
                          margin: const EdgeInsets.only(top: 7.5),
                          height: 1,
                          decoration:
                              BoxDecoration(color: const Color(0xffeaeaea)))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 23.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: // 教学名
                            Text("学期",
                                style: const TextStyle(
                                    color: const Color(0xff6f6e6e),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "NotoSansSC",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.left),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: // Please enter a schedule name
                              SelectSem(
                                  formKeyDrop: _formKeyDrop,
                                  timeTableController: timeTableController)),
                      // 선 41
                      Container(
                          height: 0.5,
                          margin: const EdgeInsets.only(top: 7.5),
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
              width: 10,
              height: 5,
              margin: const EdgeInsets.only(top: 10, bottom: 2.6, right: 6.6),
              child: Image.asset(
                "assets/images/940.png",
                color: Get.theme.primaryColor,
              ),
            ),
          ),
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onChanged: (value) {
            print(value.split("学年度 ")[1]);
            print(value.split("学年度 ")[1][1]);
            bool isNormal = setCreateNormal(value.split("学年度 ")[1][1])[0];
            String sem = setCreateNormal(value.split("学年度 ")[1][1])[1];

            print(sem);

            if (isNormal) {
              timeTableController.addTimeTableYearSem.value = value;

              timeTableController.createYear.value = value.split("学年度 ")[0];
              timeTableController.createSemester.value = "${sem}";
            } else {
              Get.snackbar("1학기, 여름학기, 2학기, 겨울학기 중 선택해주세요",
                  "1학기, 여름학기, 2학기, 겨울학기 중 선택해주세요");
            }
          },
          hint: Text("请选择学期",
              style: const TextStyle(
                  color: const Color(0xff9b9b9b),
                  fontWeight: FontWeight.w400,
                  fontFamily: "NotoSansSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0),
              textAlign: TextAlign.left),
          items: timeTableController.addTimeTableYearSemList
              .map((element) => DropdownMenuItem(
                    child: FittedBox(
                        child: Text(
                      "${element}",
                      style: const TextStyle(
                          color: const Color(0xff9b9b9b),
                          fontWeight: FontWeight.w400,
                          fontFamily: "NotoSansSC",
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

  print("!!!!!!!!!!! ${selectSemester}");

  List<String> normalSemester = ["1", "2"];

  int sem = 1;
  for (var item in normalSemester) {
    if (item == selectSemester) {
      isNormal = true;
      break;
    }
    sem++;
  }
  return [isNormal, "${sem}"];
}
