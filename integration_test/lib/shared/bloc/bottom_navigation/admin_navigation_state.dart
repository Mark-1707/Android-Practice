part of 'admin_navigation_cubit.dart';

class AdminNavigationState extends Equatable {
  final NavbarAdminItem navbarItem;
  final int index;

  const AdminNavigationState(this.navbarItem, this.index);

  @override
  List<Object> get props => [navbarItem, index];
}