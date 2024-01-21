// To parse this JSON data, do
//
//     final departmentModel = departmentModelFromJson(jsonString);

import 'dart:convert';

DepartmentModel departmentModelFromJson(String str) =>
    DepartmentModel.fromJson(json.decode(str));

String departmentModelToJson(DepartmentModel data) =>
    json.encode(data.toJson());

class DepartmentModel {
  DepartmentModel({
    required this.success,
    required this.message,
    this.data,
  });

  int success;
  String message;
  List<Datum>? data;

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      DepartmentModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.name,
    required this.deptLocationLat,
    required this.deptLocationLong,
    required this.dId,
  });

  int id;
  String name;
  String deptLocationLat;
  String deptLocationLong;
  int dId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        deptLocationLat: json["dept_location_lat"],
        deptLocationLong: json["dept_location_long"],
        dId: json["dId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "dept_location_lat": deptLocationLat,
        "dept_location_long": deptLocationLong,
        "dId": dId,
      };
}
