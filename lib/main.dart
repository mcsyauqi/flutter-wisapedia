import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));
    Map<int, Color> color =
    {
      50:Colors.white.withOpacity(0.1),
      100:Colors.white.withOpacity( .2),
      200:Colors.white.withOpacity( .3),
      300:Colors.white.withOpacity( .4),
      400:Colors.white.withOpacity( .5),
      500:Colors.white.withOpacity( .6),
      600:Colors.white.withOpacity( .7),
      700:Colors.white.withOpacity( .8),
      800:Colors.white.withOpacity( .9),
      900:Colors.white.withOpacity( 1),
    };
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "pop",
        primaryColor: MaterialColor(0XFFFFFFFF, color),
      ),
      home: SplashScreen(),
    );
  }
}
