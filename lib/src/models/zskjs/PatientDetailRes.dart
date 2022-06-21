class PatientDetailRes {
  int? id;
  String? name;
  String? avatar;
  String? sex;
  String? age;
  String? inpatientNumber;
  String? bedNumber;
  String? illnessDesc;
  String? groupNumber;
  String? groupName;
  String? isArchive;
  String? createTime;
  int? hospitalized;
  int? patientRoom;
  num? hospitalizedStartTime;
  num? hospitalizedEndTime;
  String? createUserName;
  String? patientRoomName;

  PatientDetailRes(
      {this.id,
        this.name,
        this.avatar,
        this.sex,
        this.age,
        this.inpatientNumber,
        this.bedNumber,
        this.illnessDesc,
        this.groupNumber,
        this.groupName,
        this.isArchive,
        this.createTime,
        this.hospitalized,
        this.patientRoom,
        this.hospitalizedStartTime,
        this.hospitalizedEndTime,
        this.createUserName,
        this.patientRoomName});

  PatientDetailRes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
    sex = json['sex'];
    age = json['age'];
    inpatientNumber = json['inpatient_number'];
    bedNumber = json['bed_number'];
    illnessDesc = json['Illness_desc'];
    groupNumber = json['group_number'];
    groupName = json['group_name'];
    isArchive = json['is_archive'].toString();
    createTime = json['create_time'];
    hospitalized = json['hospitalized'];
    patientRoom = json['patient_room'];
    hospitalizedStartTime = json['hospitalized_start_time'];
    hospitalizedEndTime = json['hospitalized_end_time'];
    createUserName = json['create_user_name'];
    patientRoomName = json['patient_room_name'];
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
    data['group_name'] = this.groupName;
    data['is_archive'] = this.isArchive;
    data['create_time'] = this.createTime;
    data['hospitalized'] = this.hospitalized;
    data['patient_room'] = this.patientRoom;
    data['hospitalized_start_time'] = this.hospitalizedStartTime;
    data['hospitalized_end_time'] = this.hospitalizedEndTime;
    data['create_user_name'] = this.createUserName;
    data['patient_room_name'] = this.patientRoomName;
    return data;
  }
}