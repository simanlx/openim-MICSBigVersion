import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mics_big_version/src/pages/select_contacts/select_contacts_logic.dart';
import '../../../widgets/azlist_view.dart';

class BkrsGroupListViewPage extends StatelessWidget {

  final logic = Get.find<SelectContactsLogic>();

  @override
  Widget build(BuildContext context) {

    return  ListView.builder(
        itemCount: logic.groupList.length,
        itemBuilder: (BuildContext context,int index){
          var item = logic.groupList[index];
          return Obx(()=>InkWell(
              onTap: (){
                logic.selectedGroups(item);
              },
              child: buildAzListItemView(
                name: item.groupName??"",
                url:  item.faceURL??"",
                isMultiModel: true,
                checked: logic.checkedGroupList.contains(item),
                enabled: true,
              )));

        });
      // return Obx(() => WrapAzListView<ContactsInfo>(
      //   data: logic.contactsList.value,
      //   itemBuilder: (context, data, index) {
      //     var disabled = logic.defaultCheckedUidList.contains(data.userID);
      //     return InkWell(
      //         onTap: disabled ? null : () => logic.selectedContacts(data),
      //         child: buildAzListItemView(
      //           name: data.getShowName(),
      //           url: data.faceURL,
      //           isMultiModel: logic.isMultiModel(),
      //           checked: disabled ? true : logic.checkedList.contains(data),
      //           enabled: !disabled,
      //         ));
      //   },
      // ));
  //   }
  }
}
