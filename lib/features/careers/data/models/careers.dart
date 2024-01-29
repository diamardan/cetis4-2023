import 'dart:convert';

import 'package:cetis4/utils/common_response.dart';

//import 'package:datamex_origina/providers/common_response_mixin.dart';

class CareerModel extends CommonResponse {
  CareerModel({
    required this.id,
    required this.name,
    this.position,
    /* required this.description, */
  });
  factory CareerModel.fromJson(String str) =>
      CareerModel.fromMap(json.decode(str));

  factory CareerModel.fromMap(Map<String, dynamic> json) =>
      CareerModel(id: json['id'], name: json['name'], position: json['position']
          /* description: json['description'], */
          );

  @override
  String id;
  @override
  String name;
  @override
  int? position;
  /* String description; */

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'position': position,
        /* 'description': description, */
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CareerModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

List<CareerModel> careerResponseListFromJson(String str) =>
    List<CareerModel>.from(json.decode(str).map((x) => CareerModel.fromMap(x)));

String careerResponseListToJson(List<CareerModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));
