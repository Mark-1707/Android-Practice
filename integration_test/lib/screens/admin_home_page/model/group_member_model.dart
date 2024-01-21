class GroupMemberModel {
  GroupMemberModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.deptId,
      required this.userType});

  int id;
  String name;
  String email;
  String phone;
  int deptId;
  int userType;

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) => GroupMemberModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        deptId: json["dept_id"],
        userType: json["user_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "dept_id": deptId,
        "user_type": userType,
      };
}
