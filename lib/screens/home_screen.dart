import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:wisapedia/utilities/bloc_provider.dart';
import 'package:wisapedia/utilities/home_bloc.dart';
import 'package:wisapedia/screens/trip_details_screen.dart';
import 'package:wisapedia/screens/new_post_screen.dart';

import '../utilities/api.dart';
import 'bookmarks_screen.dart';
import 'contact_us_screen.dart';
import 'about_and_terms_screen.dart';
import 'my_post.dart';
import 'my_profile.dart';
import 'choose_method_screen.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  final String id;
  User u;

  HomeScreen({Key key, @required this.token, this.id}) : super(key: key);

  HomeScreen.find(this.u, {Key key, @required this.token, this.id})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTab = 0;
  PageController _pageController;
  HomeBloc _bloc;
  bool viewCheck = true;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool viewDetail = false;
  String name;
  User u;
  StreamController _streamController = new StreamController();
  TextEditingController _controller = new TextEditingController();
  File image;
  String avatar = 'https://via.placeholder.com/150';
  bool invalid = false;
  bool navcheck = true;

  @override
  void initState() {
    _bloc = new HomeBloc()
      ..id = widget.id
      ..token = widget.token;
    _pageController = new PageController();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(left: 45),
            child: Image.asset(
              "images/logo.png",
              color: Colors.blue,
              width: 120.0,
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                            child: GestureDetector(
                          onTap: () async {
                            File i = await ImagePicker.pickImage(
                                source: ImageSource.gallery);
                            Api()
                                .uploadAvatar(token: widget.token, image: i)
                                .then((res) async {
                              if (res.statusCode == 200) {
                                setState(() {
                                  image = i;
                                });
                              } else {
                                print("Image not updated");
                              }
                            });
                          },
                          child: CircleAvatar(
                            radius: 70.0,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onTap: () async {
                                  Api()
                                      .deleteAvatar(token: widget.token)
                                      .then((res) async {
                                    if (res.statusCode == 200) {
                                      setState(() {
                                        widget.u.avatar =
                                            "https://wisapedia-uploads.s3-ap-southeast-1.amazonaws.com/default_ava.png";
                                        image = null;
                                      });
                                    } else {
                                      print("Not deleted");
                                    }
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 15.0,
                                  child: Icon(
                                    Icons.delete,
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                            backgroundImage: image == null
                                ? widget.u.avatar == null
                                    ? NetworkImage(avatar)
                                    : NetworkImage(widget.u.avatar)
                                : FileImage(image),
                            backgroundColor: Colors.white,
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    viewDetail = !viewDetail;
                  });
                },
                child: Card(
                  child: Container(
//                    alignment: Alignment.center,
                      child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Text(widget.u.name)),
                                ),
                              )),
                            ],
                          )),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          if (!widget.u.isVerified) {
                            _controller.text = "";

                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) => Center(
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Container(
                                          width: 300.0,
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4.0)),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Image.asset(
                                                "images/logo.png",
                                                color: Colors.blue,
                                                height: 40.0,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16.0),
                                                child: Text(
                                                  "Enter your verification code sent to your email",
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 16.0),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16.0),
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 32.0),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color:
                                                            Colors.blueAccent,
                                                        width: 0.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0)),
                                                  child: TextFormField(
                                                    obscureText: false,
                                                    controller: _controller,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          "Verification Code",
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey[400],
                                                      ),
                                                      border: InputBorder.none,
                                                      prefixIcon: Icon(
                                                        Icons.verified_user,
                                                        color: Colors.grey[400],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 40.0,
                                                alignment: Alignment.center,
                                                child: RawMaterialButton(
                                                  fillColor: Colors.blue,
                                                  onPressed: () async {
                                                    print(_controller.text);
                                                    Api()
                                                        .verifyMe(
                                                            token: widget.token,
                                                            code: _controller
                                                                .text)
                                                        .then((res) {
                                                      if (res.statusCode ==
                                                          200) {
                                                        print(res.statusCode
                                                            .toString());
                                                        setState(() {
                                                          widget.u.isVerified =
                                                              true;
                                                        });

                                                        Navigator.pop(context);
                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                true,
                                                            builder:
                                                                (context) =>
                                                                    Center(
                                                                      child:
                                                                          Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              300.0,
                                                                          padding:
                                                                              EdgeInsets.all(8.0),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(4.0)),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: <Widget>[
                                                                              Image.asset(
                                                                                "images/logo.png",
                                                                                color: Colors.blue,
                                                                                height: 40.0,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                                                child: Text(
                                                                                  "You account has been verified!",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(fontSize: 16.0),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height: 40.0,
                                                                                alignment: Alignment.center,
                                                                                child: RawMaterialButton(
                                                                                  fillColor: Colors.blue,
                                                                                  onPressed: () async {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Text(
                                                                                    "Ok",
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ));
                                                      } else {
                                                        print("Showing error");
                                                        Navigator.pop(context);
                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                true,
                                                            builder:
                                                                (context) =>
                                                                    Center(
                                                                      child:
                                                                          Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              300.0,
                                                                          padding:
                                                                              EdgeInsets.all(8.0),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(4.0)),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: <Widget>[
                                                                              Image.asset(
                                                                                "images/logo.png",
                                                                                color: Colors.blue,
                                                                                height: 40.0,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                                                child: Text(
                                                                                  "Invalid Code",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(fontSize: 16.0),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height: 40.0,
                                                                                alignment: Alignment.center,
                                                                                child: RawMaterialButton(
                                                                                  fillColor: Colors.blue,
                                                                                  onPressed: () async {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Text(
                                                                                    "Ok",
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ));
                                                      }
                                                    });
//                                            print(code);
                                                  },
                                                  child: Text(
                                                    "Ok",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: invalid,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 16.0),
                                                  child: Text(
                                                    "Invalid Code",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 16.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                          }
                        },
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
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          widget.u.isVerified
                                              ? "Verified"
                                              : "Verify Me",
                                          style: TextStyle(
                                              color: widget.u.isVerified
                                                  ? Colors.green
                                                  : Colors.red,
                                              decoration:
                                                  TextDecoration.underline),
                                        )
//                                          StreamBuilder(
//                                            stream: _streamController.stream,
//                                            builder: (context, snapShot) {
//                                              if (snapShot.hasData) {
//                                                dynamic u = jsonDecode(snapShot.data);
//                                                User user;
//
////                                                for (dynamic t in list) {
//                                                  user=User.fromJson(u);
////                                                }
//
//                                                return Text(user.name);
//                                              } else
//                                                return Center(child: CircularProgressIndicator());
//                                            },
//                                          ),
                                        ),
                                  ),
                                )),

//
                              ],
                            )),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: widget.u.bio == "" || widget.u.bio == null
                            ? false
                            : true,
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
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10),
                                          child: Text(
                                            widget.u.bio,
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        )
//                                          StreamBuilder(
//                                            stream: _streamController.stream,
//                                            builder: (context, snapShot) {
//                                              if (snapShot.hasData) {
//                                                dynamic u = jsonDecode(snapShot.data);
//                                                User user;
//
////                                                for (dynamic t in list) {
//                                                  user=User.fromJson(u);
////                                                }
//
//                                                return Text(user.name);
//                                              } else
//                                                return Center(child: CircularProgressIndicator());
//                                            },
//                                          ),
                                        ),
                                  ),
                                )),

