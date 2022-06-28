class VoiceTransferRes {
  String? status;
  String? lvsrStatus;
  List<LvsrData>? lvsrData;

  VoiceTransferRes({this.status, this.lvsrStatus, this.lvsrData});

  VoiceTransferRes.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    lvsrStatus = json['lvsr_status'];
    if (json['lvsr_data'] != null) {
      lvsrData = <LvsrData>[];
      json['lvsr_data'].forEach((v) {
        lvsrData!.add(new LvsrData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['lvsr_status'] = this.lvsrStatus;
    if (this.lvsrData != null) {
      data['lvsr_data'] = this.lvsrData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LvsrData {
  String? startTime;
  String? endTime;
  String? txt;
  String? speaker;
  int? silence;
  int? sc;
  int? id;

  LvsrData(
      {this.startTime,
        this.endTime,
        this.txt,
        this.speaker,
        this.silence,
        this.sc,
        this.id});

  LvsrData.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
    txt = json['txt'];
    speaker = json['speaker'];
    silence = json['silence'];
    sc = json['sc'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['txt'] = this.txt;
    data['speaker'] = this.speaker;
    data['silence'] = this.silence;
    data['sc'] = this.sc;
    data['id'] = this.id;
    return data;
  }
}