import 'package:get/get.dart';
import 'package:polarstar_flutter/app/bindings/class/class_chat_binding.dart';

import 'package:polarstar_flutter/app/bindings/loby/init_binding.dart';
import 'package:polarstar_flutter/app/bindings/board/board_binding.dart';
import 'package:polarstar_flutter/app/bindings/board/hot_board_binding.dart';
import 'package:polarstar_flutter/app/bindings/board/post_binding.dart';
import 'package:polarstar_flutter/app/bindings/board/search_binding.dart';
import 'package:polarstar_flutter/app/bindings/board/write_post_binding.dart';
import 'package:polarstar_flutter/app/bindings/loby/login_binding.dart';
import 'package:polarstar_flutter/app/bindings/mail/mailBox_binding.dart';
import 'package:polarstar_flutter/app/bindings/mail/mailHistory_binding.dart';
import 'package:polarstar_flutter/app/bindings/main/main_binding.dart';
import 'package:polarstar_flutter/app/bindings/main/main_search_binding.dart';
import 'package:polarstar_flutter/app/bindings/profile/mypage_binding.dart';
import 'package:polarstar_flutter/app/bindings/loby/sign_up_binding.dart';
import 'package:polarstar_flutter/app/bindings/class/class_binding.dart';
import 'package:polarstar_flutter/app/bindings/class/class_search_binding.dart';
import 'package:polarstar_flutter/app/bindings/class/class_view_binding.dart';
import 'package:polarstar_flutter/app/bindings/timetable/timetable_addclass_binding.dart';
import 'package:polarstar_flutter/app/bindings/timetable/timetable_addclass_search_binding.dart';
import 'package:polarstar_flutter/app/bindings/timetable/timetable_bin_binding.dart';
import 'package:polarstar_flutter/app/bindings/timetable/timetable_binding.dart';

import 'package:polarstar_flutter/app/ui/android/board/board.dart';
import 'package:polarstar_flutter/app/ui/android/board/hot_board.dart';
import 'package:polarstar_flutter/app/ui/android/board/post.dart';
import 'package:polarstar_flutter/app/ui/android/board/write_post.dart';
import 'package:polarstar_flutter/app/ui/android/mail/classChat.dart';
import 'package:polarstar_flutter/app/ui/android/mail/mailHistory.dart';
import 'package:polarstar_flutter/app/ui/android/main/main_page.dart';
import 'package:polarstar_flutter/app/ui/android/loby/login_page.dart';
import 'package:polarstar_flutter/app/ui/android/loby/init_page.dart';
import 'package:polarstar_flutter/app/ui/android/loby/find_password.dart';
import 'package:polarstar_flutter/app/ui/android/main/board_list.dart';
import 'package:polarstar_flutter/app/ui/android/main/main_page_search.dart';
import 'package:polarstar_flutter/app/ui/android/noti/noti.dart';
import 'package:polarstar_flutter/app/ui/android/profile/mypage.dart';
import 'package:polarstar_flutter/app/ui/android/profile/profile.dart';
import 'package:polarstar_flutter/app/ui/android/profile/setting.dart';
import 'package:polarstar_flutter/app/ui/android/search/search_board.dart';
import 'package:polarstar_flutter/app/ui/android/loby/sign_up_page.dart';
import 'package:polarstar_flutter/app/ui/android/loby/sign_up_major.dart';
import 'package:polarstar_flutter/app/ui/android/class/class.dart';
import 'package:polarstar_flutter/app/ui/android/class/class_search.dart';
import 'package:polarstar_flutter/app/ui/android/class/class_view.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/add_class.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/add_class_search.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/add_timetable.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/timetable.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/widgets/timetable_class_fiilter.dart';
import 'package:polarstar_flutter/app/ui/android/timetable/timtable_bin.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.INITIAL,
      page: () => InitPage(),
      binding: InitBinding(),
    ),
    GetPage(
        name: Routes.LOGIN,
        page: () => LoginPage(),
        binding: LoginBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.SIGNUP,
        page: () => SignUpPage(),
        binding: SignUpBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.SIGNUPMAJOR,
        page: () => SignUpMajor(),
        binding: SignUpBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.FINDPW,
        page: () => FindPw(),
        transition: Transition.cupertino),
    GetPage(
      name: Routes.MAIN_PAGE,
      page: () => MainPage(),
      bindings: [MainBinding()],
    ),
    GetPage(
        name: Routes.MAIN_PAGE_SEARCH,
        page: () => MainPageSearch(),
        binding: MainSearchBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.POST,
        page: () => Post(),
        binding: PostBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.SEARCH_ALL,
        page: () => Board(),
        binding: BoardSearchBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.BOARD_LIST,
        page: () => BoardList(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.HOTBOARD,
        page: () => HotBoard(),
        binding: HotBoardBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.BOARD,
        page: () => Board(),
        binding: BoardBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.WRITE_POST,
        page: () => WritePost(),
        binding: WritePostBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.WRITE_PUT,
        page: () => WritePost(),
        binding: WritePostBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.MYPROFILE,
        page: () => Profile(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.MYPAGE,
        page: () => Mypage(),
        binding: MyPageBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.SETTING,
        page: () => Setting(),
        transition: Transition.cupertino),
    // GetPage(
    //   name: Routes.OUTSIDE,
    //   page: () => OutSide(),
    //   binding: OutSideBinding(),
    // ),
    GetPage(
        name: Routes.SEARCH,
        page: () => Search(),
        transition: Transition.cupertino),
    // GetPage(
    //     name: Routes.OUTSIDE_POST,
    //     page: () => OutSidePost(),
    //     binding: OutSidePostBinding()),
    GetPage(
        name: Routes.MAILHISTORY,
        page: () => MailHistory(),
        binding: MailHistoryBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.CLASS,
        page: () => Class(),
        binding: ClassBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.CLASSCHAT,
        page: () => ClassChatHistory(),
        binding: ClassChatBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.CLASSSEARCH,
        page: () => ClassSearch(),
        binding: ClassSearchBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.CLASSVIEW,
        page: () => ClassView(),
        binding: ClassViewBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.TIMETABLE,
        page: () => Timetable(),
        binding: TimetableBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.TIMETABLE_ADDCLASS_SEARCH,
        page: () => TimetableClassSearch(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.TIMETABLE_ADDCLASS_MAIN,
        page: () => TimetableAddClassMain(),
        binding: TimetableClassSearchBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.TIMETABLE_ADDCLASS_DIRECT,
        page: () => TimetableAddClass(),
        binding: TimetableClassBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.TIMETABLE_ADDCLASS_FILTER_COLLEGE,
        page: () => TimetableClassFilter(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.TIMETABLE_ADDCLASS_FILTER_MAJOR,
        page: () => TimetableClassMajor(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.TIMETABLE_BIN,
        page: () => TimeTableBin(),
        binding: TimetableBinBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.TIMETABLE_ADDTIMETABLE,
        page: () => TimeTableAdd(),
        binding: TimetableBinBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.NOTI, page: () => Noti(), transition: Transition.cupertino)
  ];
}
