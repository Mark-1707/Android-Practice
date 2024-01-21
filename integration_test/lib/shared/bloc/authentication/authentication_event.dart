part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

// Fired just after the app is launched
class AppLoadedup extends AuthenticationEvent {
  const AppLoadedup();
}

class UserSignUp extends AuthenticationEvent {
  final String phone;
  final String password;
  final String email;
  final String name;
  final int dept_id;
  final int user_type;
  final int activation;

  const UserSignUp(
      {required this.name,
      required this.dept_id,
      required this.user_type,
      required this.activation,
      required this.phone,
      required this.email,
      required this.password});

  @override
  List<Object> get props => [phone, email, password, name, dept_id, user_type, activation];
}

class UserLogin extends AuthenticationEvent {
  final String phone;
  final String? password;
  const UserLogin({required this.phone, this.password});

  @override
  List<Object> get props => [phone, password!];
}

class LoggedIn extends AuthenticationEvent {
  final bool status;

  const LoggedIn({required this.status});

  @override
  List<Object> get props => [status];
  // String toString() => 'LoggedIn { token: $status }';
}

class UserLogOut extends AuthenticationEvent {
  //final String userId;
  const UserLogOut();
}
