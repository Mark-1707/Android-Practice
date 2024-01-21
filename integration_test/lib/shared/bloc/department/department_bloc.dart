import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:integration_test/api_sdk/dio/models/department_model.dart';
import '../../repository/railway_repository.dart';
import '../../shared.dart';
part 'department_event.dart';
part 'department_state.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  final SharedPrefs prefs = SharedPrefs.instance;
  final RailwayRepository _railwayService;

  DepartmentBloc({required RailwayRepository railwayService})
      : _railwayService = railwayService,
        super(const DepartmentInitial()) {
    on<GetDepartmentData>(_mapGetDepartmentsDataState);
    on<WaitForDepartment>(_mapWaitForDepartmentsState);
  }

  void _mapGetDepartmentsDataState(
      GetDepartmentData event, Emitter<DepartmentState> emit) async {
    emit(const DepartmentsLoading());
    try {
      final data = await _railwayService.getDepartments(event.id);
      final departmentData = DepartmentModel.fromJson(data);
      if (departmentData.success == 1) {
        emit(DepartmentsData(departmentModel: departmentData));
      } else {
        emit(DepartmentFailure(message: departmentData.message));
      }
    } catch (e) {
      emit(DepartmentFailure(message: e.toString()));
    }
  }

  void _mapWaitForDepartmentsState(
      WaitForDepartment event, Emitter<DepartmentState> emit) async {
    emit(const DepartmentsLoading());
  }
}
