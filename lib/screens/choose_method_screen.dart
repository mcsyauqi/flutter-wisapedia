import 'package:flutter/material.dart';
import 'package:wisapedia/screens/sign_up_screen.dart';

import 'login_screen.dart';

class ChooseMethodScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Container(
                color: Colors.blue,
                child: Image.asset(
                  'images/choose.jpg',
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
            Text(
              'Find a travel partner with Wisapedia.\n Travel together and share the adventure',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "sh", fontSize: 20.0, color: Colors.blue),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Center(
                child: Container(
                  height: 48.0,
                  width: 220.0,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(4.0)),
                  child: RawMaterialButton(
                    constraints: BoxConstraints.expand(),
                    fillColor: Colors.blue,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return LoginScreen();
                        }),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        'SIGN IN',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              child: Center(
                child: Container(
                  height: 48.0,
                  width: 220.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 0.5),
                      borderRadius: BorderRadius.circular(4.0)),
                  child: RawMaterialButton(
                    constraints: BoxConstraints.expand(),
                    fillColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return SignUpScreen();
                        }),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        'Create Account',
                        style: TextStyle(color: Colors.blue, fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
