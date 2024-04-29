import 'dart:io';

import 'package:flutter/material.dart';

import 'res/style/app_colors.dart';
import 'utils/dimens/dimens_manager.dart';
import 'utils/routes/routes.dart';
import 'utils/routes/routes_name.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialization(null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

Future initialization(BuildContext? context) async {
  await Future.delayed(const Duration(seconds: 4));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DimensManager();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Country app',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        fontFamily: 'Nunito',
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: AppColors.primaryColor),
      ),
      navigatorObservers: [routeObserver],
      initialRoute: RoutesName.signIn,
      onGenerateRoute: Routes.routeBuilder,
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..maxConnectionsPerHost = 5
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
