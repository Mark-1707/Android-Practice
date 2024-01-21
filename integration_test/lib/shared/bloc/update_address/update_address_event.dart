part of 'update_address_bloc.dart';

abstract class UpdateAddressEvent extends Equatable {
  const UpdateAddressEvent();

  @override
  List<Object> get props => [];
}

// Fired just after the app is launched
class AppLoadedup extends UpdateAddressEvent {
  const AppLoadedup();
}

class UserUpdateaddress extends UpdateAddressEvent {
  final String latitude;
  final String longitude;
  final String time;
  final int eId;

  const UserUpdateaddress({
    required this.latitude,
    required this.longitude,
    required this.time,
    required this.eId,
  });

  @override
  List<Object> get props => [latitude, longitude, time, eId];
}
