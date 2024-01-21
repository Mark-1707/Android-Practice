import 'dart:convert';

AddressModel addressModelFromJson(String str) =>
    AddressModel.fromJson(json.decode(str));

String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
  AddressModel({
    required this.success,
    required this.message,
    this.data,
  });

  int success;
  String message;
  List<Datum>? data;

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
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
    required this.latitude,
    required this.longitude,
    required this.time,
    required this.eId,
  });

  int id;
  String latitude;
  String longitude;
  DateTime time;
  int eId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        time: DateTime.parse(json["time"]),
        eId: json["eId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "time": time.toIso8601String(),
        "eId": eId,
      };
}
