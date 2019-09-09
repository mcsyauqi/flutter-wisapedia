import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisapedia/screens/home_screen.dart';

import '../utilities/api.dart';
import 'choose_method_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User u;

  @override
  void initState() {
    SharedPreferences.getInstance().then((sharedPref) async {
      String token = sharedPref.getString("token");
      String id = sharedPref.getString("id");
      await loadData(token);

      Future.delayed(
        const Duration(seconds: 2),
        () => Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) {
              if (token == null) {
                return ChooseMethodScreen();
              } else {
                return HomeScreen.find(u, token: token, id: id);
              }
            },
          ),
        ),
      );
    });

    super.initState();
  }

  Future loadData(token) async {
    await Api()
        .getMyProfile(
      token: token,
    )
        .then((data) {
      if (data.statusCode == 200) {
        u = User.fromJson(jsonDecode(data.body));
        return u;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/splash.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
