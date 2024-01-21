import 'dart:convert';

UserInfoModel userInfoModelFromJson(String str) =>
    UserInfoModel.fromJson(json.decode(str));

String userInfoModelToJson(UserInfoModel data) => json.encode(data.toJson());

class UserInfoModel {
  UserInfoModel({
    required this.success,
    required this.message,
    required this.data,
  });

  int success;
  String message;
  Data data;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
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
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.deptId,
    required this.password,
    required this.userType,
    required this.activation,    
    required this.groupCount,
    required this.groupMemberCount,
  });

  int id;
  String name;
  String email;
  String phone;
  int deptId;
  String password;
  int userType;
  int activation;
  int groupCount;
  int groupMemberCount;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        deptId: json["dept_id"],
        password: json["password"],
        userType: json["user_type"],
        activation: json["activation"],
        groupCount: json["group_count"],
        groupMemberCount: json["group_member_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "dept_id": deptId,
        "password": password,
        "user_type": userType,
        "activation": activation,
        "group_count": groupCount,
        "group_member_count": groupMemberCount,
      };
}
