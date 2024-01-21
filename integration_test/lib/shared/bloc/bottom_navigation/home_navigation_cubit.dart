import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../screens/user_root/nav_bar_items.dart';

part 'home_navigation_state.dart';

class UserNavigationCubit extends Cubit<UserNavigationState> {
  UserNavigationCubit() : super(const UserNavigationState(NavbarUserItem.homePage, 0));

  void getNavBarItem(NavbarUserItem navbarItem) {
    switch (navbarItem) {
      case NavbarUserItem.homePage:
        emit(const UserNavigationState(NavbarUserItem.homePage, 0));
        break;
      case NavbarUserItem.blogs:
        emit(const UserNavigationState(NavbarUserItem.blogs, 1));
        break;
      case NavbarUserItem.chat:
        emit(const UserNavigationState(NavbarUserItem.chat, 2));
        break;
      // case NavbarItem.previousBreakDown:
      //   emit(const NavigationState(NavbarItem.previousBreakDown, 1));
      //   break;
      // case NavbarItem.LocalSMS:
      //   emit(const NavigationState(NavbarItem.LocalSMS, 2));
      //   break;
      case NavbarUserItem.profile:
        emit(const UserNavigationState(NavbarUserItem.profile, 3));
        break;
    }
  }
}
