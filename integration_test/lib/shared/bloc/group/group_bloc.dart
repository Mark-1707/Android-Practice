// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:integration_test/screens/admin_home_page/model/group_member_model.dart';
import '../../../common_export.dart';
import 'dart:developer' as developer;
part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final SharedPrefs prefs = SharedPrefs.instance;
  GroupBloc() : super(const GroupInitial()) {
    on<GetGroupList>(_mapGetGroupListState);
    on<GetGroup>(_mapGetGroupState);
    on<CreateGroup>(_mapCreateGroupState);
    on<UpdateGroup>(_mapUpdateGroupState);
    on<DeleteGroup>(_mapDeleteGroupState);
  }

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  void _mapGetGroupListState(
      GetGroupList event, Emitter<GroupState> emit) async {
    emit(const GroupLoading());
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> groupList = firestore
          .collection('groups')
          .doc(prefs.getPhone())
          .collection('my_groups')
          .snapshots();

      

      emit(GroupListData(groupList: groupList));
    } catch (e) {
      emit(const GroupFailure(message: 'An unknown error occurred'));
    }
  }

  void _mapGetGroupState(GetGroup event, Emitter<GroupState> emit) async {
    emit(const GroupLoading());
    try {
      DocumentSnapshot<Map<String, dynamic>> groupData = await firestore
          .collection('groups')
          .doc(prefs.getPhone())
          .collection('my_groups')
          .doc(event.groupId)
          .get();

      emit(GroupData(groupData: groupData));
    } catch (e) {
      emit(const GroupFailure(message: 'An unknown error occurred'));
    }
  }

  void _mapGetGroupCountState(GetGroup event, Emitter<GroupState> emit) async {
    emit(const GroupLoading());
    try {
      int qSnap = await firestore
          .collection('groups')
          .doc(prefs.getPhone())
          .collection('my_groups')
          .snapshots()
          .length;

      emit(GroupCountData(groupCount: qSnap));
    } catch (e) {
      emit(const GroupFailure(message: 'An unknown error occurred'));
    }
  }

  void _mapCreateGroupState(CreateGroup event, Emitter<GroupState> emit) async {
    emit(const GroupLoading());
    try {
      final time = DateTime.now().millisecondsSinceEpoch.toString();

      List listData = [];

      listData = event.memebers.map((e) => e.toJson()).toList();

      final data = {
        'groupName': event.groupName,
        'members': listData,
        'createdAt': time,
        'memberCount': listData.length,
        'groupMemberLimit': prefs.getGroupMemberCount()!,
        'groupId': ''
      };
      String id = '';
      firestore
          .collection('groups')
          .doc(prefs.getPhone())
          .collection('my_groups')
          .add(data)
          .then((documentSnapshot) {
        print("Added Data with ID: ${documentSnapshot.id}");
        id = documentSnapshot.id;

        firestore
            .collection('groups')
            .doc(prefs.getPhone())
            .collection('my_groups')
            .doc(id)
            .update({'groupId': id});


      });

      Stream<QuerySnapshot<Map<String, dynamic>>> groupList = firestore
          .collection('groups')
          .doc(prefs.getPhone())
          .collection('my_groups')
          .snapshots();

      firestore
          .collection('groups')
          .doc(prefs.getPhone())
          .update({'groupCreatedCount': groupList.length});

      emit(GroupListData(groupList: groupList));
    } catch (e) {
      emit(const GroupFailure(message: 'An unknown error occurred'));
    }
  }

  void _mapUpdateGroupState(UpdateGroup event, Emitter<GroupState> emit) async {
    emit(const GroupLoading());
    try {
      //final time = DateTime.now().millisecondsSinceEpoch.toString();

      List listData = [];

      listData = event.memebers.map((e) => e.toJson()).toList();

      final data = {
        'groupName': event.groupName,
        'members': listData,
        'memberCount': listData.length,
      };

      firestore
          .collection('groups')
          .doc(prefs.getPhone())
          .collection('my_groups')
          .doc(event.groupId)
          .update(data);

      Stream<QuerySnapshot<Map<String, dynamic>>> groupList = firestore
          .collection('groups')
          .doc(prefs.getPhone())
          .collection('my_groups')
          .snapshots();

      emit(GroupListData(groupList: groupList));
    } catch (e) {
      emit(const GroupFailure(message: 'An unknown error occurred'));
    }
  }

  void _mapDeleteGroupState(DeleteGroup event, Emitter<GroupState> emit) async {
    emit(const GroupLoading());
    try {
      firestore
          .collection('groups')
          .doc(prefs.getPhone())
          .collection('my_groups')
          .doc(event.groupId)
          .delete();

      Stream<QuerySnapshot<Map<String, dynamic>>> groupList = firestore
          .collection('groups')
          .doc(prefs.getPhone())
          .collection('my_groups')
          .snapshots();

      
      emit(GroupListData(groupList: groupList));
    } catch (e) {
      emit(const GroupFailure(message: 'An unknown error occurred'));
    }
  }
}
