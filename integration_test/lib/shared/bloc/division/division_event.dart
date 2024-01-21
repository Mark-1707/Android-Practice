part of 'division_bloc.dart';

abstract class DivisionEvent extends Equatable {
  const DivisionEvent();

  @override
  List<Object> get props => [];
}

class GetDivisionData extends DivisionEvent {
  final int id;
  const GetDivisionData({required this.id});
}

class SelectDivision extends DivisionEvent {
  final int dId;
  const SelectDivision({required this.dId});
}

class WaitForDivision extends DivisionEvent {
  const WaitForDivision();
}

