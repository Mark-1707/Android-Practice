part of 'group_bloc.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class CreateGroup extends GroupEvent {
  final String phone;
  final String groupName;
  final List<GroupMemberModel> memebers;

  const CreateGroup({
    required this.phone,
    required this.groupName,
    required this.memebers,
  });

  @override
  List<Object> get props => [phone, groupName, memebers];
}

class UpdateGroup extends GroupEvent {
  final String groupId;
  final String groupName;
  final List<GroupMemberModel> memebers;

  const UpdateGroup({
    required this.groupId,
    required this.groupName,
    required this.memebers,
  });

  @override
  List<Object> get props => [groupId, groupName, memebers];
}

class GetGroupList extends GroupEvent {
  final String phone;

  const GetGroupList({
    required this.phone,
  });

  @override
  List<Object> get props => [phone];
}

class GetGroup extends GroupEvent {
  final String groupId;

  const GetGroup({
    required this.groupId,
  });

  @override
  List<Object> get props => [groupId];
}

class DeleteGroup extends GroupEvent {
  final String groupId;

  const DeleteGroup({
    required this.groupId,
  });

  @override
  List<Object> get props => [groupId];
}
