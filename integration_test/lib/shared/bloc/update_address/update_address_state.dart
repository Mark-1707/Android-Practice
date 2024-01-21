part of 'update_address_bloc.dart';

abstract class UpdateAddressState extends Equatable {
  const UpdateAddressState();
  @override
  List<Object> get props => [];
}

class UpdateAddressInitial extends UpdateAddressState {
  const UpdateAddressInitial();
}

class UpdateAddressLoading extends UpdateAddressState {
  const UpdateAddressLoading();
}

class UpdateState extends UpdateAddressState {
  final UpdateAddressModel updateAddressModel;
  const UpdateState({required this.updateAddressModel});
}

class UpdateAddressFailure extends UpdateAddressState {
  final String message;

  const UpdateAddressFailure({required this.message});

  @override
  List<Object> get props => [message];
}
