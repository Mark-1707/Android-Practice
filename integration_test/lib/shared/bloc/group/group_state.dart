part of 'group_bloc.dart';

abstract class GroupState extends Equatable {
  const GroupState();
  @override
  List<Object> get props => [];
}

class GroupInitial extends GroupState {
  const GroupInitial();
}

class GroupLoading extends GroupState {
  const GroupLoading();
}

class GroupStart extends GroupState {
  const GroupStart();
}

class GroupListData extends GroupState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> groupList;
  //final int groupCreateCount;
  const GroupListData({
    required this.groupList,
    //required this.groupCreateCount,
  });

  @override
  List<Object> get props => [groupList];
}

class GroupData extends GroupState {
  final DocumentSnapshot<Map<String, dynamic>> groupData;
  //final int groupCount;
  const GroupData({
   // required this.groupList,
    required this.groupData,
  });

  @override
  List<Object> get props => [groupData];
}

class GroupCountData extends GroupState {
  final int groupCount;
  const GroupCountData({required this.groupCount});

  @override
  List<Object> get props => [groupCount];
}

class GroupDeleted extends GroupState {
  const GroupDeleted();
}

class GroupFailure extends GroupState {
  final String message;

  const GroupFailure({required this.message});

  @override
  List<Object> get props => [message];
}
