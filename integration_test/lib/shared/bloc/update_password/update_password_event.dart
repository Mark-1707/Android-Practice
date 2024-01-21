part of 'update_password_bloc.dart';

abstract class UpdatePasswordEvent extends Equatable {
  const UpdatePasswordEvent();

  @override
  List<Object> get props => [];
}

// Fired just after the app is launched

class UpdatePassword extends UpdatePasswordEvent {
  final String phone;
  final String oldPassword;
  final String newPassword;

  const UpdatePassword({
    required this.phone,
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [phone, oldPassword, newPassword];
}
