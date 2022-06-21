class SaveYlbwRes {
  String? noteId;

  SaveYlbwRes({this.noteId});

  SaveYlbwRes.fromJson(Map<String, dynamic> json) {
    noteId = json['note_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['note_id'] = this.noteId;
    return data;
  }
}