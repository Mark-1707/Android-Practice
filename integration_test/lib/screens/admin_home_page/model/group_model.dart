import 'group_member_model.dart';

class GroupModel {
  GroupModel({
    required this.groupName,
    required this.members,
    required this.createdAt,
    required this.groupId,
    required this.memberCount,
    required this.groupMemberLimit,
  });
  late String groupName;
  late List<GroupMemberModel> members;
  late String createdAt;
  late String groupId;
  late int memberCount;
  late int groupMemberLimit;

  GroupModel.fromJson(Map<String, dynamic> json) {
    groupName = json['groupName'] ?? '';
    members = List<GroupMemberModel>.from(
        json['members'].map((x) => GroupMemberModel.fromJson(x)));
    createdAt = json['createdAt'] ?? '';
    memberCount = json['memberCount'] ?? 0;
    groupMemberLimit = json['groupMemberLimit'] ?? 0;
    groupId = json['groupId'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['groupName'] = groupName;
    data['members'] = members;
    data['createdAt'] = createdAt;
    data['memberCount'] = memberCount;
    data['groupMemberLimit'] = groupMemberLimit;
    data['groupId'] = groupId;

    return data;
  }
}
