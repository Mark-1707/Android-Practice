part of 'railway_bloc.dart';

abstract class RailwayEvent extends Equatable {
  const RailwayEvent();

  @override
  List<Object> get props => [];
}

class GetRailwayData extends RailwayEvent {
  const GetRailwayData();
}

class SelectRailway extends RailwayEvent {
  final int rId;
  const SelectRailway({required this.rId});
}

