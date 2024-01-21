part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial();
}

class AppAutheticated extends AuthenticationState {
  final int usertype;

  const AppAutheticated({required this.usertype});
}

class AuthenticationLoading extends AuthenticationState {
  const AuthenticationLoading();
}

class AuthenticationStart extends AuthenticationState {
  const AuthenticationStart();
}

class UserLogoutState extends AuthenticationState {
  const UserLogoutState();
}

class SignUpState extends AuthenticationState {
  final String message;
  const SignUpState({required this.message});
}

class AuthenticationNotAuthenticated extends AuthenticationState {}

class AuthenticationFailure extends AuthenticationState {
  final String message;

  const AuthenticationFailure({required this.message});

  @override
  List<Object> get props => [message];
}
