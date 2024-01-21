part of 'zone_bloc.dart';

abstract class ZoneState extends Equatable {
  const ZoneState();

  @override
  List<Object> get props => [];
}

class ZoneInitial extends ZoneState {
  const ZoneInitial();
}

class ZoneFailure extends ZoneState {
  final String message;
  const ZoneFailure({required this.message});
  @override
  List<Object> get props => [message];
}

class ZonesLoading extends ZoneState {
  const ZonesLoading();
}

class ZonesData extends ZoneState {
  final ZoneModel zoneModel;
  const ZonesData({required this.zoneModel});

  @override
  List<Object> get props => [zoneModel];
}

class ZoneDataSelect extends ZoneState {
  final int zId;
  const ZoneDataSelect({required this.zId});

  @override
  List<Object> get props => [zId];
}
