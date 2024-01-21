part of 'checkbox_bloc.dart';

abstract class CheckboxEvent extends Equatable {
  const CheckboxEvent();
  @override
  List<Object> get props => [];
}

class CheckboxChanged extends CheckboxEvent {
  final bool isChecked;

  CheckboxChanged({required this.isChecked});
}
