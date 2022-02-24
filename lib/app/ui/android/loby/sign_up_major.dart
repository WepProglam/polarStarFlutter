import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:polarstar_flutter/app/controller/loby/sign_up_controller.dart';
import 'package:polarstar_flutter/app/data/model/sign_up_model.dart';

import 'package:polarstar_flutter/app/ui/android/functions/form_validator.dart';

import 'package:polarstar_flutter/app/ui/android/widgets/custom_text_form_field.dart';
import 'package:polarstar_flutter/app/ui/android/widgets/dialoge.dart';

class SignUpMajor extends StatelessWidget {
  const SignUpMajor({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignUpController signUpController = Get.find();
    return Container(
      color: Colors.white,
      child: SafeArea(
          top: false,
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                elevation: 0,
                leading: InkWell(
                  child: Image.asset("assets/images/icn_back_white.png"),
                  onTap: () => Get.back(),
                ),
                centerTitle: true,
                title: Text("注册会员",
                    style: const TextStyle(
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w500,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                    textAlign: TextAlign.center)),
            body: MajorInputs(
              signUpController: signUpController,
            ),
          )),
    );
  }
}

class MajorInputs extends StatelessWidget {
  const MajorInputs({Key key, this.signUpController}) : super(key: key);
  final SignUpController signUpController;

