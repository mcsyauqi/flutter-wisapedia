import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:wisapedia/utilities/bloc_provider.dart';
import 'package:wisapedia/utilities/home_bloc.dart';
import 'package:wisapedia/utilities/api.dart';
import 'package:wisapedia/screens/trip_details_screen.dart';
import 'package:wisapedia/screens/home_screen.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({Key key}) : super(key: key);

  @override
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  StreamController<String> _streamController;
  HomeBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<HomeBloc>(context);
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
    return StreamBuilder(
        stream: _streamController.stream,
        builder: (context, snapShot) {
          if (snapShot.hasData && snapShot.data != null) {
            //print(snapShot.data);
            dynamic json = jsonDecode(snapShot.data);
            List<dynamic> list =
                !json.runtimeType.toString().contains("List") ? List() : json;
            List<Trip> trips = new List();

            for (dynamic t in list) {
              trips.add(Trip.fromJson(t));
            }
            if (trips.length > 0)
              return ListView.builder(
                itemBuilder: (context, index) => SizedBox(
                  height: 92.0,
                  child: new BookmarkView(
                      trip: trips[index],
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TripDetailsScreen(
                                      tripId: trips[index].id,
                                      token: _bloc.token,
                                    )));
                      },
                      onDelete: () {
                        Navigator.pop(context);
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
                            .removeBookmark(
                                token: _bloc.token, id: trips[index].id)
                            .then((data) {
                          //print(data.body);
                          loadData().then((v) {
                            Navigator.pop(context);
                          });
                        });
                      }),
                ),
                itemCount: trips.length,
              );
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
                  "No Bookmarks",
                  style: TextStyle(color: Colors.black26, fontSize: 20.0),
                )
              ],
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        });
  }

  Future loadData() async {
    Response res = await Api().getBookmarks(
      token: _bloc.token,
      id: _bloc.id,
    );
    //print(res.statusCode);
    if (!_streamController.isClosed) _streamController.add(res.body);
    return "done";
  }
}

class BookmarkView extends StatelessWidget {
  final Trip trip;
  final Function() onDelete;
  final Function() onPress;

  const BookmarkView({
    Key key,
    this.trip,
    this.onDelete,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: RawMaterialButton(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: <Widget>[
              ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: trip.image,
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                      height: 88,
                      width: 88,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => new SizedBox(),
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
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "${trip.startDate.day} ${getMonth(trip.startDate.month)} ${trip.startDate.year},   ${trip.startDate.hour}:${trip.startDate.minute.toString().padLeft(2, "0")}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Details >>>",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              onTap: () {},
                              leading:
                                  Icon(Icons.content_copy, color: Colors.blue),
                              title: Text(
                                "Copy link",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            ListTile(
                              onTap: onDelete,
                              leading: Icon(MdiIcons.deleteOutline,
                                  color: Colors.blue),
                              title: Text("Remove bookmark",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        onPressed: onPress,
        constraints: BoxConstraints.expand(),
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
