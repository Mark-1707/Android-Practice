part of 'update_password_bloc.dart';

abstract class UpdatePasswordState extends Equatable {
  const UpdatePasswordState();
  @override
  List<Object> get props => [];
}

class UpdatePasswordInitial extends UpdatePasswordState {
  const UpdatePasswordInitial();
}

class UpdatePasswordLoading extends UpdatePasswordState {
  const UpdatePasswordLoading();
}

class UpdatePasswordStart extends UpdatePasswordState {
  const UpdatePasswordStart();
}

class UpdatePassState extends UpdatePasswordState {
  const UpdatePassState();
}

class UpdatePasswordFailure extends UpdatePasswordState {
  final String message;

  const UpdatePasswordFailure({required this.message});

  @override
  List<Object> get props => [message];
}
