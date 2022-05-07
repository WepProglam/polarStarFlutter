import 'package:get/get.dart';
import 'package:polarstar_flutter/app/modules/add_class/add_class.dart';
import 'package:polarstar_flutter/app/modules/add_class/timetable_addclass_binding.dart';
import 'package:polarstar_flutter/app/modules/add_class/widgets/timetable.dart';
import 'package:polarstar_flutter/app/modules/add_class/widgets/timetable_class_fiilter.dart';
import 'package:polarstar_flutter/app/modules/add_class_search/add_class_search.dart';
import 'package:polarstar_flutter/app/modules/add_class_search/timetable_addclass_search_binding.dart';
import 'package:polarstar_flutter/app/modules/add_timetable/add_timetable.dart';
import 'package:polarstar_flutter/app/modules/board/board.dart';
import 'package:polarstar_flutter/app/modules/board/board_binding.dart';
import 'package:polarstar_flutter/app/modules/board/search_binding.dart';
import 'package:polarstar_flutter/app/modules/claa_view/class_view.dart';
import 'package:polarstar_flutter/app/modules/claa_view/class_view_binding.dart';
import 'package:polarstar_flutter/app/modules/class/class.dart';
import 'package:polarstar_flutter/app/modules/class/class_binding.dart';
import 'package:polarstar_flutter/app/modules/classChat/classChat.dart';
import 'package:polarstar_flutter/app/modules/classChat/class_chat_binding.dart';
import 'package:polarstar_flutter/app/modules/class_search/class_search.dart';
import 'package:polarstar_flutter/app/modules/class_search/class_search_binding.dart';
import 'package:polarstar_flutter/app/modules/find_password/find_password.dart';
import 'package:polarstar_flutter/app/modules/hot_board/hot_board.dart';
import 'package:polarstar_flutter/app/modules/hot_board/hot_board_binding.dart';
import 'package:polarstar_flutter/app/modules/init_page/init_binding.dart';
import 'package:polarstar_flutter/app/modules/init_page/init_page.dart';
import 'package:polarstar_flutter/app/modules/login_page/login_binding.dart';
import 'package:polarstar_flutter/app/modules/login_page/login_page.dart';
import 'package:polarstar_flutter/app/modules/mailHistory/mailHistory.dart';
import 'package:polarstar_flutter/app/modules/mailHistory/mailHistory_binding.dart';
import 'package:polarstar_flutter/app/modules/main_page/main_binding.dart';
import 'package:polarstar_flutter/app/modules/main_page/main_page.dart';
import 'package:polarstar_flutter/app/modules/main_page_search/main_page_search.dart';
import 'package:polarstar_flutter/app/modules/main_page_search/main_search_binding.dart';
import 'package:polarstar_flutter/app/modules/mypage/mypage.dart';
import 'package:polarstar_flutter/app/modules/mypage/mypage_binding.dart';
import 'package:polarstar_flutter/app/modules/noti/noti.dart';
import 'package:polarstar_flutter/app/modules/photo_layout/photo_binding.dart';
import 'package:polarstar_flutter/app/modules/post/post.dart';
import 'package:polarstar_flutter/app/modules/post/post_binding.dart';
import 'package:polarstar_flutter/app/modules/profile/profile.dart';
import 'package:polarstar_flutter/app/modules/search_board/search_board.dart';
import 'package:polarstar_flutter/app/modules/setting/setting.dart';
import 'package:polarstar_flutter/app/modules/sign_up_major/sign_up_major.dart';
import 'package:polarstar_flutter/app/modules/sign_up_page/sign_up_binding.dart';
import 'package:polarstar_flutter/app/modules/sign_up_page/sign_up_page.dart';
import 'package:polarstar_flutter/app/modules/timetable/timetable.dart';
import 'package:polarstar_flutter/app/modules/timetable/timetable_binding.dart';
import 'package:polarstar_flutter/app/modules/timetable_bin/timetable_bin_binding.dart';
import 'package:polarstar_flutter/app/modules/timetable_bin/timtable_bin.dart';
import 'package:polarstar_flutter/app/modules/write_post/write_post.dart';
import 'package:polarstar_flutter/app/modules/write_post/write_post_binding.dart';
import 'package:polarstar_flutter/app/modules/board_list/board_list.dart';
import 'package:polarstar_flutter/flurry_analytics_binding.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
        name: Routes.INITIAL,
        page: () => InitPage(),
        bindings: [InitBinding(), FlurryBinding()],
        transition: Transition.fadeIn),
    GetPage(name: Routes.SETTING, page: () => Setting()),
    GetPage(
        name: Routes.LOGIN,
        page: () => LoginPage(),
        bindings: [LoginBinding(), FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.QRCODE,
        page: () => QRCODE(),
        bindings: [FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.SIGNUPCOMMUNITYRULE,
        page: () => SigunUpCommunityRule(),
        bindings: [FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.SIGNUP,
        page: () => SignUpPage(),
        bindings: [SignUpBinding(), FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.SIGNUPMAJOR,
        page: () => SignUpMajor(),
        bindings: [SignUpBinding(), FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.FINDPW,
        page: () => FindPw(),
        bindings: [FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
      name: Routes.MAIN_PAGE,
      page: () => MainPage(),
      bindings: [MainBinding(), FlurryBinding()],
    ),
    GetPage(
        name: Routes.MAIN_PAGE_SEARCH,
        page: () => MainPageSearch(),
        bindings: [MainSearchBinding(), FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.POST,
        page: () => Post(),
        bindings: [PostBinding(), FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.SEARCH_ALL,
        page: () => Board(),
        bindings: [BoardSearchBinding(), FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.BOARD_LIST,
        page: () => BoardList(),
        bindings: [FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.HOTBOARD,
        page: () => HotBoard(),
        bindings: [HotBoardBinding(), FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.BOARD,
        page: () => Board(),
        bindings: [BoardBinding(), FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.WRITE_POST,
        page: () => WritePost(),
        bindings: [WritePostBinding(), FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.WRITE_PUT,
        page: () => WritePost(),
        bindings: [WritePostBinding(), FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.MYPROFILE,
        page: () => Profile(),
        bindings: [FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.MYPAGE,
        page: () => Mypage(),
        bindings: [MyPageBinding(), FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.SETTING,
        page: () => Setting(),
        bindings: [FlurryBinding()],
        transition: Transition.cupertino),
    // GetPage(
    //   name: Routes.OUTSIDE,
    //   page: () => OutSide(),
    //   bindings: OutSideBinding(),
    // ),
    GetPage(
        name: Routes.SEARCH,
        page: () => Search(),
        bindings: [FlurryBinding()],
        transition: Transition.cupertino),
    // GetPage(
    //     name: Routes.OUTSIDE_POST,
    //     page: () => OutSidePost(),
    //     bindings: OutSidePostBinding()),
    GetPage(
        name: Routes.MAILHISTORY,
        page: () => MailHistory(),
        bindings: [MailHistoryBinding(), FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.CLASS,
        page: () => Class(),
        bindings: [ClassBinding(), FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.CLASSCHAT,
        page: () => ClassChatHistory(),
        bindings: [ClassChatBinding(), FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.CLASSSEARCH,
        page: () => ClassSearch(),
        bindings: [ClassSearchBinding(), FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.CLASSVIEW,
        page: () => ClassView(),
        bindings: [ClassViewBinding(), FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.TIMETABLE,
        page: () => Timetable(),
        bindings: [TimetableBinding(), FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.TIMETABLE_ADDCLASS_SEARCH,
        page: () => TimetableClassSearch(),
        bindings: [FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.TIMETABLE_ADDCLASS_MAIN,
        page: () => TimetableAddClassMain(),
        bindings: [TimetableClassSearchBinding(), FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.TIMETABLE_ADDCLASS_DIRECT,
        page: () => TimetableAddClass(),
        bindings: [TimetableClassBinding(), FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.TIMETABLE_ADDCLASS_FILTER_COLLEGE,
        page: () => TimetableClassFilter(),
        bindings: [FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.TIMETABLE_ADDCLASS_FILTER_MAJOR,
        page: () => TimetableClassMajor(),
        bindings: [FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.TIMETABLELIST,
        page: () => TimeTableList(),
        bindings: [TimetableListBinding(), FlurryBinding()],
        transition: Transition.leftToRight),
    GetPage(
        name: Routes.TIMETABLE_ADDTIMETABLE,
        page: () => TimeTableAdd(),
        bindings: [TimetableBinBinding(), FlurryBinding()],
        transition: Transition.cupertino),
    GetPage(
        name: Routes.NOTI,
        page: () => Noti(),
        bindings: [FlurryBinding()],
        transition: Transition.cupertino)
  ];
}
