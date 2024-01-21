import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'checkbox_event.dart';
part 'checkbox_state.dart';

class CheckboxBloc extends Bloc<CheckboxEvent, CheckboxState> {
  CheckboxBloc() : super(CheckboxStateLoading()) {
    on<CheckboxChanged>(mapEventToState);
  }

  mapEventToState(CheckboxEvent event, Emitter<CheckboxState> emit) {
    emit(CheckboxStateLoading());

    if (event is CheckboxChanged) {
      MapCheckboxState(isChecked: event.isChecked);
    }
  }
}
