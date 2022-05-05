import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/constants/theme.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/pages/presence.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:myapp/data/data.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool visible = false;

  var resData;

  @override
  void initState() {
    checkAuth();
    super.initState();
  }

  Future<void> sendData() async {
    setState(() {
      visible = true;
    });

    String username = usernameController.text;
    String password = passwordController.text;
    final SharedPreferences prefs = await _prefs;

    var url = "https://api-presence-app.herokuapp.com/api/v1/auth/login";

    var data = {"username": username, "password": password};

    var response =
        await http.post(Uri.parse(url), body: json.encode(data), headers: {
      'Content-Type': 'application/json',
      'Charset': 'utf-8',
    });

    if (response.statusCode == 200) {
      resData = json.decode(response.body);

      await prefs.setString("jwt", resData["data"]["token"]);
      // await prefs.setString("name", resData["data"]["name"]);
      // await prefs.setString("email", resData["data"]["email"]);

      setState(() {
        visible = false;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(resData["message"]),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.pushNamed(context, "/presence");
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(resData["message"]),
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

  void checkAuth() {
    Future.delayed(Duration.zero, () async {
      final SharedPreferences prefs = await _prefs;
      if (prefs.containsKey("jwt")) {
        Navigator.pushNamed(context, "/presence");
      }
    });
  }

  bool usernameFocused = false, passwordFocused = false;

  bool usernameValue = false, passwordValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Sign In",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Focus(
                        onFocusChange: (hasFocus) {
                          setState(() {
                            hasFocus
                                ? usernameFocused = true
                                : usernameFocused = false;
                            usernameController.text != ''
                                ? usernameValue = true
                                : usernameValue = false;
                          });
                        },
                        child: TextFormField(
                          controller: usernameController,
                          keyboardType: TextInputType.text,
                          decoration: new InputDecoration(
                            hintText: "Username",
                            labelText: "Username",
                            prefixIcon: Icon(
                              Icons.person,
                              color: usernameValue
                                  ? primaryColor
                                  : (usernameFocused
                                      ? primaryColor
                                      : Colors.grey),
                            ),
                            labelStyle: TextStyle(
                                color: usernameValue
                                    ? primaryColor
                                    : (usernameFocused
                                        ? primaryColor
                                        : Colors.grey)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: usernameValue
                                        ? primaryColor
                                        : Colors.grey)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor)),
                            border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0)),
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              // print(usernameErr);
                              return "Username is required";
                            }
                            //  else if (usernameErr != "") {
                            //   return usernameErr;
                            // }
                            return null;
                          },
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Focus(
                        onFocusChange: (hasFocus) {
                          setState(() {
                            hasFocus
                                ? passwordFocused = true
                                : passwordFocused = false;
                            passwordController.text != ''
                                ? passwordValue = true
                                : passwordValue = false;
                          });
                        },
                        child: TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: new InputDecoration(
                            hintText: "Password",
                            labelText: "Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: passwordValue
                                  ? primaryColor
                                  : (passwordFocused
                                      ? primaryColor
                                      : Colors.grey),
                            ),
                            suffixIcon: Icon(
                              Icons.remove_red_eye,
                              color: passwordValue
                                  ? primaryColor
                                  : (passwordFocused
                                      ? primaryColor
                                      : Colors.grey),
                            ),
                            labelStyle: TextStyle(
                              color: passwordValue
                                  ? primaryColor
                                  : (passwordFocused
                                      ? primaryColor
                                      : Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: passwordValue
                                        ? primaryColor
                                        : Colors.grey)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor)),
                            border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0)),
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Password is required";
                            }
                            // else if (passwordErr != "") {
                            //   return passwordErr;
                            // }
                            return null;
                          },
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: primaryColor,
                          onPrimary: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            sendData();
                          }
                        },
                        child: Text("Log In"),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Visibility(
                        visible: visible,
                        child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ))),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
