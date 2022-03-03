part of './app_pages.dart';

abstract class Routes {
  static const INITIAL = '/';
  static const LOGIN = '/login';
  static const SIGNUP = '/signUp';
  static const SIGNUPMAJOR = '/signUpMajor';
  static const SIGNUPCOMMUNITYRULE = '/signUpCommunityRule';
  static const QRCODE = '/qrcode';

  static const FINDPW = "/findPw";
  static const MAIN_PAGE = '/main';
  static const MAIN_PAGE_SEARCH = "/main/search";
  static const POST = "/board/:COMMUNITY_ID/read/:BOARD_ID";
  static const OUTSIDE_POST = "/outside/:COMMUNITY_ID/read/:BOARD_ID";
  static const NOTI = "/noti";

  static const BOARD_LIST = "/board/boardList";
  static const HOTBOARD = "/board/hot/page/:page";
  static const BOARD = "/board/:COMMUNITY_ID/page/:page";
  static const OUTSIDE = "/outside/:COMMUNITY_ID/page/:page";
  static const SEARCH_ALL = "/board/searchAll/page/:page";
  static const SEARCH = "/searchBoard";

  static const MAILBOX = "/mail";
  static const MAILHISTORY = "/mail/:MAIL_BOX_ID";

  static const WRITE_POST = "/board/:COMMUNITY_ID";
  static const WRITE_PUT = "/board/:COMMUNITY_ID/bid/:BOARD_ID";
  static const MYPAGE = "/myPage";
  static const MYPROFILE = "/myPage/profile";
  static const SETTING = "/myPage/setting";
  static const DETAILS = '/details';

  static const CLASS = '/class';
  static const CLASSSEARCH = '/class/search';
  static const CLASSCHAT = '/class/chat';
  static const CLASSVIEW = '/class/view/:CLASS_ID';

  static const TIMETABLE = '/timetable';
  static const TIMETABLE_ADDCLASS_MAIN = "/timetable/addClass/main";
  static const TIMETABLE_ADDCLASS_SEARCH = "/timetable/addClass/search";
  static const TIMETABLE_ADDCLASS_FILTER_COLLEGE =
      "/timetable/addClass/filter/college";
  static const TIMETABLE_ADDCLASS_FILTER_MAJOR =
      "/timetable/addClass/filter/major";
  static const TIMETABLE_ADDCLASS_DIRECT = "/timetable/addClass/direct";

  static const TIMETABLE_BIN = "/timetable/bin";
  static const TIMETABLE_ADDTIMETABLE = "/timetable/addTimeTable";
}
