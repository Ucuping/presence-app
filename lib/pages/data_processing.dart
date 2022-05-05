import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/constants/theme.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/pages/presence.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataProcessing extends StatefulWidget {
  @override
  _DataProcessingState createState() => _DataProcessingState();
}

class _DataProcessingState extends State<DataProcessing> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var resData;
  bool error = false, dataloaded = false, visible = false;
  @override
  void initState() {
    sendData();
    super.initState();
  }

  void sendData() {
    Future.delayed(Duration.zero, () async {
      setState(() {
        visible = true;
      });

      var url = "https://api-presence-app.herokuapp.com/api/v1/presences/store";

      final SharedPreferences prefs = await _prefs;

      final String? jwt = prefs.getString("jwt");

      var data = {
        "qr": prefs.getString("qrData"),
        "latitude":
            prefs.containsKey("latitude") ? prefs.getDouble("latitude") : null,
        "longitude":
            prefs.containsKey("longitude") ? prefs.getDouble("longitude") : null
      };

      var response =
          await http.post(Uri.parse(url), body: json.encode(data), headers: {
        'Content-Type': 'application/json',
        'Charset': 'utf-8',
        'Authorization': "Bearer ${jwt}"
      });
      resData = json.decode(response.body);
      if (response.statusCode == 200) {
        await prefs.remove('qrData');
        setState(() {
          dataloaded = true;
          visible = false;
        });
      } else {
        await prefs.remove('qrData');
        setState(() {
          error = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: (dataloaded || error) ? dataLoadedInfo() : loadingInfo()));
  }

  Widget loadingInfo() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/data-processing.png"),
          Visibility(
              visible: visible,
              child: Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ))),
          SizedBox(
            height: 10,
          ),
          Text(
            "Mohon Tunggu!",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "Sedang memproses data...",
            // style: TextStyle(
            //     fontSize: 18),
          ),
          // Text(data)
        ],
      ),
    );
  }

  Widget dataLoadedInfo() {
    if (error) {
      return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/data-error.png"),
            Text(
              "Opps!",
              style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Text(resData['message']),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Presence(),
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
              child: const Text('Kembali'),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/data-storage.png"),
            Text(
              "Berhasil!",
              style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            resData['data'] != null
                ? Text(
                    "Anda berhasil melakukan absensi, pada tanggal ${resData['data']['date']}, jam ${resData['data']['time_in']}, deskripsi ${resData['data']['description']}")
                : Text(resData['message']),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Presence(),
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
              child: const Text('Kembali'),
            ),
          ],
        ),
      );
    }
  }
}
