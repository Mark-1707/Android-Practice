part of 'show_depart_bloc.dart';

abstract class ShowDepartByIdState extends Equatable {
  const ShowDepartByIdState();

  @override
  List<Object> get props => [];
}

class ShowDepartByIdInitialState extends ShowDepartByIdState {
  const ShowDepartByIdInitialState();
}

class ShowDepartByIdLoadingState extends ShowDepartByIdState {
  const ShowDepartByIdLoadingState();
}

class ShowDepartByIdStartState extends ShowDepartByIdState {
  const ShowDepartByIdStartState();
}

class ShowDepartByIdData extends ShowDepartByIdState {
  final ShowDeptByIdModel showDeptByIdModel;
  const ShowDepartByIdData({required this.showDeptByIdModel});

  @override
  List<Object> get props => [showDeptByIdModel];
}

class ShowDepartByIdFailure extends ShowDepartByIdState {
  final String message;
  const ShowDepartByIdFailure({required this.message});
  @override
  List<Object> get props => [message];
}
