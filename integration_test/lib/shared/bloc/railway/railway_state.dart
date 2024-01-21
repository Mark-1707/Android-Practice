part of 'railway_bloc.dart';

abstract class RailwayState extends Equatable {
  const RailwayState();

  @override
  List<Object> get props => [];
}

class RailwayInitial extends RailwayState {
  const RailwayInitial();
}

class GetRailwayLoading extends RailwayState {
  const GetRailwayLoading();
}

class RailwayData extends RailwayState {
  final RailwayModel railwayModel;
  const RailwayData({required this.railwayModel});

  @override
  List<Object> get props => [railwayModel];
}

class RailwayDataSelect extends RailwayState {
  final int rId;
  const RailwayDataSelect({required this.rId});

  @override
  List<Object> get props => [rId];
}

class RailwayFailure extends RailwayState {
  final String message;
  const RailwayFailure({required this.message});
  @override
  List<Object> get props => [message];
}
