// To parse this JSON data, do
//
//     final showDeptByIdModel = showDeptByIdModelFromJson(jsonString);

import 'dart:convert';

ShowDeptByIdModel showDeptByIdModelFromJson(String str) => ShowDeptByIdModel.fromJson(json.decode(str));

String showDeptByIdModelToJson(ShowDeptByIdModel data) => json.encode(data.toJson());

class ShowDeptByIdModel {
    ShowDeptByIdModel({
        required this.success,
        required this.message,
        this.data,
    });

    int success;
    String message;
    List<Datum>? data;

    factory ShowDeptByIdModel.fromJson(Map<String, dynamic> json) => ShowDeptByIdModel(
        success: json["success"],
        message: json["message"],
        data: json['data'] == null
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
