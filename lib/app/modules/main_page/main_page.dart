import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polarstar_flutter/app/data/provider/board/board_provider.dart';
import 'package:polarstar_flutter/app/data/repository/board/board_repository.dart';
import 'package:polarstar_flutter/app/modules/board/board_controller.dart';
import 'package:polarstar_flutter/app/modules/classChat/class_chat_controller.dart';
import 'package:polarstar_flutter/app/modules/class/class_controller.dart';
import 'package:polarstar_flutter/app/modules/hot_board/hot_board.dart';
import 'package:polarstar_flutter/app/modules/init_page/init_controller.dart';

import 'package:polarstar_flutter/app/modules/mailHistory/mail_controller.dart';
import 'package:polarstar_flutter/app/modules/main_page/main_controller.dart';
import 'package:polarstar_flutter/app/modules/noti/noti_controller.dart';

import 'package:polarstar_flutter/app/modules/mypage/mypage_controller.dart';

import 'package:polarstar_flutter/app/modules/timetable/timetable_controller.dart';
import 'package:polarstar_flutter/app/data/provider/class/class_provider.dart';
import 'package:polarstar_flutter/app/data/provider/login_provider.dart';
import 'package:polarstar_flutter/app/data/provider/mail/mail_provider.dart';
import 'package:polarstar_flutter/app/data/provider/main/main_provider.dart';
import 'package:polarstar_flutter/app/data/provider/noti/noti_provider.dart';
import 'package:polarstar_flutter/app/data/provider/profile/mypage_provider.dart';
import 'package:polarstar_flutter/app/data/provider/timetable/timetable_provider.dart';
import 'package:polarstar_flutter/app/data/repository/class/class_repository.dart';
import 'package:polarstar_flutter/app/data/repository/login_repository.dart';
import 'package:polarstar_flutter/app/data/repository/mail/mail_repository.dart';
import 'package:polarstar_flutter/app/data/repository/main/main_repository.dart';
import 'package:polarstar_flutter/app/data/repository/noti/noti_repository.dart';
import 'package:polarstar_flutter/app/data/repository/profile/mypage_repository.dart';
import 'package:polarstar_flutter/app/data/repository/timetable/timetable_repository.dart';
import 'package:polarstar_flutter/app/modules/class/class.dart';

import 'package:polarstar_flutter/app/modules/main_page/main_page_scroll.dart';
import 'package:polarstar_flutter/app/modules/noti/noti.dart';

import 'package:polarstar_flutter/app/modules/mypage/mypage.dart';

import 'package:polarstar_flutter/app/modules/timetable/timetable.dart';

import 'package:polarstar_flutter/app/global_widgets/bottom_navigation_bar.dart';

import 'package:flutter/services.dart';
import 'package:polarstar_flutter/main.dart';

const mainColor = 0xff4570ff;
const subColor = 0xff91bbff;
const whiteColor = 0xffffffff;
const textColor = 0xff2f2f2f;

class MainPage extends StatelessWidget {
  final box = GetStorage();

  // ! 시작할때 모든 컨트롤러 다 불러와야해서 변경 -> 바텀 네비게이션 누를때마다 생성하는걸로
  // final List<Widget> mainPageWidget = [
  //   MainPageScroll(),
  //   Timetable(),
  //   Timetable(),
  //   Noti(),
  //   Mypage()
  // ];

  final TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    putController<InitController>();
    putController<MainController>();
    MainController mainController = Get.find();

    DateTime pre_backpress = DateTime.now().add(const Duration(seconds: -2));
    return Container(
      color: Get.theme.primaryColor,
      child: WillPopScope(
        onWillPop: () async {
          final timegap = DateTime.now().difference(pre_backpress);
          final cantExit = timegap >= Duration(seconds: 2);
          pre_backpress = DateTime.now();
          if (cantExit) {
            final snack = SnackBar(
              content: Text('确认要结束的话 请再按一次返回键'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.black,
            );
            ScaffoldMessenger.of(context).showSnackBar(snack);
            return false;
          } else {
            SystemNavigator.pop();
            // Get.smartManagement
            return true;
          }
        },
        child: SafeArea(
          top: false,
          // maintainBottomViewPadding: true,
          // bottom: false,
          child: Obx(() {
            int index = mainController.mainPageIndex.value;
            print(index);
            // if (!mainController.initDataAvailable.value) {
            //   return SplashPage();
            // }
            changeStatusBarColor(Get.theme.primaryColor, Brightness.light);

            return Scaffold(
              body: Builder(builder: (BuildContext context) {
                print(index);
                if (index == 0) {
                  putController<MainController>();
                  putController<BoardController>();
                  return HotBoard();
                } else if (index == 1) {
                  putController<TimeTableController>();
                  return Timetable();
                } else if (index == 2) {
                  putController<ClassController>();
                  return Class();
                } else if (index == 3) {
                  putController<MainController>();
                  putController<NotiController>();
                  return Noti();
                } else if (index == 4) {
                  putController<MyPageController>();
                  putController<MainController>();
                  changeStatusBarColor(
                      Get.theme.primaryColor, Brightness.light);
                  return Mypage();
                } else {
                  putController<MainController>();
                  return MainPageScroll();
                }
              }),
              bottomNavigationBar: CustomBottomNavigationBar(),
            );
          }),
        ),
      ),
    );
  }
}

void putController<T>() {
  if (Get.isRegistered<T>()) {
    return;
  }
  if (T == MainController) {
    Get.put(
        MainController(repository: MainRepository(apiClient: MainApiClient())));
    return;
  } else if (T == TimeTableController) {
    Get.put(TimeTableController(
        repository: TimeTableRepository(apiClient: TimetableApiClient())));
    return;
  } else if (T == NotiController) {
    Get.put(
        NotiController(repository: NotiRepository(apiClient: NotiApiClient())));
    return;
  } else if (T == MailController) {
    Get.put(
        MailController(repository: MailRepository(apiClient: MailApiClient())));
    return;
  } else if (T == MyPageController) {
    Get.put(MyPageController(
        repository: MyPageRepository(apiClient: MyPageApiClient())));
  } else if (T == InitController) {
    Get.put(InitController(
        repository: LoginRepository(apiClient: LoginApiClient())));
    return;
  } else if (T == ClassController) {
    Get.put(ClassController(
        repository: ClassRepository(apiClient: ClassApiClient())));
    return;
  } else if (T == ClassChatController) {
    Get.put(ClassChatController());
    return;
  } else if (T == BoardController) {
    Get.put(BoardController(
        repository: BoardRepository(apiClient: BoardApiClient()),
        initCommunityId: -1,
        initPage: 0));

    final BoardController boardController = Get.find();
    // boardController.getTotalBoard();
    boardController.getNewBoard();
    boardController.getHotBoard();
  }
}
