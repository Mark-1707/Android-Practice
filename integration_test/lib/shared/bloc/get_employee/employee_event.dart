part of 'employee_bloc.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class EmployeeDataEvent extends EmployeeEvent {
  const EmployeeDataEvent();
}

class GetEmployeeData extends EmployeeEvent {
  final int id;
  const GetEmployeeData({required this.id});
}

class UpdateEmplyeeActivation extends EmployeeEvent {
  final int eId;
  final int dId;
  final int activation;

  const UpdateEmplyeeActivation(
      {required this.eId, required this.dId, required this.activation});
}

class EmplyeeDeletionEvent extends EmployeeEvent {
  final int eId;
  final int dId;

  const EmplyeeDeletionEvent({required this.eId, required this.dId});
}
