// 검색창
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:polarstar_flutter/app/controller/search/search_controller.dart';
import 'package:polarstar_flutter/app/data/provider/search/search_provider.dart';
import 'package:polarstar_flutter/app/data/repository/search/search_repository.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SearchController controller = Get.put(SearchController(
        repository: SearchRepository(apiClient: SearchApiClient()),
        initCommunityId: Get.parameters["COMMUNITY_ID"] == null
            ? 1
            : int.parse(Get.parameters["COMMUNITY_ID"]),
        initPage: Get.parameters["page"] == null
            ? 1
            : int.parse(Get.parameters["page"]),
        from: "board"));
    TextEditingController searchText = TextEditingController(
        text: controller.searchText.value == null
            ? ""
            : controller.searchText.value);

    return Container(
      margin: const EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: const Color(0xffffffff)),
            width: Get.mediaQuery.size.width - 20 - 62,
            margin: const EdgeInsets.only(right: 14),
            height: 32,
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Image.asset(
                  "assets/images/icn_search.png",
                  width: 20,
                  height: 20,
                  color: const Color(0xffcecece),
                ),
              ),
              Container(
                width: Get.mediaQuery.size.width - 20 - 62 - 30 - 20,
                child: TextFormField(
                  controller: searchText,
                  onEditingComplete: () async {
                    String text = searchText.text.trim();
                    controller.searchText(text);
                    await controller.getSearchBoard(searchTextTemp: text);
                    FocusScope.of(context).unfocus();
                  },
                  autofocus: false,
                  minLines: 1,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: "新建立 韩国大学联合交流区",
                    hintStyle: const TextStyle(
                        color: const Color(0xffcecece),
                        fontWeight: FontWeight.w500,
                        fontFamily: "NotoSansSC",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                  ),
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: "NotoSansSC",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                ),
              ),
            ]),
          ),
          Container(
            child: Ink(
              child: InkWell(
                onTap: () async {
                  Get.back();
                  // String text = searchText.text.trim();
                  // controller.searchText(text);
                  // await controller.getSearchBoard(searchTextTemp: text);
                  // FocusScope.of(context).unfocus();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("取消",
                      style: const TextStyle(
                          color: const Color(0xfff5f6ff),
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansSC",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