//
                              ],
                            )),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
//                                    color: Colors.redAccent,
//                                      alignment: Alignment.center,
                              child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    !viewDetail
                                        ? Icons.keyboard_arrow_down
                                        : Icons.keyboard_arrow_up,
                                    color: Colors.blue,
                                  )),
                            ),
                          )),
                        ],
                      )
                    ],
                  )),
                ),
              ),
              Visibility(
                visible: viewDetail,
                child: Card(
                  child: Container(
//                    alignment: Alignment.center,
                      child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Row(
                              children: <Widget>[
                                Container(
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 10),
                                        child: Icon(
                                          Icons.email,
                                          size: 20,
                                        ))),
                                Expanded(
                                  child: Container(
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 10),
                                          child: Text(widget.u.email))),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Row(
                              children: <Widget>[
                                Container(
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 10),
                                        child: Icon(
                                          Icons.phone,
                                          size: 20,
                                        ))),
                                Expanded(
                                  child: Container(
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 10),
                                          child: Text(widget.u.number))),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Row(
                              children: <Widget>[
                                Container(
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 10),
                                        child: Icon(
                                          Icons.date_range,
                                          size: 20,
                                        ))),
                                Expanded(
                                  child: Container(
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 10),
                                          child: Text(
                                              "${widget.u.birthday.day} ${getMonth(widget.u.birthday.month)} ${widget.u.birthday.year}"))),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                    ],
                  )),
                ),
              ),
              Card(
                child: Container(
//                    alignment: Alignment.center,
                    child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return Details("About");
                          }),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Row(
                              children: <Widget>[
                                Container(
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 10),
                                        child: Icon(
                                          Icons.account_box,
                                          size: 25,
                                          color: Colors.blue,
                                        ))),
                                Expanded(
                                  child: Container(
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 10),
                                          child: Text(
                                            "About",
                                            style: TextStyle(
                                              color: Colors.blue,
                                            ),
                                          ))),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return Details("Terms");
                          }),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Row(
                              children: <Widget>[
                                Container(
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 10),
                                        child: Icon(
                                          Icons.content_copy,
                                          color: Colors.blue,
                                          size: 25,
                                        ))),
                                Expanded(
                                  child: Container(
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 10),
                                          child: Text("Terms and conditions",
                                              style: TextStyle(
                                                color: Colors.blue,
                                              )))),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                    ),
