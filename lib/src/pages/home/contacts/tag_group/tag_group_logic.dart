import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/common/apis.dart';
import 'package:mics_big_version/src/models/tag_group.dart';
import 'package:mics_big_version/src/res/strings.dart';
import 'package:mics_big_version/src/routes/app_navigator.dart';
import 'package:mics_big_version/src/widgets/custom_dialog.dart';
import 'package:mics_big_version/src/widgets/loading_view.dart';


class TagGroupLogic extends GetxController {
  var editing = false.obs;
  var tagGroup = <TagInfo>[].obs;
  var checkList = <TagInfo>[].obs;

  var controller = TextEditingController();
  var searchList = <TagInfo>[].obs;
  var key = "".obs;

  bool get isSearching => key.value.trim().isNotEmpty;

  void clear() {
    key.value = "";
    searchList.clear();
  }

  void search(String key) {
    this.key.value = key;
    var sKey = key.trim().toLowerCase();
    if (sKey.isNotEmpty) {
      searchList.assignAll(tagGroup
          .where((e) => e.tagName!.toLowerCase().contains(key))
          .toList());
    }
  }

  void toggleCheck(TagInfo info) {
    if (checkList.contains(info)) {
      checkList.remove(info);
    } else {
      checkList.add(info);
    }
  }

  toggleEdit() async {
    editing.value = !editing.value;
    if (!editing.value) {
      checkList.clear();
    } else {
      await LoadingView.singleton.wrap(
        asyncFunction: () => Apis.deleteTag(tagID: 'tagID'),
      );
      queryTagList();
    }
  }

  void queryTagList() async {
    var group = await LoadingView.singleton.wrap(
      asyncFunction: () => Apis.getUserTags(),
    );
    tagGroup.assignAll(group.tags ?? []);
  }

  void newTag() async {
    var result = await AppNavigator.startTagNew();
    if (result == true) {
      queryTagList();
    }
  }

  void deleteTag(TagInfo info) async {
    var confirm = await Get.dialog(CustomDialog(
      title: StrRes.confirmDeleteTag,
      rightText: StrRes.sure,
    ));
    if (confirm == true) {
      await LoadingView.singleton.wrap(
        asyncFunction: () => Apis.deleteTag(tagID: info.tagID!),
      );
      tagGroup.remove(info);
    }
  }

  @override
  void onInit() {
    queryTagList();
    super.onInit();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
