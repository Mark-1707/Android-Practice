import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:integration_test/utils/notification_controller.dart';
import 'common_export.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {  

  @override
  void initState() {
    NotificationController.startListeningNotificationEvents();
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder<UpdateThemeBloc, UpdateThemeState>(
      builder: (context, state) {
        /// Without go_router we should return MaterialApp() with
        /// {onGenerateRoute: routes}
        /// routes from routes.dart
        return MaterialApp.router(
          // navigatorObservers: [FlutterSmartDialog.observer],
          builder: FlutterSmartDialog.init(),
          debugShowCheckedModeBanner: false,
          //title: 'Hello World!',
          theme: ThemeConfig.lightTheme,
          darkTheme: ThemeConfig.darkTheme,
          themeMode: state is SetTheme
              ? state.appTheme == AppTheme.light
                  ? ThemeMode.light
                  : ThemeMode.dark
              : ThemeMode.light,
          // onGenerateRoute: routes,
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,

          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          // locale: const Locale('fr'),
        );
      },
    );
  }
}
