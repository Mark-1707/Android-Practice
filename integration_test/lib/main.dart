import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:developer' as developer;
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart' as awen;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:integration_test/shared/bloc/bottom_navigation/admin_navigation_cubit.dart';
import 'package:integration_test/shared/bloc/check_box_bloc/checkbox_bloc.dart';
import 'package:integration_test/shared/bloc/department/department_bloc.dart';
import 'package:integration_test/shared/bloc/division/division_bloc.dart';
import 'package:integration_test/shared/bloc/group/group_bloc.dart';
import 'package:integration_test/shared/bloc/railway/railway_bloc.dart';
import 'package:integration_test/shared/bloc/show_dept_by_Id/show_depart_bloc.dart';
import 'package:integration_test/shared/bloc/update_address/update_address_bloc.dart';
import 'package:integration_test/shared/bloc/update_password/update_password_bloc.dart';
import 'package:integration_test/shared/bloc/user_details/user_details_bloc.dart';
import 'package:integration_test/shared/bloc/zone/zone_bloc.dart';
import 'package:integration_test/shared/bloc/get_employee/employee_bloc.dart';
import 'package:integration_test/shared/bloc/show_address/address_bloc.dart';
import 'package:integration_test/shared/repository/railway_repository.dart';
import 'package:telephony/telephony.dart';
import 'package:vibration/vibration.dart';
import 'common_export.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'shared/bloc/bottom_navigation/home_navigation_cubit.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'utils/notify.dart';

//Telephony telephony = Telephony.instance;

Telephony telephony = Telephony.instance;
final service = FlutterBackgroundService();

//String sms = " ";
//String onapp = '';
String thirdmesage1 = 'Breakdown Train';
String thirdmessage2 = 'By Team VASP Group';
String breakdowntrain = 'Breakdown Train Ordered. VASP GROUP (Enterprises)';
String againsms = '!! Siren Testing !!! Whenever Breakdown Train';
String againsms2 =
    'Ordered such Siren sound will ring in your mobile. By Team VASP Group';
final subStrings = <String>[
  againsms,
  againsms2,
  breakdowntrain,
  thirdmesage1,
  thirdmessage2
];

bool containsAny(String text, List<String> substrings) {
  for (var substring in substrings) {
    if (text.contains(substring)) return true;
  }
  return false;
}

int maxduration = 100;
int currentpos = 0;
String currentpostlabel = "Emergency Sciren";
String audioasset = "audio/siren_small.mp3";
bool isplaying = false;
bool audioplayed = false;
//final _audioHandler = getIt<AudioHandler>();
AudioPlayer player = AudioPlayer();
late Uint8List audiobytes;

//late AudioHandler _audioHandler; // singleton.

// close Audio palyer in flutter
var data = 'Breakdown Train';

