part of 'bottom_navigation_bloc.dart';

abstract class BottomNavigationEvent extends Equatable {
  const BottomNavigationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends BottomNavigationEvent {
  const AppStarted();
  @override
  String toString() => 'AppStarted';
}

class PageTapped extends BottomNavigationEvent {
  final int index;

  const PageTapped({required this.index});

  @override
  String toString() => 'PageTapped: $index';

  @override
  List<Object> get props => [index];
}