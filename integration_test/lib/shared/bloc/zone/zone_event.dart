part of 'zone_bloc.dart';

abstract class ZoneEvent extends Equatable {
  const ZoneEvent();

  @override
  List<Object> get props => [];
}

class GetZoneData extends ZoneEvent {
  final int id;
  const GetZoneData({required this.id});
}

class SelectZone extends ZoneEvent {
  final int zId;
  const SelectZone({required this.zId});
}

class WaitForZone extends ZoneEvent {
  const WaitForZone();
}



