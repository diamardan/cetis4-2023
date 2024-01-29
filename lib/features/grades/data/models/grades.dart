import 'dart:convert';

import 'package:cetis4/utils/common_response.dart';

class GradesModel extends CommonResponse {
  GradesModel({
    required this.id,
    required this.name,
    this.position,
  });

  factory GradesModel.fromJson(String str) =>
      GradesModel.fromMap(json.decode(str));

  factory GradesModel.fromMap(Map<String, dynamic> json) => GradesModel(
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

  GradesModel copyWith({
    String? id,
    String? name,
    int? position,
  }) =>
      GradesModel(
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
