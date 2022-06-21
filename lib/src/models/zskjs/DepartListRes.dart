class DepartListRes {
  int? id;
  String? name;
  int? isDelete;
  int? createdAt;
  int? updatedAt;
  int? deletedAt;
  String? slug;
  String? initials;
  String? groupId;

  DepartListRes(
      {this.id,
        this.name,
        this.isDelete,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.slug,
        this.initials,
        this.groupId});

  DepartListRes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isDelete = json['is_delete'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    slug = json['slug'];
    initials = json['initials'];
    groupId = json['group_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_delete'] = this.isDelete;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['slug'] = this.slug;
    data['initials'] = this.initials;
    data['group_id'] = this.groupId;
    return data;
  }
}