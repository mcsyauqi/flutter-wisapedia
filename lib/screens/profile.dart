import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:wisapedia/utilities/api.dart';
import 'package:wisapedia/screens/home_screen.dart';

import 'login_screen.dart' as l;

class Profile extends StatefulWidget {
  String token;
  User u;

  Profile(this.token, this.u);

  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  SignUpDetails details;
  Api api;
  bool check = false;
  bool ppAccepted = false;
  TextEditingController _numberController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _bioController = new TextEditingController();

  String name, email, number;

  @override
  void initState() {
    api = new Api();
    details = SignUpDetails();
    _numberController.text = widget.u.number;
    _emailController.text = widget.u.email;
    _bioController.text = widget.u.bio;
    _nameController.text = widget.u.name;
    _passwordController.text = "testtest";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 0.0),
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 28.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 8.0),
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundImage: NetworkImage(widget.u.avatar),
                          backgroundColor: Colors.transparent,
                        ),
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
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: widget.u.name,
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                            ),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
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
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: widget.u.email,
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                            ),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              MdiIcons.emailOutline,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
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
                          obscureText: true,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                            ),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              MdiIcons.keyOutline,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
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
                          controller: _numberController,
                          decoration: InputDecoration(
                            hintText: widget.u.number,
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                            ),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              MdiIcons.phoneOutline,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
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
                                  print(date.toIso8601String());
                                  widget.u.birthday = date;
                                  print(widget.u.birthday);
                                });
                              },
                              currentTime: DateTime.now(),
                            );
                          },
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
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Text(
//                                            u.birthday.toString(),
                                      widget.u.birthday == null
                                          ? "02/12/2019"
                                          : widget.u.birthday.day.toString() +
                                              "/" +
                                              widget.u.birthday.month
                                                  .toString() +
                                              "/" +
                                              widget.u.birthday.year.toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
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
                          maxLines: 3,
                          obscureText: false,
                          controller: _bioController,
                          decoration: InputDecoration(
                            hintText: widget.u.bio,
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                            ),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              MdiIcons.bio,
                              color: Colors.grey[400],
                            ),
                          ),
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
                    ],
                  ),
                ),
              ),
            ],
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

    msg = validateName(_nameController.text);
    if (msg != null) return msg;
    msg = validateEmail(_emailController.text);
    if (msg != null) return msg;
    msg = validateMobile(_numberController.text);
    if (msg != null) return msg;
    msg = validatePassword(_passwordController.text);
    if (msg != null) return msg;
    if (widget.u.birthday == null) return "Enter valid Birthday";
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
          .updateUser(
              name: _nameController.text,
              email: _emailController.text,
              number: _numberController.text,
              birthDay: widget.u.birthday,
              password: _passwordController.text,
              bio: _bioController.text,
              token: widget.token)
          .then(
        (data) {
          print(data.statusCode);
          if (data.statusCode == 200) {
            print(widget.u.name);
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => l.Dialog(
                message: "Successfully Account Updated.",
                onOkPress: () {
                  widget.u.number = _numberController.text;
                  widget.u.email = _emailController.text;
                  widget.u.name = _nameController.text;
                  widget.u.bio = _bioController.text;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen.find(
                              widget.u,
                              token: widget.token,
                              id: widget.u.id,
                            )),
                    ModalRoute.withName('/splashScreen'),
                  );
                },
              ),
            );
          } else {
            Navigator.pop(context);
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => l.Dialog(
                message: "Account not Updated. Please check your info.",
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
