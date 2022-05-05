import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:myapp/constants/theme.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/models/presence_model.dart';
import 'package:myapp/pages/presence.dart';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
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

      var url = "https://api-presence-app.herokuapp.com/api/v1/presences/get-data";

      final SharedPreferences prefs = await _prefs;

      final String? jwt = prefs.getString("jwt");

      var response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Charset': 'utf-8',
        'Authorization': "Bearer ${jwt}"
      });
      resData = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          dataloaded = true;
          visible = false;
        });
      } else {
        setState(() {
          error = true;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Presence History"),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: (dataloaded || error) ? dataLoadedInfo() : loadingInfo(),
      ),
    );
  }

  Widget loadingInfo() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/loading-get-data.png"),
          Visibility(
              visible: true,
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
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
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 20),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                minimumSize: Size(double.infinity, 50),
              ),
              child: const Text('Kembali'),
            ),
          ],
        ),
      );
    } else if (resData['data'] != null && resData['data'].length == 0) {
      return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/data-error.png"),
            Text(
              "Opps!",
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Text("Tidak ada data"),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                minimumSize: Size(double.infinity, 50),
              ),
              child: const Text('Scan QR'),
            ),
          ],
        ),
      );
    } else {
      List<PresenceModel> dataList = List<PresenceModel>.from(resData["data"].map((i) {
        return PresenceModel.fromJSON(i);
      }));
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: dataList.map((e) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/detail');
              },
              child: Container(
                height: 150,
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.only(left: 16, top: 4, right: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tanggal :",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Tipe :',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Waktu :', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Latitude :', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Longitude :', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Deskripsi :', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.only(top: 4, right: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.date,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  e.type,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(e.time,
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(e.latitude,
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(e.longitude,
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(e.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }
  }
}
