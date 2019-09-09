import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisapedia/utilities/api.dart';
import 'package:wisapedia/screens/home_screen.dart';

import 'login_screen.dart' as l;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpDetails details;
  Api api;
  TextEditingController phoneController = new TextEditingController();

  bool ppAccepted = false;

  @override
  void initState() {
    api = new Api();
    details = SignUpDetails();
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
                padding: const EdgeInsets.only(top: 48.0, bottom: 16.0),
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
                        padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                        child: Text(
                          'Create an account',
                          style: TextStyle(
                            fontSize: 32.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32.0,
                      ),
                      new InputArea(
                        hint: "Name",
                        icon: Icons.person_outline,
                        onInputChange: (value) {
                          details.name = value;
                          //print(details.name);
                        },
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      InputArea(
                        hint: "Email address",
                        icon: MdiIcons.emailOutline,
                        onInputChange: (v) {
                          details.email = v;
                        },
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      InputArea(
                        hint: "Password",
                        obs: true,
                        icon: MdiIcons.keyOutline,
                        onInputChange: (v) {
                          details.password = v;
                        },
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 32.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueAccent,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(4.0)),
                        child: TextFormField(
                          obscureText: false,
                          controller: phoneController,
                          decoration: InputDecoration(
                            hintText: "Phone Number",

                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                            ),
                            border: InputBorder.none,

                            prefixText: "+62|",
                            // prefix: Text("+62",style: TextStyle(color: Colors.black),),
                            prefixIcon: Icon(
                              MdiIcons.phoneOutline,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 8.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Date of Birth:",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                      Container(
                        height: 48.0,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 32.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueAccent,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(4.0)),
                        child: RawMaterialButton(
                          constraints: BoxConstraints.expand(),
                          onPressed: () {
                            DatePicker.showDatePicker(
                              context,
                              showTitleActions: true,
                              maxTime:
                                  DateTime.now().subtract(Duration(days: 3650)),
                              onConfirm: (date) {
                                setState(() {
                                  details.dateOfBirth = date;
                                });
                              },
                              currentTime: DateTime.now(),
                            );
                          },
                          child: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                details.dateOfBirth == null
                                    ? "02/12/2019"
                                    : "${details.dateOfBirth.day}/${details.dateOfBirth.month}/${details.dateOfBirth.year}",
                                style: TextStyle(
                                    color: details.dateOfBirth == null
                                        ? Colors.grey
                                        : Colors.black,
                                    fontSize: 16.0),
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Checkbox(
                                value: ppAccepted,
                                onChanged: (v) {
                                  setState(() {
                                    ppAccepted = v;
                                  });
                                }),
                            Expanded(
                              child: Text(
                                  "By clicking Sign up, you agree to the wisapedia Terms , condition and Privacy policy"),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 32.0),
                        height: 64.0,
                        width: 240.0,
                        child: RawMaterialButton(
                          constraints: BoxConstraints.expand(),
                          fillColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                          onPressed: _submit,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
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

  String validateName(String value) {
    if (value == null || value.length < 4)
      return 'Name must be more than 4 charater';
    else
      return null;
  }

  String validateMobile(String value) {
    if (value == null || value.length < 10)
      return 'Mobile Number must be of more than 10 digit';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value == null || value.length < 7)
      return 'Password must be of more than 6 digit';
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value == null || !regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String _checkInputs() {
    String msg;

    msg = validateName(details.name);
    if (msg != null) return msg;
    msg = validateEmail(details.email);
    if (msg != null) return msg;
    msg = validateMobile(details.phoneNumber);
    if (msg != null) return msg;
    msg = validatePassword(details.password);
    if (msg != null) return msg;
    if (details.dateOfBirth == null) return "Enter valid Birthday";
    if (!ppAccepted)
      return "You need to accept Terms, Condition and Privacy policy";
    return msg;
  }

  void _submit() async {
    details.phoneNumber = "+62" + phoneController.text;
    String msg = _checkInputs();
    if (msg == null) {
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
          .createNewUser(
        name: details.name,
        email: details.email,
        password: details.password,
        number: details.phoneNumber,
        birthDay: details.dateOfBirth,
      )
          .then(
        (data) {
          //print(data.statusCode);
          if (data.statusCode == 201) {
            dynamic json = jsonDecode(data.body);
            SharedPreferences.getInstance().then((sharedPref) async {
              await sharedPref.setString("token", json["token"]);
              await sharedPref.setString("id", json["_id"]);
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
                builder: (context) => l.Dialog(
                  message: "Successfuly Account created.",
                  onOkPress: () {
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
              builder: (context) => l.Dialog(
                message: "Account not created. Please check your info.",
                onOkPress: () {
                  Navigator.pop(context);
                },
              ),
            );
          }
        },
      );
    } else
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
  }
}

class InputArea extends StatefulWidget {
  final String hint;
  final Function(String value) onInputChange;
  final IconData icon;
  final bool obs;

  const InputArea({
    Key key,
    @required this.hint,
    @required this.onInputChange,
    this.icon,
    this.obs = false,
  }) : super(key: key);

  @override
  _InputAreaState createState() => _InputAreaState();
}

class _InputAreaState extends State<InputArea> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = new TextEditingController();
    _controller.addListener(() {
      widget.onInputChange(_controller.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32.0),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blueAccent,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(4.0)),
      child: TextFormField(
        obscureText: widget.obs,
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
          border: InputBorder.none,
          prefixIcon: Icon(
            widget.icon,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }
}

class SignUpDetails {
  String name;
  String email;
  String password;
  String phoneNumber;
  DateTime dateOfBirth;
}
