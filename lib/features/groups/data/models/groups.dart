import 'dart:convert';

import 'package:cetis4/utils/common_response.dart';

class GroupsModel extends CommonResponse {
  GroupsModel({
    required this.id,
    required this.name,
    this.position,
  });

  factory GroupsModel.fromJson(String str) =>
      GroupsModel.fromMap(json.decode(str));

  factory GroupsModel.fromMap(Map<String, dynamic> json) => GroupsModel(
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

  GroupsModel copyWith({
    String? id,
    String? name,
    int? position,
  }) =>
      GroupsModel(
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
