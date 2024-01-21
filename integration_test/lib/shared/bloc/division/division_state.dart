part of 'division_bloc.dart';

abstract class DivisionState extends Equatable {
  const DivisionState();

  @override
  List<Object> get props => [];
}

class DivisionInitial extends DivisionState {
  const DivisionInitial();
}

class DivisionFailure extends DivisionState {
  final String message;
  const DivisionFailure({required this.message});
  @override
  List<Object> get props => [message];
}

class DivisionsLoading extends DivisionState {
  const DivisionsLoading();
}

class DivisionData extends DivisionState {
  final DivisionModel divisionModel;
  const DivisionData({required this.divisionModel});

  @override
  List<Object> get props => [divisionModel];
}

class DivisionDataSelect extends DivisionState {
  final int dId;
  const DivisionDataSelect({required this.dId});

  @override
  List<Object> get props => [dId];
}