// ignore_for_file: unnecessary_null_comparison

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../common_export.dart';
part 'bottom_navigation_event.dart';
part 'bottom_navigation_state.dart';

class BottomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  final FirstPageRepository _firstPageRepository;
  final SecondPageRepository _secondPageRepository;

  BottomNavigationBloc({
    required FirstPageRepository firstPageRepository,
    required SecondPageRepository secondPageRepository,
  })  : _firstPageRepository = firstPageRepository,
        _secondPageRepository = secondPageRepository,
        super(const PageLoading()) {
    on<AppStarted>(_appLoaded);
    on<PageTapped>(_mapEventToState);
  }
  int currentIndex = 0;

  Stream<BottomNavigationState> _mapEventToState(
      BottomNavigationEvent event, Emitter<BottomNavigationState> emit) async* {
    if (event is PageTapped) {
      currentIndex = event.index;
      emit(CurrentIndexChanged(currentIndex: currentIndex));
      //emit(PageLoading());

      if (currentIndex == 0) {
        String data = await _getFirstPageData();
        emit(FirstPageLoaded(text: data));
      }
      if (currentIndex == 1) {
        String data = await _getSecondPageData();
        emit(SecondPageLoaded(number: data));
      }
    }
  }

  void _appLoaded(
      BottomNavigationEvent event, Emitter<BottomNavigationState> emit) async {
    emit(const PageLoading());
    if (event is AppStarted) {
      add(PageTapped(index: currentIndex));
    }
  }

  Future<String> _getFirstPageData() async {
    String data = _firstPageRepository.data;
    if (data == null) {
      await _firstPageRepository.fetchData();
      data = _firstPageRepository.data;
    }
    return data;
  }

  Future<String> _getSecondPageData() async {
    String data = _secondPageRepository.data;
    if (data == null) {
      await _secondPageRepository.fetchData();
      data = _secondPageRepository.data;
    }
    return data;
  }
}
