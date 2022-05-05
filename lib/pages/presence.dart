import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/constants/theme.dart';
import 'package:myapp/drawer/customDrawer.dart';
import 'package:myapp/controllers/barcode_scanner_controller.dart';
import 'package:myapp/controllers/barcode_scanner_without_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import 'package:geolocator/geolocator.dart';

class Presence extends StatefulWidget {
  @override
  _PresenceState createState() => _PresenceState();
}

class _PresenceState extends State<Presence> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var jwt;

  @override
  void initState() {
    checkAuth();
    position();
    super.initState();
  }

  Future<void> logout() async {
    var url = "https://api-presence-app.herokuapp.com/api/v1/auth/logout";

    final SharedPreferences prefs = await _prefs;

    final String? jwt = prefs.getString("jwt");

    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
      'Authorization': "Bearer ${jwt}"
    });

    if (response.statusCode == 200) {
      await prefs.remove('jwt');
      await prefs.remove('qrData');
      await prefs.remove('latitude');
      await prefs.remove('longitude');
      await prefs.remove('name');
      await prefs.remove('email');
      Navigator.pushNamed(context, "/");
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Error"),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void position() {
    Future.delayed(Duration.zero, () async {
      final SharedPreferences prefs = await _prefs;
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      var location = await Geolocator.getCurrentPosition();
      prefs.setDouble("latitude", location.latitude);
      prefs.setDouble("longitude", location.longitude);
    });
  }

  void checkAuth() {
    Future.delayed(Duration.zero, () async {
      final SharedPreferences prefs = await _prefs;
      if (!prefs.containsKey("jwt")) {
        Navigator.pushNamed(context, "/");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Presence App"),
          backgroundColor: primaryColor,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  await _showAlertDialog(context);
                },
                child: Icon(Icons.logout),
              ),
            )
          ],
        ),
        drawer: CustomDrawer.customDrawer(context),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/qrcode.png"),
                  Text(
                    "Ayo lakukan absensi!",
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Tekan tombol Scan QR untuk melakukan absensi"),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const BarcodeScannerWithController(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      onPrimary: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: const Text('Scan QR'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  _showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Ya!"),
      onPressed: () {
        logout();
      },
    );

    Widget cancelButton = FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("Cancel"));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Exit"),
      content: Text("Apakah anda yakin?"),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
