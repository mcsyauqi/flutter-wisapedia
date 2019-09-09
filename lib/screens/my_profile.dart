import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisapedia/utilities/api.dart';
import 'package:wisapedia/screens/home_screen.dart';
import 'package:wisapedia/screens/profile.dart';

import 'login_screen.dart' as l;

class MyProfile extends StatefulWidget {
  String token;

  MyProfile(this.token);

  @override
  _MyProfile createState() => _MyProfile();
}

class _MyProfile extends State<MyProfile> {
  SignUpDetails details;
  Api api;
  bool check = false;
  bool ppAccepted = false;
  StreamController _streamController;
  User u;

  @override
  void initState() {
    _streamController = new StreamController();
    api = new Api();
    details = SignUpDetails();
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future loadData() async {
    dynamic data = await Api().getMyProfile(token: widget.token);
    if (!_streamController.isClosed) _streamController.add(data.body);
    return "done";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: _streamController.stream,
            builder: (context, snapShot) {
              if (snapShot.hasData) {
                dynamic j = jsonDecode(snapShot.data);
                u = User.fromJson(j);
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 0.0),
                              child: Text(
                                'Profile',
                                style: TextStyle(
                                  fontSize: 32.0,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.only(top: 5.0, right: 16.0),
                                child: IconButton(
                                    icon: Icon(
                                      MdiIcons.accountEdit,
                                      color: Colors.blue,
                                      size: 24.0,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return Profile(widget.token, u);
                                        }),
                                      );
                                    }),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 0.0, bottom: 8.0),
                              child: CircleAvatar(
                                radius: 70.0,
                                backgroundImage: NetworkImage(u.avatar),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    u.name,
                                    style: TextStyle(
                                        fontSize: 20,
                                        decoration: TextDecoration.underline),
                                  ),
                                )),
                              ],
                            ),
                            Visibility(
                              visible:
                                  u.bio == "" || u.bio == null ? false : true,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Row(
                                    children: <Widget>[
                                      Expanded(
//                                    color: Colors.redAccent,
//                                      alignment: Alignment.center,
                                          child: Container(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                u.bio,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.blue),
                                              )),
                                        ),
                                      )),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            InputArea(
                              hint: u.email,
                              icon: MdiIcons.emailOutline,
                              onInputChange: (v) {
                                u.email = v;
                              },
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            InputArea(
                              hint: u.number,
                              icon: MdiIcons.phoneOutline,
                              onInputChange: (v) {
                                u.number = v;
                              },
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Container(
                              height: 48.0,
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(horizontal: 32.0),
                              child: RawMaterialButton(
                                constraints: BoxConstraints.expand(),
                                onPressed: () {},
                                child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.calendar,
                                          color: Colors.grey,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12),
                                          child: Text(
                                            u.birthday == null
                                                ? "02/12/2019"
                                                : "${u.birthday.day}/${u.birthday.month}/${u.birthday.year}",
                                            style: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            Visibility(
                              visible: check,
                              child: Container(
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
                                      'Save',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                      ),
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
                );
              } else
                return Center(
                  child: CircularProgressIndicator(),
                );
            },
          ),
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
      child: TextFormField(
        obscureText: widget.obs,
        controller: _controller,
        enabled: false,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: Colors.black38,
          ),
          border: InputBorder.none,
          prefixIcon: Icon(
            widget.icon,
            color: Colors.black38,
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
