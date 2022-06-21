class PatientListRes {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  List<PatientListResData>? data;

  PatientListRes(
      {this.total, this.perPage, this.currentPage, this.lastPage, this.data});

  PatientListRes.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    if (json['data'] != null) {
      data = <PatientListResData>[];
      json['data'].forEach((v) {
        data!.add(new PatientListResData.fromJson(v));
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

class PatientListResData {
  int? id;
  String? name;
  String? avatar;
  String? sex;
  String? age;
  String? inpatientNumber;
  String? bedNumber;
  String? illnessDesc;
  String? groupNumber;
  String? createTime;
  int? hospitalized;
  int? patientRoom;
  String? patientRoomName;
  int? hospitalizedStartTime;
  int? hospitalizedEndTime;
  int? hospitalizedDays;

  PatientListResData(
      {this.id,
        this.name,
        this.avatar,
        this.sex,
        this.age,
        this.inpatientNumber,
        this.bedNumber,
        this.illnessDesc,
        this.groupNumber,
        this.createTime,
        this.hospitalized,
        this.patientRoom,
        this.patientRoomName,
        this.hospitalizedStartTime,
        this.hospitalizedEndTime,
        this.hospitalizedDays});

  PatientListResData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
    sex = json['sex'];
    age = json['age'];
    inpatientNumber = json['inpatient_number'];
    bedNumber = json['bed_number'];
    illnessDesc = json['Illness_desc'];
    groupNumber = json['group_number'];
    createTime = json['create_time'];
    hospitalized = json['hospitalized'];
    patientRoom = json['patient_room'];
    patientRoomName = json['patient_room_name'];
    hospitalizedStartTime = json['hospitalized_start_time'];
    hospitalizedEndTime = json['hospitalized_end_time'];
    hospitalizedDays = json['hospitalized_days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['sex'] = this.sex;
    data['age'] = this.age;
    data['inpatient_number'] = this.inpatientNumber;
    data['bed_number'] = this.bedNumber;
    data['Illness_desc'] = this.illnessDesc;
    data['group_number'] = this.groupNumber;
    data['create_time'] = this.createTime;
    data['hospitalized'] = this.hospitalized;
    data['patient_room'] = this.patientRoom;
    data['patient_room_name'] = this.patientRoomName;
    data['hospitalized_start_time'] = this.hospitalizedStartTime;
    data['hospitalized_end_time'] = this.hospitalizedEndTime;
    data['hospitalized_days'] = this.hospitalizedDays;
    return data;
  }
}