import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:geocoding/geocoding.dart';
import 'package:integration_test/utils/size_utils.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';
import 'package:geolocator/geolocator.dart';
import '../../shared/bloc/show_dept_by_Id/show_depart_bloc.dart';
import '../../shared/bloc/update_address/update_address_bloc.dart';
import '../../shared/shared.dart';

class UserHomePage extends StatefulWidget {
  final String text;
  const UserHomePage({super.key, required this.text});
  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final SharedPrefs prefs = SharedPrefs.instance;

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;
  late final UpdateAddressBloc updateAddressBloc;
  late final ShowDepartByIdBloc showDepartByIdBloc;
  bool? isCheckedIn;

  @override
  void initState() {
    super.initState();
    updateAddressBloc = BlocProvider.of<UpdateAddressBloc>(context);
    showDepartByIdBloc = BlocProvider.of<ShowDepartByIdBloc>(context);
    //print(int.parse(prefs.getUserdeptid()!));
    showDepartByIdBloc
        .add(GetShowDepartByIdData(id: int.parse(prefs.getUserdeptid()!)));

    setState(() {
      isCheckedIn = prefs.getCheckIn() ?? false;
    });
    getLocation();

    
  }

  String first = "";
  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    permission = await Geolocator.requestPermission();
    List<Placemark> addresses =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      first =
          '${addresses.first.locality},${addresses.first.subLocality}, ${addresses.first.postalCode}';
    });
    // print("${first.name} : ${first..administrativeArea}");
    if (kDebugMode) {
      print(position.longitude);
      print(position.latitude);
    }

    long = position.longitude.toString();
    lat = position.latitude.toString();

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      if (kDebugMode) {
        print(position.longitude);
        print(position.latitude);
      }

      long = position.longitude.toString();
      lat = position.latitude.toString();
      setState(() {
        //refresh UI on update
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        actionsIconTheme: Theme.of(context).appBarTheme.actionsIconTheme,
        titleTextStyle: Theme.of(context).primaryTextTheme.titleLarge,
        centerTitle: true,
        title: const Text(
          'Rapid Response App for BD&DM',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(5),
                  child: ImageSlideshow(
                    width: double.infinity,
                    height: 100,
                    initialPage: 0,
                    indicatorColor: const Color.fromARGB(255, 36, 27, 27),
                    onPageChanged: (value) {},
                    autoPlayInterval: 2000,
                    isLoop: true,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/railwayslide.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset('assets/images/railway-trac.jpg',
                            fit: BoxFit.cover),
                      ),
                    ],
                  ),
                ),
                //--Attendace page start here
                SizedBox(height: 18.toResponsiveHeight),
                Center(
                  child: Text(
                    first,
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontFamily: 'Roboto',
                      color: Color.fromARGB(255, 255, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 18.toResponsiveHeight),

                SizedBox(
                  child: WidgetCircularAnimator(
                    size: 150,
                    child: GestureDetector(
                        child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor:
                              isCheckedIn! ? Colors.red : Colors.green),
                      onPressed: !isCheckedIn!
                          ? () {
                              updateAddressBloc.add(UserUpdateaddress(
                                latitude: lat,
                                longitude: long,
                                time: DateTime.now().toString(),
                                eId: int.parse(prefs.getEid()!),
                              ));
                              prefs.setChechIn(true);
                              setState(() {
                                isCheckedIn = prefs.getCheckIn();
                              });
                            }
                          : () {
                              prefs.setChechIn(false);
                              setState(() {
                                isCheckedIn = prefs.getCheckIn();
                              });
                            },
                      child: isCheckedIn!
                          ? const Text("Check out")
                          : const Text("Check In"),
                    )),
                  ),
                ),
                // SizedBox(height: 60.toResponsiveHeight),

                // Center(
                //   child: ElevatedButton(
                //       onPressed: () async {
                //         player.stop();
                //       },
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: isSiren! ? Colors.red : Colors.green,
                //         padding:
                //             EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                //       ),
                //       child: Text("Stop Siren")),
                // ),

                // TextButton(
                //     child: Text("data"),
                //     onPressed: (() {
                //       Navigator.push(context,
                //           MaterialPageRoute(builder: (context) => HomePage()));
                //     })),
              ],
            )),
      ),
    );
  }
}
