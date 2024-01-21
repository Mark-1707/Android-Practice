part of 'user_details_bloc.dart';

abstract class UserDetailsState extends Equatable {
  const UserDetailsState();
  @override
  List<Object> get props => [];
}

class UserDetailsInitial extends UserDetailsState {
  const UserDetailsInitial();
}

class AppAutheticated extends UserDetailsState {
  final int usertype;

  const AppAutheticated({required this.usertype});
}

class UserDetailsLoading extends UserDetailsState {
  const UserDetailsLoading();
}

class UserDetailsStart extends UserDetailsState {
  const UserDetailsStart();
}

class UserDetailsData extends UserDetailsState {
  final int groupCount;

  const UserDetailsData({required this.groupCount});
}

class UserDetailsFailure extends UserDetailsState {
  final String message;

  const UserDetailsFailure({required this.message});

  @override
  List<Object> get props => [message];
}
