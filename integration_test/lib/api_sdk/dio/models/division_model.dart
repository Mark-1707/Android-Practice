// To parse this JSON data, do
//
//     final divisionModel = divisionModelFromJson(jsonString);

import 'dart:convert';

DivisionModel divisionModelFromJson(String str) =>
    DivisionModel.fromJson(json.decode(str));

String divisionModelToJson(DivisionModel data) => json.encode(data.toJson());

class DivisionModel {
  DivisionModel({
    required this.success,
    required this.message,
    this.data,
  });

  int success;
  String message;
  List<Datum>? data;

  factory DivisionModel.fromJson(Map<String, dynamic> json) => DivisionModel(
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
    required this.dId,
    required this.dname,
    required this.zid,
  });

  int dId;
  String dname;
  int zid;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        dId: json["dId"],
        dname: json["dname"],
        zid: json["zid"],
      );

  Map<String, dynamic> toJson() => {
        "dId": dId,
        "dname": dname,
        "zid": zid,
      };
}
