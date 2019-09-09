import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:toast/toast.dart';
import 'package:wisapedia/screens/home_screen.dart';

import '../utilities/api.dart';
import 'login_screen.dart' as l;

class NewPostScreen extends StatefulWidget {
  final String token;
  final String id;

  const NewPostScreen({Key key, this.token, this.id}) : super(key: key);

  @override
  _NewPostScreen createState() => _NewPostScreen();
}

class _NewPostScreen extends State<NewPostScreen> {
  File image;
  NewPost post;
  TextEditingController whatsappcontroller = new TextEditingController();

  @override
  void initState() {
    post = NewPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          "Create Post",
          style: TextStyle(color: Colors.blue),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 8.0),
        children: <Widget>[
          new InputArea(
            onChange: (v) {
              post.destination = v;
            },
          ),
          new DatePickerArea(
            icon: MdiIcons.calendarEdit,
            title: "Departure",
            hint: "Date of deperture",
            onChange: (v) {
              post.departureDate = v;
            },
          ),
          new DatePickerArea(
            icon: MdiIcons.calendarEdit,
            title: "Return",
            hint: "Date of return",
            onChange: (v) {
              post.returnDate = v;
            },
          ),
          InputArea(
            icon: Icons.person,
            title: "Total Person",
            hint: "Max tourists",
            inputType: TextInputType.number,
            onChange: (v) {
              post.maxPerson = v;
            },
          ),
          InputArea(
            icon: Icons.monetization_on,
            title: "Budget",
            hint: "Budget Details",
            inputType: TextInputType.number,
            onChange: (v) {
              post.budget = v;
            },
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            child: Row(
              children: <Widget>[
                Icon(
                  MdiIcons.whatsapp,
                  color: Colors.grey,
                  size: 40.0,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Whatsapp",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.phone,
                        controller: whatsappcontroller,
                        maxLines: 1,
                        style: TextStyle(fontSize: 14.0),
                        decoration: InputDecoration(
                            hintText: "Phone number",
                            prefix: Text("+62|"),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.6,
                                color: Colors.black,
                              ),
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 4.0)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // InputArea(
          //   icon: MdiIcons.whatsapp,
          //   title: "Whatsapp",
          //   hint: "Whatsapp number",
          //   inputType: TextInputType.number,
          //   onChange: (v) {
          //     post.whatsapp = v;
          //   },
          // ),
          new InputArea(
            icon: MdiIcons.routes,
            title: "Routes",
            hint: "Routes details",
            onChange: (v) {
              post.route = v;
            },
          ),
          new InputArea(
            lines: 3,
            icon: Icons.featured_play_list,
            title: "Details",
            hint: "Details about the tour",
            onChange: (v) {
              post.description = v;
            },
          ),
          Center(
            child: Container(
              height: 140.0,
              width: 140.0,
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                  )
                ],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: RawMaterialButton(
                constraints: BoxConstraints.expand(),
                onPressed: () async {
                  File i =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    post.imageFile = i;
                  });
                },
                child: post.imageFile == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            MdiIcons.cameraImage,
                            size: 80.0,
                            color: Colors.grey,
                          ),
                          Text(
                            "Upload Photo",
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      )
                    : Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(post.imageFile),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            child: Container(
              height: 48.0,
              child: RawMaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                fillColor: Colors.blue,
                child: Text(
                  "SUBMIT",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
                onPressed: () {
                  if (post.imageFile == null) {
                    Toast.show("Please Select Image", context);
                  } else {
                    post.whatsapp = "+62" + whatsappcontroller.text;
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
                        .makePost(
                            token: widget.token,
                            destination: post.destination,
                            description: post.description,
                            route: post.route,
                            person: post.maxPerson,
                            endDate: post.returnDate.toString(),
                            startDate: post.departureDate.toString(),
                            image: post.imageFile,
                            budget: post.budget,
                            whatsapp: post.whatsapp)
                        .then((data) {
                      Navigator.pop(context);
                      if (data.statusCode == 201)
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => l.Dialog(
                            message: "Successfuly post created.",
                            onOkPress: () async {
                              User u;
                              await Api()
                                  .getMyProfile(
                                token: widget.token,
                              )
                                  .then((data) {
                                if (data.statusCode == 200) {
                                  u = User.fromJson(jsonDecode(data.body));
                                  print(u.name);
                                }
                              });
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen.find(
                                          u,
                                          token: widget.token,
                                          id: widget.id,
                                        )),
                                ModalRoute.withName('/splashScreen'),
                              );
                            },
                          ),
                        );
                      else
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => l.Dialog(
                            message: "Post unsuccessful",
                            onOkPress: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                    });
                  }
                },
                constraints: BoxConstraints.expand(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class NewPost {
  String destination;
  String description;
  String route;
  String budget;
  DateTime departureDate;
  DateTime returnDate;
  File imageFile;

  String maxPerson;
  String whatsapp;
}

class InputArea extends StatefulWidget {
  final int lines;
  final TextInputType inputType;
  final IconData icon;
  final String title;
  final String hint;
  final Function(String) onChange;

  const InputArea({
    Key key,
    this.lines = 1,
    this.icon = Icons.location_on,
    this.title = "Location",
    this.hint = "Place to visit",
    this.onChange,
    this.inputType,
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
      widget.onChange(_controller.text);
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: Row(
        children: <Widget>[
          Icon(
            widget.icon,
            color: Colors.grey,
            size: 40.0,
          ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                  ),
                ),
                TextField(
                  keyboardType: widget.inputType,
                  controller: _controller,
                  maxLines: widget.lines,
                  style: TextStyle(fontSize: 14.0),
                  decoration: InputDecoration(
                      hintText: widget.hint,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.6,
                          color: Colors.black,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DatePickerArea extends StatefulWidget {
  final IconData icon;
  final String title;
  final String hint;
  final DateTime date;
  final Function(DateTime) onChange;

  const DatePickerArea(
      {Key key, this.icon, this.title, this.hint, this.onChange, this.date})
      : super(key: key);

  @override
  _DatePickerAreaState createState() => _DatePickerAreaState();
}

class _DatePickerAreaState extends State<DatePickerArea> {
  DateTime dateTime;

  @override
  void initState() {
    dateTime = widget.date ?? dateTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: Row(
        children: <Widget>[
          Icon(
            widget.icon,
            color: Colors.grey,
            size: 40.0,
          ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  theme: DatePickerTheme(),
                  onConfirm: (date) {
                    setState(() {
                      dateTime = date;
                      widget.onChange(date);
                    });
                  },
                  currentTime: DateTime.now(),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 1.2),
                      ),
                    ),
                    child: Text(
                      dateTime == null
                          ? widget.hint
                          : "${dateTime.hour} : ${dateTime.minute.toString().padLeft(2, "0")},    ${dateTime.day} ${getMonth(dateTime.month)}  ${dateTime.year}",
                      style: TextStyle(
                        color: dateTime == null ? Colors.black54 : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
