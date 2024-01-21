// ignore_for_file: unused_import

import 'dart:developer' as developer;
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:integration_test/api_sdk/dio/models/railway_model.dart';
import '../../../api_sdk/dio/models/zone_model.dart';
import '../../../api_sdk/dio/models/division_model.dart';
import '../../repository/railway_repository.dart';
import '../../shared.dart';
part 'zone_event.dart';
part 'zone_state.dart';

class ZoneBloc extends Bloc<ZoneEvent, ZoneState> {
  final SharedPrefs prefs = SharedPrefs.instance;
  final RailwayRepository _railwayService;

  ZoneBloc({required RailwayRepository railwayService})
      : _railwayService = railwayService,
        super(const ZoneInitial()) {
    on<GetZoneData>(_mapGetZonesDataState);
    on<WaitForZone>(_mapWaitForZonesState);
    //on<SelectZone>(_mapZonesDataSelectState);
  }

  // Zonse
  void _mapGetZonesDataState(GetZoneData event, Emitter<ZoneState> emit) async {
    emit(const ZonesLoading());
    try {
      final data = await _railwayService.getZones(event.id);
      final zoneData = ZoneModel.fromJson(data);
      emit(ZonesData(zoneModel: zoneData));
    } catch (e) {
      emit(ZoneFailure(message: e.toString()));
    }
  }

  void _mapZonesDataSelectState(
      SelectZone event, Emitter<ZoneState> emit) async {
    emit(const ZonesLoading());
    try {
      emit(ZoneDataSelect(zId: event.zId));
    } catch (e) {
      emit(ZoneFailure(message: e.toString()));
    }
  }

  void _mapWaitForZonesState(
      WaitForZone event, Emitter<ZoneState> emit) async {
    emit(const ZonesLoading());
  }
}
