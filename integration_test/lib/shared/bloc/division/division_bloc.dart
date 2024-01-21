// ignore_for_file: unused_import

import 'dart:developer' as developer;
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../api_sdk/dio/models/division_model.dart';
import '../../repository/railway_repository.dart';
import '../../shared.dart';
part 'division_event.dart';
part 'division_state.dart';

class DivisionBloc extends Bloc<DivisionEvent, DivisionState> {
  final SharedPrefs prefs = SharedPrefs.instance;
  final RailwayRepository _railwayService;

  DivisionBloc({required RailwayRepository railwayService})
      : _railwayService = railwayService,
        super(const DivisionInitial()) {
    on<GetDivisionData>(_mapGetDivisionsDataState);
    on<WaitForDivision>(_mapWaitForDivisionsState);
  }

  // Zonse
  void _mapGetDivisionsDataState(
      GetDivisionData event, Emitter<DivisionState> emit) async {
    emit(const DivisionsLoading());
    try {
      final data = await _railwayService.getDivisions(event.id);
      final divisionData = DivisionModel.fromJson(data);
      emit(DivisionData(divisionModel: divisionData));
    } catch (e) {
      emit(DivisionFailure(message: e.toString()));
    }
  }

  void _mapWaitForDivisionsState(
      WaitForDivision event, Emitter<DivisionState> emit) async {
    emit(const DivisionsLoading());
  }
}
