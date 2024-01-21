import 'dart:convert';

EmployeeModel employeeModelFromJson(String str) =>
    EmployeeModel.fromJson(json.decode(str));

String employeeModelToJson(EmployeeModel data) => json.encode(data.toJson());

class EmployeeModel {
  EmployeeModel({
    required this.success,
    required this.message,
    this.data,
  });

  int success;
  String message;
  List<Datum>? data;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
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
    required this.email,
    required this.phone,
    required this.deptId,
    required this.password,
    required this.userType,
    required this.activation,
    required this.groupCount,
    required this.groupMemberCount,
    this.isChecked,
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
  bool? isChecked = false;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
        isChecked: false,
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
