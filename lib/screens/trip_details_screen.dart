import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisapedia/utilities/api.dart';
import 'package:wisapedia/screens/home_screen.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wisapedia/screens/login_screen.dart' as prefix0;

class TripDetailsScreen extends StatefulWidget {
  final String tripId;
  final String token;
  final bool canJoin;
  final String uid;

  const TripDetailsScreen({
    Key key,
    this.tripId,
    this.token,
    this.canJoin = true,
    this.uid,
  }) : super(key: key);

  @override
  _TripDetailsScreenState createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  StreamController _streamController;
  String id;
  String name = "Loading";
  User u;
  Trip trip;

  @override
  void initState() {
    _streamController = new StreamController();

    loadData();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 16.0,
              ),
              Container(
                child: Image.asset(
                  "images/logo.png",
                  color: Colors.blue,
                  width: 120.0,
                ),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.black12, offset: Offset(0.0, 1.0))
                  ],
                  color: Colors.white,
                ),
                alignment: Alignment.bottomCenter,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _streamController.stream,
                  builder: (context, snapShot) {
                    if (!snapShot.hasData || snapShot.data == null)
                      return Center(
                        child: CircularProgressIndicator(),
                      );

                    try {
                      trip = Trip.fromJson(jsonDecode(snapShot.data));
                      id = trip.person;
                    } catch (e) {
                      return new Warning(
                        warning: "Try Again in few minutes",
                      );
                    }
                    return ListView(
                      padding: EdgeInsets.all(0.0),
                      children: <Widget>[
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ClipRRect(
                              child: CachedNetworkImage(
                                height: 220.0,
                                width: double.infinity,
                                imageUrl: trip.image,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    new SizedBox(),
                              ),
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0)),
                        ),
                        Center(
                          child: Text(
                            "Trip to ${trip.destination}",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "${trip.startDate.day} ${getMonth(trip.startDate.month)} ${trip.startDate.year},   ${trip.startDate.hour}:${trip.startDate.minute.toString().padLeft(2, "0")}",
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      RaisedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) => Container(
                                              child: SpinKitWave(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          );
                                          Api()
                                              .addBookmark(
                                                  token: widget.token,
                                                  id: widget.tripId)
                                              .then((data) {
                                            Navigator.pop(context);
                                            if (data.statusCode == 200) {
                                              print(data.body);
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) =>
                                                      prefix0.Dialog(
                                                        message:
                                                            "Bookmark added",
                                                        onOkPress: () {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ));
                                            }
                                          });
                                        },
                                        color: Colors.white,
                                        child: SizedBox(
                                          width: 100.0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.bookmark,
                                                color: Colors.blue,
                                              ),
                                              Text(
                                                "Bookmark",
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Details",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  _buildRow(
                                      title: "Destination",
                                      value: trip.destination),
                                  _buildRow(
                                      title: "Budget",
                                      value: "Rp." + trip.budget),
                                  _buildRow(title: "Route", value: trip.route),
                                  _buildRow(
                                      title: "Capacity", value: trip.capacity),
                                  FutureBuilder(
                                    future: loadUserData(trip.person),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.none:
                                        case ConnectionState.active:
                                        case ConnectionState.waiting:
                                          return _buildRow(
                                              title: "Owner", value: "Loading");
                                        case ConnectionState.done:
                                          if (snapshot.hasError)
                                            return _buildRow(
                                                title: "Owner",
                                                value: "Reload again");
                                          else
                                            return _buildRow(
                                                title: "Owner",
                                                value: u == null
                                                    ? "User not found"
                                                    : u.name);
                                      }
                                    },
                                  ),
                                  _buildRow(
                                      title: "Start",
                                      value:
                                          "${trip.startDate.day} ${getMonth(trip.startDate.month)} ${trip.startDate.year}"),
                                  _buildRow(
                                      title: "Finish",
                                      value:
                                          "${trip.endDate.day} ${getMonth(trip.endDate.month)} ${trip.endDate.year}"),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(
                                    "Descriptions",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Text(
                                    trip.descriptions,
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 34.0, left: 8.0),
              child: IconButton(
                  icon: Icon(
                    Icons.close,
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
      bottomNavigationBar: widget.canJoin
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  onPressed: () async {
                    if (u != null) {
                      await launch("sms:<" + u.number + ">");
                    }
                  },
                  color: Colors.deepOrange,
                  child: SizedBox(
                    width: 70.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.message,
                          color: Colors.white,
                        ),
                        Text(
                          "SMS",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () async {
                    await FlutterLaunch.launchWathsApp(
                        phone: trip == null ? "" : trip.whatsapp, message: "");
                  },
                  color: Colors.green,
                  child: SizedBox(
                    width: 100.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          MdiIcons.whatsapp,
                          color: Colors.white,
                        ),
                        Text(
                          "Whatsapp",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () async {
                    if (u != null) {
                      await launch("tel:<" + u.number + ">");
                    }
                  },
                  color: Colors.blue,
                  child: SizedBox(
                    width: 70.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          MdiIcons.callMade,
                          color: Colors.white,
                        ),
                        Text(
                          "Call",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : SizedBox(),
    );
  }

  Padding _buildRow({String title, String value}) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            title,
            style: TextStyle(color: Colors.black54, fontSize: 12.0),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(":"),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12.0),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Future loadData() async {
    Response res = await Api().getPostDetails(
      token: widget.token,
      id: widget.tripId,
    );

    if (!_streamController.isClosed) _streamController.add(res.body);
    return "done";
  }

  Future loadUserData(String uid) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    print("Mine" + sp.getString("id"));
    print("trip" + uid);
    String userId = uid.substring(1, uid.length - 1);
    print(userId);
    await Api().readUser(token: widget.token, uid: userId).then((data) {
      if (data.statusCode == 200) {
        u = User.fromJson(jsonDecode(data.body));
        return u;
      } else {}
    });
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

class Warning extends StatelessWidget {
  final String warning;

  const Warning({
    Key key,
    this.warning,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
            height: 32.0,
            child: Image.asset(
              "images/logo.png",
              color: Colors.black26,
            )),
        SizedBox(
          height: 16.0,
        ),
        Text(
          warning,
          style: TextStyle(color: Colors.black26, fontSize: 20.0),
        )
      ],
    );
  }
}
