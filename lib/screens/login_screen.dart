import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisapedia/screens/home_screen.dart';
import 'package:wisapedia/screens/sign_up_screen.dart';

import '../utilities/api.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  SignInDetails details;
  Api api;

  @override
  void initState() {
    details = new SignInDetails();
    api = Api();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 64.0, bottom: 40.0),
                child: Image.asset(
                  'images/logo.png',
                  width: 140.0,
                  color: Colors.blue,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                        child: Text(
                          'Welcome!',
                          style: TextStyle(
                            fontSize: 36.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      InputArea(
                        hint: 'Email address',
                        icon: MdiIcons.emailOutline,
                        onInputChange: (v) {
                          details.email = v;
                        },
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      InputArea(
                        hint: 'Password',
                        obs: true,
                        icon: MdiIcons.keyOutline,
                        onInputChange: (v) {
                          details.password = v;
                        },
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 32.0),
                        height: 64.0,
                        child: RawMaterialButton(
                          constraints: BoxConstraints.expand(),
                          fillColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                          onPressed: _submit,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40.0,
                              vertical: 8.0,
                            ),
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                      /*Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 34.0,
                        ),
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          child: Text(
                            "Forget Password?",
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),*/
                      SizedBox(
                        height: 48.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Don't have an account?"),
                          GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpScreen()));
                              },
                              child: Text(
                                " Sign up",
                                style: TextStyle(color: Colors.blue),
                              )),
                        ],
                      ),
                      /*Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 32.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 0.2,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              "OR",
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 14.0,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                              child: Container(
                                height: 0.2,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Sign in with ",
                            style: TextStyle(
                                fontWeight: FontWeight.w100,
                                color: Colors.grey[600]),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Container(
                            height: 32.0,
                            width: 90.0,
                            child: RawMaterialButton(
                              fillColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0)),
                              constraints: BoxConstraints.expand(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    MdiIcons.facebook,
                                    color: Colors.white,
                                    size: 16.0,
                                  ),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  Text(
                                    "facebook",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12.0),
                                  ),
                                ],
                              ),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Container(
                            height: 32.0,
                            width: 90.0,
                            child: RawMaterialButton(
                              fillColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0)),
                              constraints: BoxConstraints.expand(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    MdiIcons.google,
                                    color: Colors.white,
                                    size: 16.0,
                                  ),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  Text(
                                    "Google",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12.0),
                                  ),
                                ],
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),*/
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 32.0, right: 16.0),
              child: IconButton(
                  icon: Icon(
                    MdiIcons.close,
                    color: Colors.blue,
                    size: 24.0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          )
        ],
      ),
    );
  }

  void _submit() {
    String msg;

    msg = details.validateEmail();
    if (msg == null) msg = details.validatePassword();

    if (msg != null) {
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          child: Text(
            msg,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Container(
          child: SpinKitWave(
            color: Colors.blue,
          ),
        ),
      );
      api
          .loginUser(
        email: details.email,
        password: details.password,
      )
          .then(
        (data) {
          print(data.body);
          if (data.statusCode == 200) {
            dynamic json = jsonDecode(data.body);
            SharedPreferences.getInstance().then((sharedPref) async {
              await sharedPref.setString("token", json["token"]);
              await sharedPref.setString("id", User.fromJson(json['user']).id);
              print(sharedPref.getString("id"));
              User u;
              await Api()
                  .getMyProfile(
                token: json["token"],
              )
                  .then((data) {
                if (data.statusCode == 200) {
                  u = User.fromJson(jsonDecode(data.body));
                  print(u.name);
                }
              });
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => Dialog(
                  message: "Sign in successful",
                  onOkPress: () async {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen.find(
                                u,
                                token: json["token"],
                                id: json["id"],
                              )),
                      ModalRoute.withName('/splashScreen'),
                    );
                  },
                ),
              );
            });
          } else {
            Navigator.pop(context);
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => new Dialog(
                message: "Sign in not successful.Please check your details.",
                onOkPress: () {
                  Navigator.pop(context);
                },
              ),
            );
          }
        },
      );
    }
  }
}

class Dialog extends StatelessWidget {
  final String message;
  final Function onOkPress;

  const Dialog({
    Key key,
    this.message,
    this.onOkPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 300.0,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(4.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                "images/logo.png",
                color: Colors.blue,
                height: 40.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              Container(
                height: 40.0,
                alignment: Alignment.center,
                child: RawMaterialButton(
                  fillColor: Colors.blue,
                  onPressed: onOkPress,
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SignInDetails {
  String password;
  String email;

  String validatePassword() {
    if (password == null || password.length < 7)
      return 'Password must be of more than 6 digit';
    else
      return null;
  }

  String validateEmail() {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (email == null || !regex.hasMatch(email))
      return 'Enter Valid Email';
    else
      return null;
  }
}
