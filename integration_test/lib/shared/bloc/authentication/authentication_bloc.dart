import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../api_sdk/dio/models/user_info.dart';
import '../../../common_export.dart';
import 'dart:developer' as developer;
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SharedPrefs prefs = SharedPrefs.instance;
  final AuthenticationRepository _authenticationService;
  AuthenticationBloc({
    required AuthenticationRepository authenticationService,
  })  : _authenticationService = authenticationService,
        super(const AuthenticationInitial()) {
    // on<UserSignUp>(_mapUserSignupToState);
    on<AppLoadedup>(_mapAppSignUpLoadedState);
    on<UserSignUp>(_mapUserSignupState);
    on<UserLogin>(_mapUserLoginState);
    on<LoggedIn>(_mapUserLoggedInState);
    on<UserLogOut>(_mapUserLogOutState);
    // on<GetUserData>(_mapUserLoggedInState);
  }

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  void _mapAppSignUpLoadedState(
      AppLoadedup event, Emitter<AuthenticationState> emit) async {
    emit(const AuthenticationLoading());
    try {
      await Future.delayed(
          const Duration(milliseconds: 500)); // a simulated delay
      if (prefs.getUserId() != null) {
        emit(AppAutheticated(usertype: int.parse(prefs.getUsertype()!)));
      } else {
        emit(const AuthenticationStart());
      }
    } catch (e) {
      emit(const AuthenticationFailure(message: 'An unknown error occurred'));
    }
  }

  void _mapUserLoggedInState(
      LoggedIn event, Emitter<AuthenticationState> emit) async {
    emit(const AuthenticationLoading());
    try {
      await Future.delayed(
          const Duration(milliseconds: 500)); // a simulated delay
      if (event.status) {
        emit(AppAutheticated(usertype: int.parse(prefs.getUsertype()!)));
      }
    } catch (e) {
      emit(const AuthenticationFailure(message: 'An unknown error occurred'));
    }
  }

  void _mapUserLoginState(
      UserLogin event, Emitter<AuthenticationState> emit) async {
    emit(const AuthenticationLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final data =
          await _authenticationService.loginUser(event.phone, event.password!);
      final userResponse = UserInfoModel.fromJson(data);
      //developer.log("Amresh:${userResponse.data.userType}");
      if (userResponse.success == 1) {
        prefs.setUsername(userResponse.data.name);
        prefs.setUserphone(userResponse.data.phone);
        prefs.setPassword(userResponse.data.password);
        prefs.setUseremail(userResponse.data.email);
        prefs.setUsertype(userResponse.data.userType.toString());
        prefs.setUserdeptid(userResponse.data.deptId.toString());
        prefs.setEid(userResponse.data.id.toString());
        prefs.setGroupCount(userResponse.data.groupCount);
        prefs.setGroupMemberCount(userResponse.data.groupMemberCount);

        final data = {
          'groupCount': userResponse.data.groupCount,
          'membersCount': userResponse.data.groupMemberCount,
          //'groupCreatedCount': 0
        };

        firestore.collection('groups').doc(prefs.getPhone()).set(data);

        if (userResponse.data.activation == 1) {
          prefs.setUserId(event.phone);
          developer.log(event.phone);
          emit(AppAutheticated(usertype: userResponse.data.userType));
        } else {
          emit(const AuthenticationFailure(message: 'User is Not Activated'));
        }
      } else {
        emit(AuthenticationFailure(message: userResponse.message));
        developer.log("RRRR${userResponse.message}");
      }
    } catch (e) {
      emit(const AuthenticationFailure(message: 'Something went wrong'));
      developer.log("cccc${e.toString()}");
    }
  }

  void _mapUserSignupState(
      UserSignUp event, Emitter<AuthenticationState> emit) async {
    emit(const AuthenticationLoading());
    try {
      await Future.delayed(
          const Duration(milliseconds: 500)); // a simulated delay
      final data = await _authenticationService.signUpUser(
          phone: event.phone,
          password: event.password,
          email: event.email,
          name: event.name,
          dept_id: event.dept_id,
          user_type: event.user_type,
          activation: event.activation);

      //final newData = jsonDecode(data);
      //final userResponse = SignUpModel.fromJson(data);

      if (data['success'] == 1) {
        emit(SignUpState(message: data['message']));
      } else {
        emit(AuthenticationFailure(message: data["message"]));
      }
    } catch (e) {
      emit(AuthenticationFailure(message: e.toString()));
    }
  }

  void _mapUserLogOutState(
      UserLogOut event, Emitter<AuthenticationState> emit) async {
    emit(const AuthenticationLoading());
    try {
      await Future.delayed(
          const Duration(milliseconds: 500)); // a simulated delay
      //final currentUserId = prefs.getUserId();m,./
      //final data = await _authenticationService.logoutUser(currentUserId!);
      //if (data["error"] == null) {
      prefs.clear();
      emit(const UserLogoutState());
      // } else {
      //   emit(AuthenticationFailure(message: data["error"]));
      // }
    } catch (e) {
      emit(AuthenticationFailure(message: e.toString()));
    }
  }
}
