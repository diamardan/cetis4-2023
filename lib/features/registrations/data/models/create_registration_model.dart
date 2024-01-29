import 'dart:convert';

class CreateRegistrationModel {
  String? id;
  String names;
  String surnames;
  String curp;
  String email;
  String cellphone;
  String registrationType;
  String registrationNumber;
  String isReposition;
  String career;
  String grade;
  String group;
  String turn;

  CreateRegistrationModel({
    this.id,
    required this.names,
    required this.surnames,
    required this.curp,
    required this.email,
    required this.cellphone,
    required this.registrationType,
    required this.registrationNumber,
    required this.isReposition,
    required this.career,
    required this.grade,
    required this.group,
    required this.turn,
  });

  CreateRegistrationModel copyWith({
    String? id,
    String? names,
    String? surnames,
    String? curp,
    String? email,
    String? cellphone,
    String? idbio,
    String? registrationType,
    String? registrationNumber,
    String? studentSignaturePath,
    String? studentPhotoPath,
    String? studentQrPath,
    String? studentVoucherPath,
    String? qr,
    DateTime? creationDate,
    DateTime? updateDate,
    String? fecha,
    String? hora,
    String? tipoRegistro,
    int? idbioInt,
    dynamic isReposition,
    dynamic repositionDate,
    dynamic status,
    String? career,
    String? grade,
    String? group,
    String? turn,
  }) =>
      CreateRegistrationModel(
        id: id ?? this.id,
        names: names ?? this.names,
        surnames: surnames ?? this.surnames,
        curp: curp ?? this.curp,
        email: email ?? this.email,
        cellphone: cellphone ?? this.cellphone,
        registrationType: registrationType ?? this.registrationType,
        registrationNumber: registrationNumber ?? this.registrationNumber,
        isReposition: isReposition ?? this.isReposition,
        career: career ?? this.career,
        grade: grade ?? this.grade,
        group: group ?? this.group,
        turn: turn ?? this.turn,
      );

  factory CreateRegistrationModel.fromJson(String str) =>
      CreateRegistrationModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CreateRegistrationModel.fromMap(Map<String, dynamic> json) =>
      CreateRegistrationModel(
        id: json["id"],
        names: json["names"],
        surnames: json["surnames"],
        curp: json["curp"],
        email: json["email"],
        cellphone: json["cellphone"],
        registrationType: json["registration_type"],
        registrationNumber: json["registration_number"],
        isReposition: json["isReposition"],
        career: json["career"],
        grade: json["grade"],
        group: json["group"],
        turn: json["turn"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "names": names,
        "surnames": surnames,
        "curp": curp,
        "email": email,
        "cellphone": cellphone,
        "registration_type": registrationType,
        "registration_number": registrationNumber,
        "isReposition": isReposition,
        "career": career,
        "grade": grade,
        "group": group,
        "turn": turn,
      };
}
