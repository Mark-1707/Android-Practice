part of 'show_depart_bloc.dart';

abstract class ShowDepartByIdEvent extends Equatable {
  const ShowDepartByIdEvent();

  @override
  List<Object> get props => [];
}

class ShowDepartByIdDataEvent extends ShowDepartByIdEvent {
  const ShowDepartByIdDataEvent();
}

class GetShowDepartByIdData extends ShowDepartByIdEvent {
  final int id;
  const GetShowDepartByIdData({required this.id});
}
