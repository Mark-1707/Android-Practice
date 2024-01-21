import 'dart:convert';

RailwayModel getRailwayModelFromJson(String str) =>
    RailwayModel.fromJson(json.decode(str));

String getRailwayModelToJson(RailwayModel data) => json.encode(data.toJson());

class RailwayModel {
  RailwayModel({
    this.success,
    this.message,
    this.data,
  });

  int? success;
  String? message;
  List<Datum>? data;

  factory RailwayModel.fromJson(Map<String, dynamic> json) => RailwayModel(
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
    this.rId,
    this.rname,
  });

  int? rId;
  String? rname;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        rId: json["rId"],
        rname: json["rname"],
      );

  Map<String, dynamic> toJson() => {
        "rId": rId,
        "rname": rname,
      };
}
