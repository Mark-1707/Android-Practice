import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../common_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SharedPrefs prefs = SharedPrefs.instance;
  late AuthenticationBloc authenticationBloc;

  // bool servicestatus = false;
  // bool haspermission = false;
  // late LocationPermission permission;

  // locationPermission() async {
  //   servicestatus = await Geolocator.isLocationServiceEnabled();
  //   if (servicestatus) {
  //     permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         if (kDebugMode) {
  //           print('Location permissions are denied');
  //         }
  //       } else if (permission == LocationPermission.deniedForever) {
  //         if (kDebugMode) {
  //           print("'Location permissions are permanently denied");
  //         }
  //       } else {
  //         haspermission = true;
  //       }
  //     } else {
  //       haspermission = true;
  //     }
  //     if (haspermission) {
  //       //   getLocation();
  //     }
  //   } else {
  //     if (kDebugMode) {
  //       print("GPS Service is not enabled, turn on GPS location");
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    UiSizeConfig().init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        bloc: authenticationBloc,
        listener: (BuildContext context, AuthenticationState state) {
          if (state is AppAutheticated) {
            if (state.usertype == 1) {
              context.go('/adminRoot');
            } else {
              context.go('/userRoot');
            }
          }
          if (state is AuthenticationStart) {
            context.go('/login');
          }
          if (state is UserLogoutState) {
            context.go('/login');
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            bloc: authenticationBloc,
            builder: (BuildContext context, AuthenticationState state) {
              return Center(
                  child: Image.asset(
                AllImages().splash,
                width: 350.toResponsiveWidth,
                height: 300.toResponsiveHeight,
              ));

              //return const Center(child: Text('RapidResponseApp'));
            }),
      ),
    );
  }

  @override
  void initState() {
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    authenticationBloc.add(const AppLoadedup());
    final currentUserId = prefs.getUserId();
    if (currentUserId != null) {
      authenticationBloc.add(const LoggedIn(status: true));
    }
    super.initState();
  }
}
