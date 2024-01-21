part of 'checkbox_bloc.dart';

abstract class CheckboxState extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckboxStateInitial extends CheckboxState {
  CheckboxStateInitial();
}

class CheckboxStateLoading extends CheckboxState {
  CheckboxStateLoading();
}

class MapCheckboxState extends CheckboxState {
  final bool isChecked;
  MapCheckboxState({required this.isChecked});
  @override
  List<Object> get props => [];
}
