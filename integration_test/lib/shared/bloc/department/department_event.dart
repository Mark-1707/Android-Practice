part of 'department_bloc.dart';

abstract class DepartmentEvent extends Equatable {
  const DepartmentEvent();

  @override
  List<Object> get props => [];
}

class GetDepartmentData extends DepartmentEvent {
  final int id;
  const GetDepartmentData({required this.id});
}

class WaitForDepartment extends DepartmentEvent {
  const WaitForDepartment();
}

