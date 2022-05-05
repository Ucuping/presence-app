import 'package:flutter/material.dart';
import 'package:myapp/constants/theme.dart';
import 'package:myapp/pages/history.dart';
import 'package:myapp/pages/presence.dart';
import 'package:myapp/pages/profile.dart';
import 'package:myapp/pages/signIn.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SignIn());
      case '/presence':
        return MaterialPageRoute(builder: (_) => Presence());
      case '/history':
        return MaterialPageRoute(builder: (_) => History());
      case '/profile':
        return MaterialPageRoute(builder: (_) => Profile());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Error"),
          backgroundColor: primaryColor,
        ),
        body: Center(
          child: Text(
            "Error Page",
          ),
        ),
      );
    });
  }
}
