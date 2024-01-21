// To parse this JSON data, do
//
//     final updateActivationModel = updateActivationModelFromJson(jsonString);

import 'dart:convert';

UpdateActivationModel updateActivationModelFromJson(String str) => UpdateActivationModel.fromJson(json.decode(str));

String updateActivationModelToJson(UpdateActivationModel data) => json.encode(data.toJson());

class UpdateActivationModel {
    UpdateActivationModel({
        required this.success,
        required this.message,
        required this.data,
    });

    int success;
    String message;
    Data data;

    factory UpdateActivationModel.fromJson(Map<String, dynamic> json) => UpdateActivationModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    Data({
        required this.fieldCount,
        required this.affectedRows,
        required this.insertId,
        required this.serverStatus,
        required this.warningCount,
        required this.message,
        required this.protocol41,
        required this.changedRows,
    });

    int fieldCount;
    int affectedRows;
    int insertId;
    int serverStatus;
    int warningCount;
    String message;
    bool protocol41;
    int changedRows;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        fieldCount: json["fieldCount"],
        affectedRows: json["affectedRows"],
        insertId: json["insertId"],
        serverStatus: json["serverStatus"],
        warningCount: json["warningCount"],
        message: json["message"],
        protocol41: json["protocol41"],
        changedRows: json["changedRows"],
    );

    Map<String, dynamic> toJson() => {
        "fieldCount": fieldCount,
        "affectedRows": affectedRows,
        "insertId": insertId,
        "serverStatus": serverStatus,
        "warningCount": warningCount,
        "message": message,
        "protocol41": protocol41,
        "changedRows": changedRows,
    };
}