@pragma('vm:entry-point')
backgroundMessageHandler(SmsMessage message) {
  //final audioHandler = getIt<AudioHandler>();
  try {
    if (message.body != null) {
      if (kDebugMode) {
        print("Background ${message.body}");
      }

      Timer(const Duration(seconds: 1), () async {
        if (containsAny(message.body!, subStrings)) {
          Vibration.vibrate(duration: 1000);
          player.play(AssetSource(audioasset));
          Notify.instantNotify(message.body!);
        } else {}
      });
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

//final service = FlutterBackgroundService();

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _initializeFirebase();
  //await initializeApp();
  //setupServiceLocator();
  // _audioHandler = await AudioService.init(
  //   builder: () => AudioPlayerHandler(),
  //   config: const AudioServiceConfig(
  //     androidNotificationChannelId: 'com.integration_test.audio',
  //     androidNotificationChannelName: 'Audio Service Demo',
  //     androidNotificationOngoing: true,
  //     androidStopForegroundOnPause: true,
  //   ),
  // );

  //await player.setSource(AssetSource(audioasset));

  await SharedPrefs.instance.init();
  final authenticationService = AuthenticationRepository();
  final getRailwayService = RailwayRepository();

  /// Initialize packages
  //await EasyLocalization.ensureInitialized();
  // if (Platform.isAndroid) {
  //   await FlutterDisplayMode.setHighRefreshRate();
  // }
  final Directory tmpDir = await getTemporaryDirectory();
  Hive.init(tmpDir.toString());
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  awen.AwesomeNotifications().initialize(
    null,
    [
      awen.NotificationChannel(
        channelGroupKey: 'alert',
        channelKey: 'instant_notification',
        channelName: 'Basic Instant Notification',
        channelDescription:
            'Notification channel that can trigger notification instantly.',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        playSound: true,
        //soundSource: audioasset,
        enableVibration: true,
      ),
    ],
  );

  final SharedPrefs prefs = SharedPrefs.instance;

  final currentUserId = prefs.getUserId();
  if (currentUserId != null) {
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        try {
          if (message.body != null) {
            Timer(const Duration(seconds: 5), () async {
              if (containsAny(message.body!, subStrings)) {
                //player.play();
                player.play(AssetSource(audioasset));
                if (kDebugMode) {
                  print('Forground play');
                }
                Vibration.vibrate(duration: 500);
                SmartDialog.show(
                    backDismiss: true,
                    tag: 'tag',
                    clickMaskDismiss: false,
                    builder: (_) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text(
                          'Breakdown Train',
                          style: TextStyle(color: Colors.black),
                        ),
                        content: Text(
                          message.body!,
                          style: const TextStyle(color: Colors.black),
                        ),
                        actions: [
                          TextButton(
                              child: const Text("Close"),
                              onPressed: () {
                                player.stop();
                                SmartDialog.dismiss(tag: 'tag');
                              }),
                          ElevatedButton(
                            onPressed: () async {
                              player.stop();
                              SmartDialog.dismiss(tag: 'tag');
                            },
                            child: const Text("Stop"),
                          ),
                        ],
                      );
                    });
                //assetsAudioPlayer.play();
                //playAudio();
              }
            });
          } else {
            player.stop();
          }
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      },
      listenInBackground: true,
      onBackgroundMessage: backgroundMessageHandler,
    );
  }

  Bloc.observer = SimpleBlocObserver();

  awen.AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      awen.AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext context) => AuthenticationBloc(
            authenticationService: authenticationService,
          ),
        ),
        BlocProvider<UpdateThemeBloc>(
          create: (BuildContext context) => UpdateThemeBloc(),
        ),
        BlocProvider<UserNavigationCubit>(
          create: (BuildContext context) => UserNavigationCubit(),
        ),
        BlocProvider<AdminNavigationCubit>(
          create: (BuildContext context) => AdminNavigationCubit(),
        ),
        BlocProvider<CheckboxBloc>(
          create: (BuildContext context) => CheckboxBloc(
              // customerNameService: customerNameService,
              ),
        ),
        BlocProvider<RailwayBloc>(
          create: (BuildContext context) => RailwayBloc(
            railwayService: getRailwayService,
          ),
        ),
        BlocProvider<ZoneBloc>(
          create: (BuildContext context) => ZoneBloc(
            railwayService: getRailwayService,
          ),
        ),
        BlocProvider<DivisionBloc>(
          create: (BuildContext context) => DivisionBloc(
            railwayService: getRailwayService,
          ),
        ),
        BlocProvider<DepartmentBloc>(
          create: (BuildContext context) => DepartmentBloc(
            railwayService: getRailwayService,
          ),
        ),
        BlocProvider<EmployeeBloc>(
          create: (BuildContext context) =>
              EmployeeBloc(employeeService: getRailwayService),
        ),
        BlocProvider<AddressBloc>(
          create: (BuildContext context) =>
              AddressBloc(addressService: getRailwayService),
        ),
        BlocProvider<UpdateAddressBloc>(
          create: (BuildContext context) =>
              UpdateAddressBloc(updateAddressService: getRailwayService),
        ),
        BlocProvider<ShowDepartByIdBloc>(
          create: (BuildContext context) =>
              ShowDepartByIdBloc(showDepartByIdService: getRailwayService),
        ),
        BlocProvider<UpadatePasswordBloc>(
          create: (BuildContext context) => UpadatePasswordBloc(
            updatepasswordService: authenticationService,
          ),
        ),
        BlocProvider<GroupBloc>(
          create: (BuildContext context) => GroupBloc(),
        ),
        BlocProvider<UserDetailsBloc>(
          create: (BuildContext context) => UserDetailsBloc(
            authenticationService: authenticationService,
          ),
        ),
      ],
      child: const App(),
    ),
  );
}

class SimpleBlocObserver extends BlocObserver {
  // Transition
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    developer.log(transition.toString());
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp();
  var result = await FlutterNotificationChannel.registerNotificationChannel(
      description: 'For Showing Message Notification',
      id: 'chats',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'Chats');
  log('\nNotification Channel Result: $result');
}

initializeApp() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

Future<bool> onIosBackground(ServiceInstance serviceInstance) async {
  return true;
}

onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.setAsBackgroundService();
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });

    service.on('playSound').listen((event) {
      //playAudio();
    });
    service.on('stopSound').listen((event) {
      //stopAudio();
    });
  }
}
