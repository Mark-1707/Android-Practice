import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../api_sdk/dio/models/employee_model.dart';
import '../../../api_sdk/dio/models/update_activation_model.dart';
import '../../repository/railway_repository.dart';
import '../../shared.dart';
part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final SharedPrefs prefs = SharedPrefs.instance;
  final RailwayRepository _employeeService;
  EmployeeBloc({required RailwayRepository employeeService})
      : _employeeService = employeeService,
        super(const EmployeeInitialState()) {
    on<GetEmployeeData>(_mapEmployeeDataState);
    on<UpdateEmplyeeActivation>(_mapUpdateEmplyeeActivationState);
    on<EmplyeeDeletionEvent>(_mapEmployeeDeletionState);
  }

  // Employye
  void _mapEmployeeDataState(
      GetEmployeeData event, Emitter<EmployeeState> emit) async {
    emit(const EmployeeLoadingState());
    try {
      final data = await _employeeService.getEmployeeID(event.id);
      final employeeData = EmployeeModel.fromJson(data);
      emit(EmployeeData(employeeModel: employeeData));
    } catch (e) {
      emit(EmployeeFailure(message: e.toString()));
    }
  }

  void _mapUpdateEmplyeeActivationState(
      UpdateEmplyeeActivation event, Emitter<EmployeeState> emit) async {
    emit(const EmployeeLoadingState());
    try {
      final updateEmpActivationData = await _employeeService
          .updateEmpActivation(id: event.eId, activation: event.activation);
      final updateEmpActivation =
          UpdateActivationModel.fromJson(updateEmpActivationData);
      if (updateEmpActivation.success == 1) {
        final data = await _employeeService.getEmployeeID(event.dId);
        final employeeData = EmployeeModel.fromJson(data);
        emit(EmployeeData(employeeModel: employeeData));
      }
    } catch (e) {
      emit(EmployeeFailure(message: e.toString()));
    }
  }

  void _mapEmployeeDeletionState(
      EmplyeeDeletionEvent event, Emitter<EmployeeState> emit) async {
    emit(const EmployeeLoadingState());
    try {
      final updateEmpActivationData =
          await _employeeService.deleteUser(event.eId);
      //final updateEmpActivation = UpdateActivationModel.fromJson(updateEmpActivationData);
      if (updateEmpActivationData['success'] == 1) {
        final data = await _employeeService.getEmployeeID(event.dId);
        final employeeData = EmployeeModel.fromJson(data);
        emit(EmployeeData(employeeModel: employeeData));
      }
    } catch (e) {
      emit(EmployeeFailure(message: e.toString()));
    }
  }
}
