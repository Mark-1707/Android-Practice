part of 'user_details_bloc.dart';

abstract class UserDetailsEvent extends Equatable {
  const UserDetailsEvent();

  @override
  List<Object> get props => [];
}

// Fired just after the app is launched
class AppLoadedup extends UserDetailsEvent {
  const AppLoadedup();
}

class GetUserDetails extends UserDetailsEvent {
  final String phone;
  final String password;
  const GetUserDetails({required this.phone,required this.password});

  @override
  List<Object> get props => [phone, password];
}
