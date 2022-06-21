class ZskjsListContentListItem {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  List<ZskjsListContentListItemData>? data;

  ZskjsListContentListItem(
      {this.total, this.perPage, this.currentPage, this.lastPage, this.data});

  ZskjsListContentListItem.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    if (json['data'] != null) {
      data = <ZskjsListContentListItemData>[];
      json['data'].forEach((v) {
        data!.add(new ZskjsListContentListItemData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['per_page'] = this.perPage;
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ZskjsListContentListItemData {
  String? name;
  String? content;
  String? createTime;
  String? groupName;
  String? typeName;
  String? labelName;

  ZskjsListContentListItemData(
      {this.name,
        this.content,
        this.createTime,
        this.groupName,
        this.typeName,
        this.labelName});

  ZskjsListContentListItemData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    content = json['content'];
    createTime = json['create_time'];
    groupName = json['group_name'];
    typeName = json['type_name'];
    labelName = json['label_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['content'] = this.content;
    data['create_time'] = this.createTime;
    data['group_name'] = this.groupName;
    data['type_name'] = this.typeName;
    data['label_name'] = this.labelName;
    return data;
  }
}