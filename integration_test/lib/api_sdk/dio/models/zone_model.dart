import 'dart:convert';

ZoneModel zoneModelFromJson(String str) => ZoneModel.fromJson(json.decode(str));

String zoneModelToJson(ZoneModel data) => json.encode(data.toJson());

class ZoneModel {
  ZoneModel({
    required this.success,
    required this.message,
    this.data,
  });

  int success;
  String message;
  List<Datum>? data;

  factory ZoneModel.fromJson(Map<String, dynamic> json) => ZoneModel(
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
    required this.zid,
    required this.zname,
    required this.rid,
  });

  int zid;
  String zname;
  int rid;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        zid: json["zid"],
        zname: json["zname"],
        rid: json["rid"],
      );

  Map<String, dynamic> toJson() => {
        "zid": zid,
        "zname": zname,
        "rid": rid,
      };
}
