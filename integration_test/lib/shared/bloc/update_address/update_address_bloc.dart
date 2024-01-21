import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:integration_test/api_sdk/dio/models/update_address_model.dart';
import '../../../common_export.dart';
import '../../repository/railway_repository.dart';
part 'update_address_event.dart';
part 'update_address_state.dart';

class UpdateAddressBloc extends Bloc<UpdateAddressEvent, UpdateAddressState> {
  final SharedPrefs prefs = SharedPrefs.instance;
  final RailwayRepository _updateAddressService;

  UpdateAddressBloc({
    required RailwayRepository updateAddressService,
  })  : _updateAddressService = updateAddressService,
        super(const UpdateAddressInitial()) {
    on<UserUpdateaddress>(_mapUserUpdateaddress);
  }

  void _mapUserUpdateaddress(
      UserUpdateaddress event, Emitter<UpdateAddressState> emit) async {
    emit(const UpdateAddressLoading());
    try {
      await Future.delayed(
          const Duration(milliseconds: 500)); // a simulated delay
      final data = await _updateAddressService.updateAddress(
        latitude: event.latitude,
        longitude: event.longitude,
        time: event.time,
        eId: event.eId,
      );

      final updateAddressModel = UpdateAddressModel.fromJson(data);

      if (updateAddressModel.success == 1) {
        //prefs.setChechIn(true);
        emit(UpdateState(updateAddressModel: updateAddressModel));
      } else {
        emit(UpdateAddressFailure(message: data["message"]));
      }
    } catch (e) {
      emit(UpdateAddressFailure(message: e.toString()));
    }
  }
}
