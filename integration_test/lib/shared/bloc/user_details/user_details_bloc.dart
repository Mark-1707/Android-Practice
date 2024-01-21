import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:integration_test/api_sdk/dio/models/user_info.dart';
import '../../../common_export.dart';
import 'dart:developer' as developer;
part 'user_details_event.dart';
part 'user_details_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  final SharedPrefs prefs = SharedPrefs.instance;
  final AuthenticationRepository _authenticationService;
  UserDetailsBloc({
    required AuthenticationRepository authenticationService,
  })  : _authenticationService = authenticationService,
        super(const UserDetailsInitial()) {
    // on<UserSignUp>(_mapUserSignupToState);
    on<GetUserDetails>(_mapUserDetailsState);
    // on<GetUserData>(_mapUserLoggedInState);
  }

  void _mapUserDetailsState(
      GetUserDetails event, Emitter<UserDetailsState> emit) async {
    emit(const UserDetailsLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final data =
          await _authenticationService.loginUser(event.phone, event.password);
      final userResponse = UserInfoModel.fromJson(data);
      //developer.log("Amresh:${userResponse.data.userType}");
      if (userResponse.success == 1) {
        prefs.setGroupCount(userResponse.data.groupCount);
        prefs.setGroupMemberCount(userResponse.data.groupMemberCount);
        emit(UserDetailsData(groupCount: userResponse.data.groupCount));
      } else {
        emit(UserDetailsFailure(message: userResponse.message));
        developer.log("RRRR${userResponse.message}");
      }
    } catch (e) {
      emit(const UserDetailsFailure(message: 'Something went wrong'));
      developer.log("cccc${e.toString()}");
    }
  }
}
