import 'package:flutter/material.dart';
import 'package:myapp/constants/theme.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          backgroundColor: primaryColor,
        ),
        body: Center(
          child: Text("Coming Soon!"),
        ));
  }
}
