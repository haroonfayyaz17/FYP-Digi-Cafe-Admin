import 'package:digi_cafe_admin/Controllers/DBControllers/LoginDBController.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Views/admin_Dashboard.dart';
import 'package:digi_cafe_admin/style/colors.dart';

class AdminLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(
        backgroundColor: colors.backgroundColor,
        primaryColor: colors.buttonColor,
        cursorColor: colors.cursorColor,
      ),
      home: Scaffold(
        body: AdminLogin(),
      ),
    );
  }
}

class AdminLogin extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<AdminLogin> {
  var adminEmail = 'digiCafeAdmin@gmail.com';

  var adminPassword = 'admin123';
  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }

  Future<void> loadUser() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    bool user = prefs.getBool('isUser') ?? false;
    LoginDBController dbController = new LoginDBController();
    if (user) {
      dbController.CheckSignIn(adminEmail, adminPassword);
    } else {
      dbController.CreateNewUser(adminEmail, adminPassword);
      await prefs.setBool('isUser', true);
    }
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => new dashboard()));
  }
}
