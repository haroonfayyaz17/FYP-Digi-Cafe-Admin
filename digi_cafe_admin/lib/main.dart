import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/Views/splash_screen.dart';
import 'package:digi_cafe_admin/Views/SignUp.dart';
import 'package:digi_cafe_admin/Views/admin_Dashboard.dart';
import 'package:digi_cafe_admin/Views/ViewEmployees.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new ViewEmployees(),
    );
  }
}
