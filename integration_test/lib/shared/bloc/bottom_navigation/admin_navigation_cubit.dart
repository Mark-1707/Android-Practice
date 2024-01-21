import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:integration_test/screens/admin_root/nav_bar_items.dart';

part 'admin_navigation_state.dart';

class AdminNavigationCubit extends Cubit<AdminNavigationState> {
  AdminNavigationCubit() : super(const AdminNavigationState(NavbarAdminItem.homePage, 0));

  void getNavBarItem(NavbarAdminItem navbarItem) {
    switch (navbarItem) {
      case NavbarAdminItem.homePage:
        emit(const AdminNavigationState(NavbarAdminItem.homePage, 0));
        break;
      case NavbarAdminItem.blogs:
        emit(const AdminNavigationState(NavbarAdminItem.blogs, 1));
        break;
      case NavbarAdminItem.chat:
        emit(const AdminNavigationState(NavbarAdminItem.chat, 2));
        break;
      case NavbarAdminItem.profile:
        emit(const AdminNavigationState(NavbarAdminItem.profile, 3));
        break;
      // case NavbarItem.LocalSMS:
      //   emit(const NavigationState(NavbarItem.LocalSMS, 2));
      //   break;
      
    }
  }
}