//                    Container(
//                      padding: const EdgeInsets.all(10),
//                      child: Row(
//                        children: <Widget>[
//                          Expanded(
//                            child: Row(
//                              children: <Widget>[
//                                Container(
//                                    child: Padding(
//                                        padding: const EdgeInsets.only(
//                                            top: 8.0, left: 10),
//                                        child: Icon(
//                                          Icons.share,
//                                          color: Colors.blue,
//                                          size: 25,
//                                        ))),
//                                Expanded(
//                                  child: Container(
//                                      child: Padding(
//                                          padding: const EdgeInsets.only(
//                                              top: 8.0, left: 10),
//                                          child: Text("Share",
//                                              style: TextStyle(
//                                                color: Colors.blue,
//                                              )))),
//                                ),
//                              ],
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return ContactUs(widget.token, widget.u);
                          }),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Row(
                              children: <Widget>[
                                Container(
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 10),
                                        child: Icon(
                                          Icons.phone,
                                          size: 25,
                                          color: Colors.blue,
                                        ))),
                                Expanded(
                                  child: Container(
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 10),
                                          child: Text("Contact us",
                                              style: TextStyle(
                                                color: Colors.blue,
                                              )))),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Api().logOut(token: widget.token).then((res) async {
                          if (res.statusCode == 200) {
                            print("Logout");

                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            preferences.clear();

                            Navigator.pushAndRemoveUntil(
                                context,
                                PageRouteBuilder(pageBuilder:
                                    (BuildContext context, Animation animation,
                                        Animation secondaryAnimation) {
                                  return ChooseMethodScreen();
                                }, transitionsBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation,
                                    Widget child) {
                                  return new SlideTransition(
                                    position: new Tween<Offset>(
                                      begin: const Offset(1.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  );
                                }),
                                (Route route) => false);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Row(
                              children: <Widget>[
                                Container(
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 10),
                                        child: Icon(
                                          Icons.lock_open,
                                          color: Colors.blue,
                                          size: 25,
                                        ))),
                                Expanded(
                                  child: Container(
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 10),
                                          child: Text("Log out",
                                              style: TextStyle(
                                                color: Colors.blue,
                                              )))),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Api().logOutAll(token: widget.token).then((res) async {
                          if (res.statusCode == 200) {
                            print("Logout");

                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            preferences.clear();

                            Navigator.pushAndRemoveUntil(
                                context,
                                PageRouteBuilder(pageBuilder:
                                    (BuildContext context, Animation animation,
                                        Animation secondaryAnimation) {
                                  return ChooseMethodScreen();
                                }, transitionsBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation,
                                    Widget child) {
                                  return new SlideTransition(
                                    position: new Tween<Offset>(
                                      begin: const Offset(1.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  );
                                }),
                                (Route route) => false);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Row(
                              children: <Widget>[
                                Container(
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 10),
                                        child: Icon(
                                          Icons.lock_open,
                                          color: Colors.blue,
                                          size: 25,
                                        ))),
                                Expanded(
                                  child: Container(
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 10),
                                          child: Text("Log out All",
                                              style: TextStyle(
                                                color: Colors.blue,
                                              )))),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
//            SizedBox(
//              height: 16.0,
//            ),
            Container(
//              child: Row(
//
//                children: <Widget>[
//                  Container(
//                      alignment: Alignment.center,
//                      child: IconButton(icon: Icon(Icons.menu,))),
//                  Container(
//                    alignment: Alignment.center,
//                    padding: EdgeInsets.only(left: 50),
//                    child: Image.asset(
//                      "images/logo.png",
//                      color: Colors.blue,
//                      width: 120.0,
//                    ),
//                  ),
//                ],
//              ),
//              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Colors.black12, offset: Offset(0.0, 1.0))
                ],
                color: Colors.white,
              ),
              alignment: Alignment.bottomCenter,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (val) {
                  setState(() {
                    currentTab = val;
                    if (val == 3) {
                      navcheck = false;
                    } else {
                      navcheck = true;
                    }
                  });
                },
                children: <Widget>[
                  HomePage(
                    token: widget.token,
                    verify: widget.u.isVerified,
                  ),
                  Bookmark(),
                  MyPost(widget.token, widget.u.isVerified),
                  MyProfile(widget.token),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: widget.u.isVerified && navcheck
            ? FloatingActionButton(
                child: Icon(Icons.create),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return NewPostScreen(
                        token: widget.token,
                        id: widget.id,
                      );
                    }),
                  );
                },
              )
            : Container(),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: currentTab,
          selectedFontSize: 12.0,
          unselectedFontSize: 10.0,
          onTap: (i) {
            setState(() {
              currentTab = i;
              _pageController.jumpToPage(currentTab);
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(MdiIcons.home),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(MdiIcons.bookmark),
              title: Text("Bookmarks"),
            ),
            BottomNavigationBarItem(
              icon: Icon(MdiIcons.post),
              title: Text("My Posts"),
            ),
            BottomNavigationBarItem(
              icon: Icon(MdiIcons.faceProfile),
              title: Text("Profile"),
            ),
          ],
        ),
      ),
    );
  }

  getMonth(int id) {
    String m;
    switch (id) {
      case 1:
        m = "Jan";
        break;
      case 2:
        m = "Feb";
        break;
      case 3:
        m = "Mar";
        break;
      case 4:
        m = "Apr";
        break;
      case 5:
        m = "May";
        break;
      case 6:
        m = "Jun";
        break;
      case 7:
        m = "Jul";
        break;
      case 8:
        m = "Aug";
        break;
      case 9:
        m = "Sep";
        break;
      case 10:
        m = "Otc";
        break;
      case 11:
        m = "Nov";
        break;
      case 12:
        m = "Dec";
        break;
    }
    return m;
  }
}

