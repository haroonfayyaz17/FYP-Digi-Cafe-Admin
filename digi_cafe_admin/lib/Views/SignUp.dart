import 'package:digi_cafe_admin/Controllers/LoginController.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _SignUpScreen(),
    );
  }
}

class _SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<_SignUpScreen> {
  bool _buttonPressed = false;

  TextEditingController edtControllerEmail = new TextEditingController();
  LoginController _loginController;
  TextEditingController edtControllerPassword = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _loginController = new LoginController();
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
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
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: edtControllerEmail,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      labelText: 'Email',
                      icon: Icon(
                        Icons.email,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: edtControllerPassword,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      labelText: 'Password',
                      icon: Icon(
                        Icons.lock,
//                    color: colors.iconButtonColor,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: colors.buttonColor,
                  ),
                  width: 200,
                  height: 50,
                  child: FlatButton(
                    child: Stack(
                      children: <Widget>[
                        Visibility(
                          visible: !_buttonPressed,
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontFamily: Fonts.default_font,
                              color: colors.buttonTextColor,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _buttonPressed,
                          child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        _buttonPressed = true;
                        _loginController.CreateNewUser(edtControllerEmail.text,
                            edtControllerPassword.text);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
