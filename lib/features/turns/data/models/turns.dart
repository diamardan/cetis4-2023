import 'dart:convert';

import 'package:cetis4/utils/common_response.dart';

class TurnsModel extends CommonResponse {
  TurnsModel({
    required this.id,
    required this.name,
    this.position,
  });

  factory TurnsModel.fromJson(String str) =>
      TurnsModel.fromMap(json.decode(str));

  factory TurnsModel.fromMap(Map<String, dynamic> json) => TurnsModel(
        id: json['id'],
        name: json['name'],
        position: json['position'],
      );
  @override
  String id;
  @override
  String name;
  @override
  int? position;

  TurnsModel copyWith({
    String? id,
    String? name,
    int? position,
  }) =>
      TurnsModel(
        id: id ?? this.id,
        name: name ?? this.name,
        position: position ?? this.position,
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'position': position,
      };
}
