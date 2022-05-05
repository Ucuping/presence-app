import 'package:flutter/material.dart';
import 'package:myapp/constants/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer {
  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static customDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _drawerHeader(),
          _drawerItem(
              icon: Icons.camera_alt,
              text: "Presence",
              onTap: () {
                Navigator.pushNamed(context, '/presence');
              }),
          _drawerItem(
              icon: Icons.history,
              text: "Presence History",
              onTap: () {
                Navigator.pushNamed(context, '/history');
              }),
          _drawerItem(
              icon: Icons.account_circle,
              text: "Profile",
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              }),
        ],
      ),
    );
  }

  @override
  static _drawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(image: const DecorationImage(image: AssetImage("assets/images/bg.jpg"), fit: BoxFit.cover)),
      accountName: Text(
        "John Doe",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      accountEmail: Text("john@example.com", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
      currentAccountPicture: ClipOval(
        child: Image(
          image: AssetImage("assets/images/profile.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  static _drawerItem({required IconData icon, required String text, required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            color: primaryColor,
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.0),
            child: Text(
              text,
              // style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
