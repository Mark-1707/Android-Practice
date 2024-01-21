// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/Chat/screens/home_screen.dart';
import 'package:integration_test/common_export.dart';
import 'package:integration_test/screens/blog/blog_page.dart';
import 'package:integration_test/screens/user_home_page/user_home_page.dart';
import 'package:integration_test/screens/profile/profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telephony/telephony.dart';
import '../../shared/bloc/bottom_navigation/home_navigation_cubit.dart';
import 'nav_bar_items.dart';

class UserRootScreen extends StatefulWidget {
  const UserRootScreen({super.key});
  @override
  State<UserRootScreen> createState() => _UserRootScreenState();
}

class _UserRootScreenState extends State<UserRootScreen> {
  late final AuthenticationBloc authenticationBloc;
  bool switchValue = false;
  final SharedPrefs prefs = SharedPrefs.instance;
  Telephony telephony = Telephony.instance;
  bool? isSiren = false;

  @override
  void initState() {
    super.initState();
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    switchValue = BlocProvider.of<UpdateThemeBloc>(context).state.props.first ==
            AppTheme.light
        ? false
        : true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
            bloc: authenticationBloc,
            listener: (context, state) {
              if (state is UserLogoutState) {
                context.go('/login');
              }
            },
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              bloc: authenticationBloc,
              builder: (context, state) {
                if (state is AppAutheticated) {
                  return Scaffold(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    bottomNavigationBar:
                        BlocBuilder<UserNavigationCubit, UserNavigationState>(
                      builder: (context, state) {
                        return BottomNavigationBar(
                          type: BottomNavigationBarType.fixed,
                          selectedItemColor: Theme.of(context)
                              .bottomNavigationBarTheme
                              .selectedItemColor,
                          backgroundColor: Theme.of(context)
                              .bottomNavigationBarTheme
                              .backgroundColor,
                          unselectedItemColor: Theme.of(context)
                              .bottomNavigationBarTheme
                              .unselectedItemColor,
                          currentIndex: state.index,
                          showUnselectedLabels: false,
                          items: const [
                            BottomNavigationBarItem(
                              icon: Icon(
                                Icons.home,
                              ),
                              label: 'Home',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(
                                Icons.railway_alert_outlined,
                              ),
                              label: 'Blogs',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(
                                Icons.message,
                              ),
                              label: 'Chat',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(
                                Icons.person,
                              ),
                              label: 'Profile',
                            ),
                          ],
                          onTap: (index) {
                            if (index == 0) {
                              BlocProvider.of<UserNavigationCubit>(context)
                                  .getNavBarItem(NavbarUserItem.homePage);
                              // } else if (index == 1) {
                              //   BlocProvider.of<NavigationCubit>(context)
                              //       .getNavBarItem(NavbarItem.previousBreakDown);
                              // } else if (index == 2) {
                              //   BlocProvider.of<NavigationCubit>(context)
                              //       .getNavBarItem(NavbarItem.LocalSMS);
                            } else if (index == 1) {
                              BlocProvider.of<UserNavigationCubit>(context)
                                  .getNavBarItem(NavbarUserItem.blogs);
                            } else if (index == 2) {
                              BlocProvider.of<UserNavigationCubit>(context)
                                  .getNavBarItem(NavbarUserItem.chat);
                            } else if (index == 3) {
                              BlocProvider.of<UserNavigationCubit>(context)
                                  .getNavBarItem(NavbarUserItem.profile);
                            }
                          },
                        );
                      },
                    ),
                    body: BlocBuilder<UserNavigationCubit, UserNavigationState>(
                      builder: (context, state) {
                        if (state.navbarItem == NavbarUserItem.homePage) {
                          return const UserHomePage(text: 'Homepage');
                          // } else if (state.navbarItem ==
                          //     NavbarItem.previousBreakDown) {
                          //   return const ItemPage(text: 'PreviousBreakDown');
                          // } else if (state.navbarItem == NavbarItem.LocalSMS) {
                          //   return const PaymentPage(text: 'LocalSMS');
                        } else if (state.navbarItem == NavbarUserItem.blogs) {
                          return const BlogPage(
                            text: 'BlogPage',
                          );
                        } else if (state.navbarItem == NavbarUserItem.chat) {
                          return const ChatHomeScreen();
                        } else if (state.navbarItem == NavbarUserItem.profile) {
                          return const ProfilePage(text: 'profile');
                        }
                        return Container();
                      },
                    ),
                  );
                }
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                );
              },
            )));
  }
}
