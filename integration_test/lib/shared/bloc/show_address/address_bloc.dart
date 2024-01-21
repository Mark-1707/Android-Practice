import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../api_sdk/dio/models/address_model.dart';
import '../../repository/railway_repository.dart';
import '../../shared.dart';
part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final SharedPrefs prefs = SharedPrefs.instance;
  final RailwayRepository _addressService;
  AddressBloc({required RailwayRepository addressService})
      : _addressService = addressService,
        super(const AddressInitialState()) {
    on<GetAddressData>(_mapAddressDataState);
    on<GetAddress>(_mapGetAddressState);
  }

  // Address
  void _mapAddressDataState(
      GetAddressData event, Emitter<AddressState> emit) async {
    emit(const AddressLoadingState());
    try {
      final data = await _addressService.showAddress(event.id);
      final addressData = AddressModel.fromJson(data);
      emit(AdrressData(addressModel: addressData));
    } catch (e) {
      emit(AddressFailure(message: e.toString()));
    }
  }

  void _mapGetAddressState(GetAddress event, Emitter<AddressState> emit) async {
    emit(const AddressLoadingState());
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(event.latitude, event.longitude);
      Placemark placemark = placemarks[0];
      if (kDebugMode) {
        print(placemark);
      }

      emit(GetAdrress(placemark: placemark));
    } catch (e) {
      emit(AddressFailure(message: e.toString()));
    }
  }
}
