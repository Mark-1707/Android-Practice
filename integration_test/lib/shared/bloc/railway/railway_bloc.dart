import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:integration_test/api_sdk/dio/models/railway_model.dart';
import '../../repository/railway_repository.dart';
import '../../shared.dart';
part 'railway_event.dart';
part 'railway_state.dart';

class RailwayBloc extends Bloc<RailwayEvent, RailwayState> {
  final SharedPrefs prefs = SharedPrefs.instance;
  final RailwayRepository _railwayService;

  RailwayBloc({required RailwayRepository railwayService})
      : _railwayService = railwayService,
        super(const RailwayInitial()) {
    on<GetRailwayData>(_mapGetRailwayDataState);
    //on<SelectRailway>(_mapRailwayDataSeletState);
  }

  void _mapGetRailwayDataState(
      GetRailwayData event, Emitter<RailwayState> emit) async {
    emit(const GetRailwayLoading());
    try {
      final data = await _railwayService.getRailway();
      final railwayData = RailwayModel.fromJson(data);
      emit(RailwayData(railwayModel: railwayData));
    } catch (e) {
      emit(RailwayFailure(message: e.toString()));
    }
  }

  void _mapRailwayDataSeletState(
      SelectRailway event, Emitter<RailwayState> emit) async {
    emit(const GetRailwayLoading());
    try {
      emit(RailwayDataSelect(rId: event.rId));
    } catch (e) {
      emit(RailwayFailure(message: e.toString()));
    }
  }
}
