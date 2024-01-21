part of 'bottom_navigation_bloc.dart';

abstract class BottomNavigationState extends Equatable {
  const BottomNavigationState();

  @override
  List<Object> get props => [];
}

class CurrentIndexChanged extends BottomNavigationState {
  final int currentIndex;

  const CurrentIndexChanged({required this.currentIndex});

  @override
  String toString() => 'CurrentIndexChanged to $currentIndex';
}

class PageLoading extends BottomNavigationState {
  const PageLoading();

  @override
  String toString() => 'PageLoading';
}

class FirstPageLoaded extends BottomNavigationState {
  final String text;

  const FirstPageLoaded({required this.text});

  @override
  String toString() => 'FirstPageLoaded with text: $text';

  @override
  List<Object> get props => [text];
}

class SecondPageLoaded extends BottomNavigationState {
  final String number;

  const SecondPageLoaded({required this.number});

  @override
  String toString() => 'SecondPageLoaded with number: $number';

  @override
  List<Object> get props => [number];
}
