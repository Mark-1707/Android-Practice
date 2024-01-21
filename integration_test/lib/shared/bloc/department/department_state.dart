part of 'department_bloc.dart';

abstract class DepartmentState extends Equatable {
  const DepartmentState();

  @override
  List<Object> get props => [];
}

class DepartmentInitial extends DepartmentState {
  const DepartmentInitial();
}

class DepartmentFailure extends DepartmentState {
  final String message;
  const DepartmentFailure({required this.message});
  @override
  List<Object> get props => [message];
}

class DepartmentsLoading extends DepartmentState {
  const DepartmentsLoading();
}

class DepartmentsData extends DepartmentState {
  final DepartmentModel departmentModel;
  const DepartmentsData({required this.departmentModel});

  @override
  List<Object> get props => [departmentModel];
}

class DepartmentDataSelect extends DepartmentState {
  final int dId;
  const DepartmentDataSelect({required this.dId});

  @override
  List<Object> get props => [dId];
}
