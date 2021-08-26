part of './app_pages.dart';

abstract class Routes {
  static const INITIAL = '/';
  static const LOGIN = '/login';
  static const SIGNUP = '/signUp';
  static const MAIN_PAGE = '/main';
  static const POST = "/board/:COMMUNITY_ID/read/:BOARD_ID";
  static const OUTSIDE_POST = "/outside/:COMMUNITY_ID/read/:BOARD_ID";

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
  static const DETAILS = '/details';
}
