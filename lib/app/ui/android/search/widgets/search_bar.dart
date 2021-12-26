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
        from: "outside"));
    TextEditingController searchText = TextEditingController(
        text: controller.searchText.value == null
            ? ""
            : controller.searchText.value);

    return Container(
      color: Color(0xffffffff),
      child: Padding(
        padding: const EdgeInsets.all(10.5),
        child: Stack(
          children: [
            TextFormField(
              controller: searchText,
              onEditingComplete: () async {
                String text = searchText.text.trim();
                controller.searchText(text);
                await controller.getSearchBoard(text);
                FocusScope.of(context).unfocus();
              },
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Color(0xffeeeeee),
                hintText: 'search',
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 6, horizontal: 17),
              ),
              style: const TextStyle(
                  color: const Color(0xff333333),
                  fontWeight: FontWeight.normal,
                  fontFamily: "PingFangSC",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 19.4),
                  child: InkWell(
                    onTap: () async {
                      await controller.getSearchBoard(searchText.text);
                      searchText.clear();
                      Get.toNamed("/searchBoard");
                    },
                    child: Ink(
                      width: 14.3,
                      height: 14.3,
                      child: Image.asset(
                        'assets/images/894.png',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
