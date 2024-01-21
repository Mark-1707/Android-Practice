part of 'address_bloc.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

class AddressInitialState extends AddressState {
  const AddressInitialState();
}

class AddressLoadingState extends AddressState {
  const AddressLoadingState();
}

class AddressStartState extends AddressState {
  const AddressStartState();
}

class AdrressData extends AddressState {
  final AddressModel addressModel;
  const AdrressData({required this.addressModel});

  @override
  List<Object> get props => [addressModel];
}

class GetAdrress extends AddressState {
  final Placemark placemark;
  const GetAdrress({
    required this.placemark,
  });

  @override
  List<Object> get props => [placemark];
}

class AddressFailure extends AddressState {
  final String message;
  const AddressFailure({required this.message});
  @override
  List<Object> get props => [message];
}
