part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class AddressDataEvent extends AddressEvent {
  const AddressDataEvent();
}

class GetAddressData extends AddressEvent {
  final int id;
  const GetAddressData({required this.id});
}

class GetAddress extends AddressEvent {
  final double latitude;
  final double longitude;
  const GetAddress({required this.latitude, required this.longitude});
}
