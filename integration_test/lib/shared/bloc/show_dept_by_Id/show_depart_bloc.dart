import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../api_sdk/dio/models/show_depart_by_id_model.dart';
import '../../repository/railway_repository.dart';
import '../../shared.dart';
part 'show_depart_event.dart';
part 'show_depart_state.dart';

class ShowDepartByIdBloc
    extends Bloc<ShowDepartByIdEvent, ShowDepartByIdState> {
  final SharedPrefs prefs = SharedPrefs.instance;
  final RailwayRepository _showDepartByIdService;
  ShowDepartByIdBloc({required RailwayRepository showDepartByIdService})
      : _showDepartByIdService = showDepartByIdService,
        super(const ShowDepartByIdInitialState()) {
    on<GetShowDepartByIdData>(_mapShowDepartByIdState);
  }

  // ZEmployye
  void _mapShowDepartByIdState(
      GetShowDepartByIdData event, Emitter<ShowDepartByIdState> emit) async {
    emit(const ShowDepartByIdLoadingState());
    try {
      final data = await _showDepartByIdService.showDeptById(event.id);
      final showDepartByData = ShowDeptByIdModel.fromJson(data);
      emit(ShowDepartByIdData(showDeptByIdModel: showDepartByData));
    } catch (e) {
      emit(ShowDepartByIdFailure(message: e.toString()));
    }
  }
}
