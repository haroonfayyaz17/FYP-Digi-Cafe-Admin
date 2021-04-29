import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/Views/splash_screen.dart';

void main() {
  // SharedPreferences.setMockInitialValues({});
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Splash_Screen(),
    );
  }
}
