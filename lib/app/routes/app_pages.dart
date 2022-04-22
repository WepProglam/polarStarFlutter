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
import 'package:polarstar_flutter/app/modules/sign_up_major/sign_up_campus.dart';
import 'package:polarstar_flutter/app/modules/sign_up_major/sign_up_major.dart';
import 'package:polarstar_flutter/app/modules/sign_up_major/community_rule.dart';
import 'package:polarstar_flutter/app/modules/sign_up_major/widgets/qrcode.dart';
import 'package:polarstar_flutter/app/modules/sign_up_page/sign_up_binding.dart';
import 'package:polarstar_flutter/app/modules/sign_up_page/sign_up_page.dart';
import 'package:polarstar_flutter/app/modules/timetable/timetable.dart';
import 'package:polarstar_flutter/app/modules/timetable/timetable_binding.dart';
import 'package:polarstar_flutter/app/modules/timetable_bin/timetable_bin_binding.dart';
import 'package:polarstar_flutter/app/modules/timetable_bin/timtable_bin.dart';
import 'package:polarstar_flutter/app/modules/write_post/write_post.dart';
import 'package:polarstar_flutter/app/modules/write_post/write_post_binding.dart';
import 'package:polarstar_flutter/app/modules/board_list/board_list.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
        name: Routes.INITIAL,
        page: () => InitPage(),
        binding: InitBinding(),
        transition: Transition.fadeIn),
    GetPage(name: Routes.SETTING, page: () => Setting()),
    GetPage(
        name: Routes.LOGIN,
        page: () => LoginPage(),
        binding: LoginBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.QRCODE,
        page: () => QRCODE(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.SIGNUPCOMMUNITYRULE,
        page: () => SigunUpCommunityRule(),
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
        name: Routes.SIGNUPCAMPUS,
        page: () => SignUpCampus(),
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
        name: Routes.TIMETABLELIST,
        page: () => TimeTableList(),
        binding: TimetableListBinding(),
        transition: Transition.leftToRight),
    GetPage(
        name: Routes.TIMETABLE_ADDTIMETABLE,
        page: () => TimeTableAdd(),
        binding: TimetableBinBinding(),
        transition: Transition.cupertino),
    GetPage(
        name: Routes.NOTI, page: () => Noti(), transition: Transition.cupertino)
  ];
}