  @override
  Widget build(BuildContext context) {
    final universityController = TextEditingController(text: "성균관대학교");

    final _formKey = GlobalKey<FormState>();
    final majorScrollController = ScrollController(initialScrollOffset: 0.0);
    final majorFocus = FocusNode();

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              controller: majorScrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 40.0),
                    child: Text("大学",
                        style: const TextStyle(
                            color: const Color(0xff4570ff),
                            fontWeight: FontWeight.w500,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: TextFormField(
                      // initialValue: "성균관대학교",
                      readOnly: true,
                      controller: universityController,
                      validator: (value) {
                        return checkEmpty(value);
                      },
                      style: const TextStyle(
                          color: const Color(0xffd6d4d4),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(10.0, 11.0, 10.0, 11.0),
                          isDense: true,
                          hintText: "Search Your University",
                          hintStyle: const TextStyle(
                              color: const Color(0xffd6d4d4),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: const Color(0xffeaeaea), width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: const Color(0xffeaeaea), width: 1)),
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 18),
                    child: Text("选择专业",
                        style: const TextStyle(
                            color: const Color(0xff4570ff),
                            fontWeight: FontWeight.w500,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: TextFormField(
                        focusNode: majorFocus,
                        // onTap: () async {
                        //   await Future.delayed(Duration(milliseconds: 100));
                        //   majorScrollController.animateTo(
                        //       majorScrollController.position.maxScrollExtent,
                        //       duration: Duration(milliseconds: 100),
                        //       curve: Curves.fastOutSlowIn);
                        //   signUpController.majorSelected.value = false;
                        // },
                        style: const TextStyle(
                            color: const Color(0xff2f2f2f),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(10.0, 11.0, 10.0, 11.0),
                            isDense: true,
                            hintText: "请用韩语输入您的专业",
                            hintStyle: const TextStyle(
                                color: const Color(0xffd6d4d4),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: const Color(0xffeaeaea), width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: const Color(0xffeaeaea), width: 1)),
                            border: InputBorder.none),
                        controller: signUpController.majorController,
                        onChanged: (string) {
                          signUpController.majorSelected.value = false;
                          if (string.isEmpty) {
                            // if the search field is empty or only contains white-space, we'll display all users
                            signUpController.searchedMajorList.value = [];
                          } else {
                            signUpController.searchedMajorList(signUpController
                                .majorList
                                .where((major) => major.MAJOR_NAME
                                    .toLowerCase()
                                    .contains(string.toLowerCase()))
                                .toList());
                            // we use the toLowerCase() method to make it case-insensitive
                          }
                        },
                      )),
                  Obx(() {
                    return signUpController.majorSelected.value
                        ? Container()
                        : LimitedBox(
                            maxHeight: 100.0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                border: Border.all(
                                    color: const Color(0xffeaeaea), width: 1),
                              ),
                              child: Obx(() => ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      signUpController.searchedMajorList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          majorFocus.unfocus();
                                          signUpController.majorSelected.value =
                                              true;
                                          signUpController
                                                  .majorController.text =
                                              signUpController
                                                  .searchedMajorList[index]
                                                  .MAJOR_NAME;
                                          signUpController.selectedMajor(
                                              signUpController
                                                  .searchedMajorList[index]
                                                  .MAJOR_ID);
                                        },
                                        child: Text(
                                          signUpController
                                              .searchedMajorList[index]
                                              .MAJOR_NAME,
                                          style: const TextStyle(
                                              color: const Color(0xff2f2f2f),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "NotoSansKR",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 12.0),
                                        ),
                                      ),
                                    );
                                  })),
                            ),
                          );
                  }),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text("入学年份",
                        style: const TextStyle(
                            color: const Color(0xff4570ff),
                            fontWeight: FontWeight.w500,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 2.0),
                      child: Builder(builder: (context) {
                        List<int> addmissionYear = [
                          for (var i = 0; i < 13; i++) 2010 + i
                        ];
                        // addmissionYear = addmissionYear.reversed.toList();
                        return Obx(() {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              border: Border.all(
                                  color: const Color(0xffeaeaea), width: 1),
                            ),
                            child: DropdownButton(
                                underline: Container(),
                                isExpanded: true,
                                value: signUpController.admissionYear.value,
                                items: addmissionYear
                                    .map((e) => DropdownMenuItem(
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "${e}",
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff2f2f2f),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Roboto",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14.0),
                                            ),
                                          ),
                                          value: e,
                                        ))
                                    .toList(),
                                onChanged: (val) {
                                  signUpController.admissionYear.value = val;
                                }),
                          );
                        });
                      })),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0.0, bottom: 12.0),
                  child: InkWell(
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        if (signUpController.selectIndexPK(
                                signUpController.selectedMajor.value) ==
                            null) {
                          Get.snackbar(
                              "Major not selected", "Major not selected.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.white,
                              colorText: Colors.black);
                          return;
                        }
                        Get.to(
                            CommunityRule(
                              isSignUp: true,
                            ),
                            transition: Transition.cupertino);

// /                        Get.toNamed('/signUp');
                        // await signUpController.signUp(
                        //     idController.text,
                        //     pwController.text,
                        //     nicknameController.text,
                        //     studentIDController.text,
                        //     signUpController.selectIndexPK(
                        //         signUpController.selectedMajor.value),
                        //     signUpController.admissionYear.value);
                      }
                    },
                    child: Ink(
                      height: 48.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0x33000000),
                                offset: Offset(0, 3),
                                blurRadius: 10,
                                spreadRadius: 0)
                          ],
                          color: const Color(0xff4570ff)),
                      child: Center(
                        child: Text("注册",
                            style: const TextStyle(
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w700,
                                fontFamily: "NotoSansSC",
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 100.0),
                  child: Center(
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          style: const TextStyle(
                              color: const Color(0xff6f6e6e),
                              fontWeight: FontWeight.w500,
                              fontFamily: "NotoSansSC",
                              fontStyle: FontStyle.normal,
                              fontSize: 10.0),
                          text: "已有账号, "),
                      TextSpan(
                        style: const TextStyle(
                            color: const Color(0xff4570ff),
                            fontWeight: FontWeight.w500,
                            fontFamily: "NotoSansSC",
                            fontStyle: FontStyle.normal,
                            fontSize: 10.0),
                        text: "登录",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.until(
                              (route) => Get.currentRoute == '/login'),
                      )
                    ])),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CommunityRule extends StatefulWidget {
  CommunityRule({this.isSignUp});
  final bool isSignUp;

  @override
  State<CommunityRule> createState() => _CommunityRuleState();
}

