part of 'employee_bloc.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object> get props => [];
}

class EmployeeInitialState extends EmployeeState {
  const EmployeeInitialState();
}

class EmployeeLoadingState extends EmployeeState {
  const EmployeeLoadingState();
}

class EmployeeStartState extends EmployeeState {
  const EmployeeStartState();
}

class EmployeeData extends EmployeeState {
  final EmployeeModel employeeModel;
  const EmployeeData({required this.employeeModel});

  @override
  List<Object> get props => [employeeModel];
}

class EmployeeActivation extends EmployeeState {
  final EmployeeModel employeeModel;
  const EmployeeActivation({required this.employeeModel});

  @override
  List<Object> get props => [employeeModel];
}

class EmployeeDeletion  extends EmployeeState {
  final EmployeeModel employeeModel;
  const EmployeeDeletion({required this.employeeModel});

  @override
  List<Object> get props => [employeeModel];
}

class EmployeeFailure extends EmployeeState {
  final String message;
  const EmployeeFailure({required this.message});
  @override
  List<Object> get props => [message];
}
