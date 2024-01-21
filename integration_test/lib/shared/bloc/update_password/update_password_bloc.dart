import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common_export.dart';
part 'update_password_event.dart';
part 'update_password_state.dart';

class UpadatePasswordBloc
    extends Bloc<UpdatePasswordEvent, UpdatePasswordState> {
  final AuthenticationRepository _updatepasswordService;
  UpadatePasswordBloc({
    required AuthenticationRepository updatepasswordService,
  })  : _updatepasswordService = updatepasswordService,
        super(const UpdatePasswordInitial()) {
    on<UpdatePassword>(_mapUpdatePasswordState);
  }

  void _mapUpdatePasswordState(
      UpdatePassword event, Emitter<UpdatePasswordState> emit) async {
    emit(const UpdatePasswordLoading());
    try {
      await Future.delayed(
          const Duration(milliseconds: 500)); // a simulated delay
      final data = await _updatepasswordService.updatePassword(
          phone: event.phone,
          oldPassword: event.oldPassword,
          newPassword: event.newPassword);
      if (data['success'] == 1) {
        emit(const UpdatePassState());
      } else {
        emit(UpdatePasswordFailure(message: data["message"]));
      }
    } catch (e) {
      emit(UpdatePasswordFailure(message: e.toString()));
    }
  }
}
