// To parse this JSON data, do
//
//     final signUpModel = signUpModelFromJson(jsonString);

import 'dart:convert';

SignUpModel signUpModelFromJson(String str) => SignUpModel.fromJson(json.decode(str));

String signUpModelToJson(SignUpModel data) => json.encode(data.toJson());

class SignUpModel {
    SignUpModel({
        required this.success,
        required this.message,
        required this.data,
    });

    int success;
    String message;
    Data data;

    factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
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
        required this.name,
        required this.email,
        required this.phone,
        required this.deptId,
        required this.password,
        required this.userType,
        required this.activation,
    });

    String name;
    String email;
    String phone;
    String deptId;
    String password;
    String userType;
    String activation;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        deptId: json["dept_id"],
        password: json["password"],
        userType: json["user_type"],
        activation: json["activation"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
        "dept_id": deptId,
        "password": password,
        "user_type": userType,
        "activation": activation,
    };
}
