import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/api_sdk/dio/models/blog_model.dart';
import 'package:integration_test/screens/admin_root/root_screen.dart';
import 'package:integration_test/screens/blog/blog_details_page.dart';
import 'package:integration_test/screens/blog/create_blog.dart';
import 'package:integration_test/screens/update_password/update_password_screen.dart';
import 'package:integration_test/screens/user_root/root_screen.dart';

import '../api_sdk/dio/models/employee_model.dart';
import '../common_export.dart';
import '../screens/admin_home_page/widget/emoyee_details.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/userRoot',
      builder: (BuildContext context, GoRouterState state) {
        return const UserRootScreen();
      },
    ),
    GoRoute(
      path: '/adminRoot',
      builder: (BuildContext context, GoRouterState state) {
        return const AdminRootScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        return const SignUpScreen();
      },
    ),
    /*GoRoute(
      path: '/employee/:eId',
      builder: (BuildContext context, GoRouterState state) {
        return EmployeeInfoPage(eId: state.pathParameters["eId"]!);
      },
    ),*/
    GoRoute(
      path: '/employeeDetails',
      builder: (BuildContext context, GoRouterState state) {
        Datum data = state.extra as Datum;
        return EmployeeInfoPage(data: data);
      },
    ),
    GoRoute(
      path: '/createBlog',
      builder: (BuildContext context, GoRouterState state) {
        return const CreateBlogPage();
      },
    ),
    GoRoute(
      path: '/blogDetailsBlog',
      builder: (BuildContext context, GoRouterState state) {
        BlogsModel blogsModel = state.extra as BlogsModel;
        return BlogDetails(blogsModel: blogsModel);
      },
    ),
    GoRoute(
      path: '/updatePassword',
      builder: (BuildContext context, GoRouterState state) {
        return const UpdatePasswordScreen();
      },
    ),
    GoRoute(
      path: '/updateGroup',
      builder: (BuildContext context, GoRouterState state) {
        return const UpdatePasswordScreen();
      },
    ),
  ],
);

/// routes for the app  Without go_router
// import 'package:flutter_starter/flutter_starter.dart';

// import 'package:flutter/material.dart';

// Route routes(RouteSettings settings) {
//   switch (settings.name) {
//     case '/':
//       return MaterialPageRoute(builder: (_) => const SplashScreen());
//     case '/home':
//       return MaterialPageRoute(builder: (_) => const HomeScreen());
//     case '/auth':
//       return MaterialPageRoute(builder: (_) => const AuthenticationScreen());
//     default:
//       return MaterialPageRoute(builder: (_) => const SplashScreen());
//   }
// }
