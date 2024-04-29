import 'package:country_app/view/sign_in_screen.dart';
import 'package:country_app/view/sign_up_screen.dart';
import 'package:flutter/material.dart';

import '../../view/city_list_screen.dart';
import 'routes_name.dart';

class Routes {
  static Route<dynamic> routeBuilder(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.cityList:
        return MaterialPageRoute(
            builder: (BuildContext context) => const CityListScreen());

      case RoutesName.signIn:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SignInScreen());
      case RoutesName.signUp:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SignUpScreen());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text('No route defined')),
          );
        });
    }
  }

  static void goToMainScreen(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        RoutesName.cityList, (Route<dynamic> route) => false);
  }

  static void goToSignUpScreen(BuildContext context) {
    Navigator.of(context).pushNamed(RoutesName.signUp);
  }

  static void goToSignInScreen(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        RoutesName.signIn, (Route<dynamic> route) => false);
  }
}