class _CommunityRuleState extends State<CommunityRule> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
          top: false,
          child: Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                  automaticallyImplyLeading: false,
                  titleSpacing: 0,
                  elevation: 0,
                  leading: InkWell(
                    child: Image.asset("assets/images/icn_back_white.png"),
                    onTap: () => Get.back(),
                  ),
                  centerTitle: true,
                  title: Text("论坛使用规则",
                      style: const TextStyle(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                      textAlign: TextAlign.center)),
              body: Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "1. 커뮤니티 운영정책 안내",
                                style: TextStyle(
                                    color: const Color(0xff2f2f2f),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "NotoSansKR",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  "北北上学堂 커뮤니티는 익명, 비방, 갈등에 지친 모든 대학생들에게, 유용한 정보 및 건전한 교류를 제공하기 위해 만들어진 공간입니다. 이러한 공간을 유지하기 위해 본 커뮤니티 운영정책을 수립하였으며, 모든 사용자는 커뮤니티 운영정책을 반드시 숙지해주시길 부탁드립니다. 본 운영정책은 커뮤니티를 운영함에 있어 필요한 기준을 제시합니다. 경우에 따라 운영정책에 맞지 않는 게시글/댓글의 경우 삭제, 회원 정지, 회원 탈퇴 등의 제재가 가해질 수 있으며, 그 기준은 모두 본 커뮤니티 운영정책에 의거하여 처리됨을 알려드립니다.",
                                  style: TextStyle(
                                      color: const Color(0xff6f6e6e),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "NotoSansKR",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0),
                                ),
                              ),
                            ]),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "2. 커뮤니티 운영 시스템",
                                style: TextStyle(
                                    color: const Color(0xff2f2f2f),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "NotoSansKR",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  "北北上学堂 커뮤니티는 명확한 기준을 정하고, 정해진 신고 절차 및 운영방침에 따라 운영되고 있습니다. 커뮤니티 운영은 Al자동 삭제 시스템 등이 아닌, 전담인력을 배치하여 상시 모니터링하고 있으며 사용자들의 신고 뿐만 아니라 청소년 유해매체물, 음란물, 비방/욕설 등의 게시글 및 댓글들을 사전에 발견하여 운영정책에 의거하여 합당한 조치를 취하고 있습니다.",
                                  style: TextStyle(
                                      color: const Color(0xff6f6e6e),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "NotoSansKR",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0),
                                ),
                              ),
                            ]),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "3. 커뮤니티 내 금지사항",
                                style: TextStyle(
                                    color: const Color(0xff2f2f2f),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "NotoSansKR",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  "北北上学堂 커뮤니티의 금지사항은 일반 사용자들의 보편적 불편함을 기준으로 제정하였습니다. 아래에 나오는 각 조항은 커뮤니티 내 금지사항을 기재한 것이며 이와 위반된 행위를 한 사용자의 경우 활동물 삭제, 이용제한, 이용정지 등의 불이익을 받을 수 있습니다.",
                                  style: TextStyle(
                                      color: const Color(0xff6f6e6e),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "NotoSansKR",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "1조: 음란물, 음담패설, 신처 사진 등 청소년 유해 매체물 게시",
                                        style: TextStyle(
                                            color: const Color(0xff6f6e6e),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "NotoSansKR",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12.0),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 16),
                                        child: Column(
                                          children: [
                                            Text(
                                                "1-1. 간접적으로 유해 매체물 연상이 가능한 게시글 \n1-2. 성과 관련된 지나친 단어, 표현이 사용된 댓글 및 게시글 \n1-3. 특정 대상을 성적 유희의 대상으로 직접적으로 묘사한 행위 \n1-4. 사용자의 성적 수치심을 해할 우려가 있는 행위 \n1-5. 유흥 관련 정보 공유, 알선, 매매 등 통념상 허용 불가능한 행위 \n1-6. 기타 성 관련하여 논란의 여지가 있는 범주의 모든 댓글 및 게시글",
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xff6f6e6e),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "NotoSansKR",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0))
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "2조. 사회적으로 금지된 사항 및 사회질서를 저해하는 행위",
                                        style: TextStyle(
                                            color: const Color(0xff6f6e6e),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "NotoSansKR",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12.0),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 16),
                                        child: Column(
                                          children: [
                                            Text(
                                                "2-1. 도박 등 사행심을 조장하는 행위 \n2-2. 암호화폐(코인), 주식 등의 WeChat 단체 채팅방을 홍보하거나 관련된 홍보를 하는 행위 \n2-3. 장애인, 노약자 등 사회적 소외계층을 비하하는 행위 \n2-4. 그 밖에 사회질서를 저해할 가능성이 있다고 판단되는 모든 행위",
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xff6f6e6e),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "NotoSansKR",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0))
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "3조. 타인 또는 특정 단체에 대한 비하, 욕설",
                                        style: TextStyle(
                                            color: const Color(0xff6f6e6e),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "NotoSansKR",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12.0),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 16),
                                        child: Column(
                                          children: [
                                            Text(
                                                "3-1. 정당한 권리 없이 타인, 단체의 사진을 게재하는 행위 \n3-2. 기타 상대방이 불쾌감을 느낄 수 있는 범주의 모든 댓글 및 게시글",
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xff6f6e6e),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "NotoSansKR",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0))
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "4조. 정치, 종교, 젠더이슈 등 모두가 존중 받아야 하는 주제이지만, 동시에 논란의 여지가 있을 수 있는 주제의 내용",
                                        style: TextStyle(
                                            color: const Color(0xff6f6e6e),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "NotoSansKR",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12.0),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 16),
                                        child: Column(
                                          children: [
                                            Text(
                                                "4-1. 특정 정당, 정치인에 대한 지지 및 비난, 강한 정치적 의견 피력 및 논란 조장 \n4-2. 특정 종교 지지 및 비난, 강한 종교적 의견 피력 및 논란 조장 \n4-3. 남녀갈등 조장의 가능성이 있는 모든 댓글 및 게시글 일세 \n4-4. 기타 갈등을 조장하기 위해 작성되었다고 판단되는 모든 댓글 및 게시글",
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xff6f6e6e),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "NotoSansKR",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0))
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "5조. 공직선거법에 반하는 행위",
                                        style: TextStyle(
                                            color: const Color(0xff6f6e6e),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "NotoSansKR",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12.0),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 16),
                                        child: Column(
                                          children: [
                                            Text(
                                                "5-1. 특정 정당 및 후보자 지지, 비방 및 투표 독려 행위 \n5-2. 목적성을 갖고 커뮤니티 내 여론을 한 방향으로 몰아가려는 행위 \n5-3. 특정 정당에 소속되거나 직간접적으로 연관되어, 관련한 활동을 하는 동아리, 집단, 단체, 학회의 홍보 및 비슷한 류의 활동",
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xff6f6e6e),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "NotoSansKR",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0))
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "6조. 타 서비스 홍보 및 언급",
                                        style: TextStyle(
                                            color: const Color(0xff6f6e6e),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "NotoSansKR",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12.0),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 16),
                                        child: Column(
                                          children: [
                                            Text(
                                                "6-1. 北北上学堂 외 다른 유사한 서비스를 홍보하는 게시물 \n6-2. 사적인 목적을 갖고 개인의 영리적 이득을 위해 홍보를 진행하는 행위 \n6-3. 홍보게시판이 아닌 다른 기타 게시판에 올려진 홍보 게시물 \n6-4. 그 외 홍보로 인하여 기타 커뮤니티 이용의 불편함이 야기될 수 있는 모든 게시물 및 댓글",
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xff6f6e6e),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "NotoSansKR",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0))
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "7조. 서비스 내 비정상적 이용행위",
                                        style: TextStyle(
                                            color: const Color(0xff6f6e6e),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "NotoSansKR",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12.0),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 16),
                                        child: Column(
                                          children: [
                                            Text(
                                                "7-1. 본인의 계정이 아닌 다른 이의 계정을 사용하여 글을 작성하는 행위 \n7-2. 서비스 운영자를 사칭하며 권한을 행사하는 행위 \n7-3. 신고제도 악용 및 과도한 신고 행위",
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xff6f6e6e),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "NotoSansKR",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0))
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "8조. 도배글, 내용 없는 글 등 비정상적 게시글 작성 내용",
                                        style: TextStyle(
                                            color: const Color(0xff6f6e6e),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "NotoSansKR",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12.0),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 16),
                                        child: Column(
                                          children: [
                                            Text(
                                                "8-1. 동일한 내용의 글, 댓글을 반복적으로 게시하는 행위 \n8-2. 짧은 기간 내 지나치게 많은 글을 올려 커뮤니티 이용에 불편함을 주는 행위",
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xff6f6e6e),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "NotoSansKR",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0))
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "9조. 특정 학교/학과를 비방하거나 조롱하는 사항",
                                        style: TextStyle(
                                            color: const Color(0xff6f6e6e),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "NotoSansKR",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12.0),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 16),
                                        child: Column(
                                          children: [
                                            Text(
                                                "9-1. 특정 학교/학과에 대한 무시, 폭언, 비방 등의 언행 \n9-2. 특정 학교/학과를 연장할 수 있는 표현, 사진 등을 통해 비방 등의 오해 소지가 있는 행위 일체 \n9-3. 학교 간 비교, 학과 간 비교를 통해 어느 한쪽을 무시하거나 비방하는 행위 일세",
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xff6f6e6e),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "NotoSansKR",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0))
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "10조. 특정 학교/학과를 사칭하거나 부정확한 정보를 제공하는 사항",
                                        style: TextStyle(
                                            color: const Color(0xff6f6e6e),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "NotoSansKR",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12.0),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 16),
                                        child: Column(
                                          children: [
                                            Text(
                                                "10-1. 허위로 특정 학교/학과 정보를 언급하며 게시글 및 댓글을 작성하는 행위 \n10-2. 학교/학과 정보를 기반으로 특정 신분을 사칭하는 행위",
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xff6f6e6e),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "NotoSansKR",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0))
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "11조. 北北上学堂 서비스 운영에 있어서 방해가 되는 사항",
                                        style: TextStyle(
                                            color: const Color(0xff6f6e6e),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "NotoSansKR",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12.0),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 16),
                                        child: Column(
                                          children: [
                                            Text(
                                                "11-1. 본 서비스 이탈 유도 행위 \n11-2. 본 서비스 비방 및 허위사실 유포 행위 \n11-3. 경쟁 서비스 언급 및 비교 행위",
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xff6f6e6e),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "NotoSansKR",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0))
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "12조. 기타",
                                        style: TextStyle(
                                            color: const Color(0xff6f6e6e),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "NotoSansKR",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12.0),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 16),
                                        child: Column(
                                          children: [
                                            Text(
                                                "12-1. 기타 신고를 통해 접수된 게시글 중, 건전한 교류를 지향하는 北北上学堂 커뮤니티 방향성과 맞지 않다고 판단되는 모든 게시글 및 댓글(논란 조장, 분쟁 조장, 특정 견해의 확고한 주장으로부터 비롯되는 다른 유저들의 불편함이 야기되는 행위) \n12-2. 신고가 접수되지 않았지만 위 사항들에 해당되거나, 北北上学堂 커뮤니티 방향성과 맞지 않다고 판단되는 모든 게시글 및 댓글",
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xff6f6e6e),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "NotoSansKR",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0))
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                            ]),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "4. 정책 위반에 따른 이용제한",
                                style: TextStyle(
                                    color: const Color(0xff2f2f2f),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "NotoSansKR",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  "본 커뮤니티 금지사항에 위반한 게시글/댓글은 삭제 및 이동조치를 당할 수 있습니다. 해당 게시글/댓글을 작성한 사용자는 위반 정도 및 심각성이 따라 아래와 같은 제재를 당할 수 있습니다.",
                                  style: TextStyle(
                                      color: const Color(0xff6f6e6e),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "NotoSansKR",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  "1. 단순 활동물 삭제 \n2. 서비스 이용제한 \n3. 서비스 이용정지 \n4. 서비스 영구 탈퇴",
                                  style: TextStyle(
                                      color: const Color(0xff6f6e6e),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "NotoSansKR",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  "커뮤니티 이용수칙을 위반한 게시물/댓글의 경우 별도의 신고절차 없이도 운영진에 의해 삭제될 수 있습니다. 게시글이 해당 게시판의 취지에 맞지 않다고 판단될 경우, 해당 게시글을 취지에 맞는 게시판으로 이동시킬 수 있습니다. 정책 위반에 따른 제재 사항은 그 이유 및 위반된 조항을 앱 내 개별 알림을 통해 반드시 고지합니다. 제재 사항과 관련하여 문의가 있으신 분들은 polarstar102938@gmail.com으로 연락주시기 바랍니다.",
                                  style: TextStyle(
                                      color: const Color(0xff6f6e6e),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "NotoSansKR",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0),
                                ),
                              ),
                            ]),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "5. 신고처리 시스템",
                                style: TextStyle(
                                    color: const Color(0xff2f2f2f),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "NotoSansKR",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  "커뮤니티 이용규칙에 어긋나거나, 허위사실 및 명예훼손, 기타 권리 침해, 그 외 기타 불편함을 느낀 게시글을 사용자는 신고할 수 있습니다. 신고는 24시간 모니터링 되고 있으며, 다수의 신고가 누적된 경우 위반 정도 및 심각성이 따라 신고를 받은 사용자는 제재를 받을 수 있습니다. 모든 게시물은 이용자의 신고를 기반으로 하는 신고처리 시스템을 통해 처리됩니다. 北北上学堂 이용규칙에 어긋난다고 판단되는 게시물, 댓글, 답글을 발견하였을 경우, 신고 버튼을 눌러 신고하기 바랍니다.",
                                  style: TextStyle(
                                      color: const Color(0xff6f6e6e),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "NotoSansKR",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  "- 신고 접수 후 해당 신고 처리를 위해 신고 받은 글, 댓글, 답글이 일시적으로 저장될 수 있습니다. \n- 신고로 인해 해당 게시글/댓글/답글이 삭제될 수 있습니다. \n- 게시글/댓글/답글의 정책 위반 정도 및 심각성에 따라 서비스 이용이 제한될 수 있습니다. (1개월에서 최대 3년) \n- 기타 사회적으로 용인되기 힘든 게시글 및 댓글을 게시한 사용자의 경우, 별도의 경고 없이 즉각 서비스 탈퇴를 진행할 수 있으며 재가입이 불가능하도록 조치를 취할 수 있습니다.",
                                  style: TextStyle(
                                      color: const Color(0xff6f6e6e),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "NotoSansKR",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  "커뮤니티 이용수칙을 위반한 게시물/댓글의 경우 별도의 신고절차 없이도 운영진에 의해 삭제될 수 있습니다. 게시글이 해당 게시판의 취지에 맞지 않다고 판단될 경우, 해당 게시글을 취지에 맞는 게시판으로 이동시킬 수 있습니다. 정책 위반에 따른 제재 사항은 그 이유 및 위반된 조항을 앱 내 개별 알림을 통해 반드시 고지합니다. 제재 사항과 관련하여 문의가 있으신 분들은 polarstar102938@gmail.com으로 연락주시기 바랍니다.",
                                  style: TextStyle(
                                      color: const Color(0xff6f6e6e),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "NotoSansKR",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0),
                                ),
                              ),
                            ]),
                      ),
                      widget.isSignUp != null && widget.isSignUp == true
                          ? Column(children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isChecked = !isChecked;
                                  });
                                },
                                child: Ink(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 20),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: Checkbox(
                                              value: isChecked,
                                              onChanged: (value) {
                                                setState(() {
                                                  isChecked = value;
                                                });
                                              }),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          child: Text("同意论坛使用规则",
                                              style: TextStyle(
                                                  color:
                                                      const Color(0xff2f2f2f),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "NotoSansSC",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 12.0)),
                                        ),
                                      ]),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 20.0),
                                child: InkWell(
                                  onTap: () async {
                                    if (isChecked) {
                                      Get.toNamed('/signUp');
                                    } else {
                                      Get.snackbar("论坛使用规则", "请同意论坛使用规则",
                                          snackPosition: SnackPosition.BOTTOM,
                                          colorText: Colors.black,
                                          backgroundColor: Colors.white);
                                    }
                                  },
                                  child: Ink(
                                    height: 48.0,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: const Color(0x33000000),
                                              offset: Offset(0, 3),
                                              blurRadius: 10,
                                              spreadRadius: 0)
                                        ],
                                        color: const Color(0xff4570ff)),
                                    child: Center(
                                      child: Text("注册",
                                          style: const TextStyle(
                                              color: const Color(0xffffffff),
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "NotoSansSC",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16.0),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                              ),
                            ])
                          : Container(
                              height: 20,
                            ),
                    ],
                  ),
                ),
              ))),
    );
  }
}
