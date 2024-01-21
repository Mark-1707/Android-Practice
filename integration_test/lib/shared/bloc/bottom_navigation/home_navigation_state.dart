part of 'home_navigation_cubit.dart';

class UserNavigationState extends Equatable {
  final NavbarUserItem navbarItem;
  final int index;

  const UserNavigationState(this.navbarItem, this.index);

  @override
  List<Object> get props => [navbarItem, index];
}