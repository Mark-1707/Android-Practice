// To parse this JSON data, do
//
//     final updateAddressModel = updateAddressModelFromJson(jsonString);

import 'dart:convert';

UpdateAddressModel updateAddressModelFromJson(String str) => UpdateAddressModel.fromJson(json.decode(str));

String updateAddressModelToJson(UpdateAddressModel data) => json.encode(data.toJson());

class UpdateAddressModel {
    UpdateAddressModel({
        required this.success,
        required this.message,
    });

    int success;
    Message message;

    factory UpdateAddressModel.fromJson(Map<String, dynamic> json) => UpdateAddressModel(
        success: json["success"],
        message: Message.fromJson(json["message"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message.toJson(),
    };
}

class Message {
    Message({
        required this.latitude,
        required this.longitude,
        required this.time,
        required this.eId,
    });

    String latitude;
    String longitude;
    String time;
    String eId;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        latitude: json["latitude"],
        longitude: json["longitude"],
        time: json["time"],
        eId: json["eId"],
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "time": time,
        "eId": eId,
    };
}