class HomePage extends StatefulWidget {
  final String token;
  bool verify = true;

  HomePage({Key key, this.token, this.verify}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamController _streamController;

  @override
  void initState() {
    _streamController = new StreamController();

    Api().getPosts(token: widget.token).then((data) {
      if (data.statusCode == 200 && !_streamController.isClosed)
        _streamController.add(data.body);
    });

    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Api().getPosts(token: widget.token).then((data) {
          if (data.statusCode == 200 && !_streamController.isClosed)
            _streamController.add(data.body);

          print("Refresh");
        });
      },
      child: Column(
        children: <Widget>[
          Visibility(
            visible: widget.verify == false ? true : false,
            child: Container(
              color: Colors.red,
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
              margin: const EdgeInsets.only(),
              child: Container(
                color: Colors.red,
                height: 45.0,
                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      "Please Verify Your Account!",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ))
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
            margin: const EdgeInsets.only(),
            child: Material(
              borderRadius: const BorderRadius.all(const Radius.circular(0.0)),
              elevation: 2.0,
              child: Container(
                height: 45.0,
                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                      maxLines: 1,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.search,
                            color: Theme.of(context).accentColor,
                          ),
                          hintText: "Search for trip",
                          border: InputBorder.none),
                    ))
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: StreamBuilder(
              stream: _streamController.stream,
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  List<dynamic> list = jsonDecode(snapShot.data);
                  List<Trip> trips = new List();
                  List<Trip> revTrips = new List();

                  for (dynamic t in list) {
                    trips.add(Trip.fromJson(t));
                  }
                  revTrips.addAll(trips.reversed);

                  return ListView.builder(
                    padding: EdgeInsets.all(0.0),
                    itemBuilder: (context, index) {
                      return new TripIntroTile(
                        trip: revTrips[index],
                        token: widget.token,
                        verify: widget.verify,
                      );
                    },
                    itemCount: trips.length,
                  );
                } else
                  return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TripIntroTile extends StatelessWidget {
  final Trip trip;
  final String token;
  bool verify = true;

  TripIntroTile(
      {Key key, @required this.trip, @required this.token, this.verify})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110.0,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: RawMaterialButton(
          onPressed: () {
            if (verify) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TripDetailsScreen(
                    tripId: trip.id,
                    token: token,
                  ),
                ),
              );
            } else {
              Toast.show("Please Verify your account", context);
            }
          },
          constraints: BoxConstraints.expand(),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  child: Opacity(
                    opacity: !verify ? 0.5 : 1,
                    child: CachedNetworkImage(
                      imageUrl: trip.image,
                      width: 106,
                      height: 106,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                          height: 106,
                          width: 106,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => new SizedBox(),
                    ),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(
                              "Trip to ${trip.destination}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                            Text(
                              trip.createdBefore.inDays > 0
                                  ? "${trip.createdBefore.inDays} day ago"
                                  : trip.createdBefore.inHours > 0
                                      ? "${trip.createdBefore.inHours}h ago"
                                      : "${trip.createdBefore.inMinutes}min ago",
                              style: TextStyle(
                                fontSize: 10.0,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                        Text(
                          "Route: ${trip.route}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: verify ? Colors.blue : Colors.grey,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Details >>>",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: verify ? Colors.red : Colors.grey,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              size: 12.0,
                              color: Colors.grey,
                            ),
                            Text(
                              trip.destination,
                              style:
                                  TextStyle(fontSize: 10.0, color: Colors.grey),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Trip {
  bool isCompleted;
  String id;
  String descriptions;
  String destination;
  String image;
  String createdAt;
  String route;
  String person;
  String whatsapp;
  String budget;
  String capacity;

  Duration createdBefore;

  DateTime startDate;
  DateTime endDate;

  Trip.fromJson(dynamic json) {
    isCompleted = json["completed"];
    person = json["person"].toString();
    id = json["_id"].toString();
    descriptions = json["description"].toString();
    destination = json["destination"].toString();
    image = json["image"].toString();
    createdAt = json["createdAt"].toString();
    route = json["route"].toString();
    whatsapp = json["wa"].toString();
    budget = json["budget"].toString();
    capacity = json["capacity"].toString();

    if (json["start"] != null)
      startDate = DateTime.parse(json["start"].toString());
    if (json["finish"] != null)
      endDate = DateTime.parse(json["finish"].toString());

    createdBefore = DateTime.now().difference(DateTime.parse(createdAt));
  }
}

class User {
  bool isVerified;
  String id;
  String name;
  String email;
  String number;
  String createdAt;
  String bio;
  DateTime birthday;
  String avatar;

  Duration createdBefore;

  DateTime startDate;
  DateTime endDate;

//  DateTime birthday;

  User.fromJson(dynamic json) {
    isVerified = json["verified"];
    bio = json["bio"].toString();
    id = json["_id"].toString();
    name = json["name"].toString();
    email = json["email"].toString();
    number = json["number"].toString();
    createdAt = json["createdAt"].toString();
    birthday = DateTime.parse(json["birthday"].toString());
    avatar = json["avatar"].toString();
    print("Avatar" + avatar);

//    if (json["start"] != null)
//      startDate = DateTime.parse(json["start"].toString());
//    if (json["finish"] != null)
//      endDate = DateTime.parse(json["finish"].toString());
//
//    createdBefore = DateTime.now().difference(DateTime.parse(createdAt));
  }
}
