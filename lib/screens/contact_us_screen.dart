import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wisapedia/utilities/api.dart';
import 'package:wisapedia/screens/home_screen.dart';

import 'login_screen.dart' as l;

class ContactUs extends StatefulWidget {
  final String token;
  final User u;

  ContactUs(this.token, this.u);

  @override
  _ContactUs createState() => _ContactUs();
}

class _ContactUs extends State<ContactUs> {
  bool ppAccepted = false;
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
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
                        padding: const EdgeInsets.only(top: 10),
                        child: Center(
                          child: Text(
                            "Contact Us",
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              'images/about.jpg',
                              width: 140.0,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, right: 25, top: 10),
                                child: Text(
                                    "Untok respon yang labih cepat sampaikan pertanyaan atau permintaan Anda melalui formulir ini",
                                    style: TextStyle(color: Colors.blue)),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "Sampaikan permasalahan Anda:",
                                style: TextStyle(
                                    color: Colors.lightBlue, fontSize: 16),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 0.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                margin: EdgeInsets.symmetric(horizontal: 20.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blueAccent,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0)),
                                child: TextFormField(
                                  obscureText: false,
                                  maxLines: 4,
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    hintText: "Write text...",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            )
                          ],
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
        height: 64.0,
        width: 240.0,
        child: RawMaterialButton(
          constraints: BoxConstraints.expand(),
          fillColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          onPressed: _submit,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: Text(
              'Submit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _submit() {
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
        .contactUs(token: widget.token, description: _controller.text)
        .then((res) {
      if (res.statusCode == 200) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => l.Dialog(
            message: "Response successfully submitted",
            onOkPress: () {
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
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => l.Dialog(
            message: "Response Submission Failed",
            onOkPress: () {
              Navigator.pop(context);
            },
          ),
        );
      }
    });
  }
}
