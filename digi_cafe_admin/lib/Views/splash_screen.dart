import 'dart:async';

import 'package:digi_cafe_admin/Views/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:digi_cafe_admin/style/colors.dart';

class Splash_Screen extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Splash_Screen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: colors.backgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 200,
                height: 200,
                padding: EdgeInsets.only(left: 25),
                child: Image.asset('images/logo.png'),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Digi Cafe',
                  style: TextStyle(
                    fontSize: Fonts.heading1_size,
                    fontFamily: Fonts.default_font,
                  ),
                ),
              ),
              Text(
                'Admin',
                style: TextStyle(
                  fontSize: Fonts.heading2_size,
                  fontFamily: Fonts.default_font,
                ),
              ),
              Container(
                width: 200,
                padding: EdgeInsets.only(top: 50),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
