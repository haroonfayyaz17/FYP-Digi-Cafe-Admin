import 'package:digi_cafe_admin/style/Icons/customIcons.dart';
import 'package:digi_cafe_admin/Views/admin_Dashboard.dart';
import 'package:digi_cafe_admin/Views/Forgot Password Screen.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:digi_cafe_admin/Controllers/DBControllers/LoginDBController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
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
        body: _LoginScreen(),
      ),
    );
  }
}

class _LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen> {
  bool _buttonPressed = false;
  bool _passwordHide = true;

  Icon _passwordIcon = Icon(
    Icons.remove_red_eye,
    size: 22,
  );
  TextEditingController edtTextControllerEmail;

  TextEditingController edtTextControllerPassword;

  var adminEmail = 'ayeshaghani1998@gmail.com';
  bool _displayLabel = false;
  var adminPassword = 'admin123';
  LoginDBController dbController;

  var errorHeading = '';

  @override
  void initState() {
    super.initState();
    edtTextControllerEmail = new TextEditingController();
    edtTextControllerPassword = new TextEditingController();
    dbController = new LoginDBController();

    dbController.CheckSignIn(adminEmail, adminPassword).then((value) {
      if (value == 'wrong email') {
        dbController.CreateNewUser(adminEmail, adminPassword);
      }
    });
    // if (dbController.CheckSignIn(adminEmail, adminPassword) == null) {
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: colors.backgroundColor,
        child: Center(
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
                    'Digi Café',
                    style: TextStyle(
                      fontSize: Fonts.heading1_size,
                      fontFamily: Fonts.default_font,
                    ),
                  ),
                ),
                _displayLabel
                    ? Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Text(
                          '$errorHeading',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: Fonts.default_font,
                            fontSize: Fonts.dialog_heading_size,
                          ),
                        ))
                    : Container(),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    autofocus: true,
                    controller: edtTextControllerEmail,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      fillColor: colors.backgroundColor,
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
                    autofocus: true,
                    controller: edtTextControllerPassword,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      fillColor: colors.backgroundColor,
                      suffixIcon: InkWell(
                        child: _passwordIcon,
                        onTap: () {
                          setState(() {
                            _passwordHide = !_passwordHide;
                            if (_passwordHide) {
                              _passwordIcon = Icon(
                                Icons.remove_red_eye,
                                size: 22,
                              );
                            } else {
                              _passwordIcon = Icon(
                                PasswordCross.eye_slash,
                                size: 22,
                              );
                            }
                          });
                        },
                      ),
                      labelText: 'Password',
                      icon: Icon(
                        Icons.lock,
//                    color: colors.iconButtonColor,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: _passwordHide,
                  ),
                ),

                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: InkWell(
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontFamily: Fonts.default_font,
                          fontSize: Fonts.heading3_size,
                          color: colors.buttonColor,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen()));
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Container(
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
                              'Sign In',
                              style: TextStyle(
                                fontFamily: Fonts.default_font,
                                color: colors.buttonTextColor,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _buttonPressed,
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        setState(() {
                          _buttonPressed = true;
                        });
                        checkSignIn();
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Container(
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(Radius.circular(10)),
                //       border: Border.all(
                //         width: 1.0,
                //         style: BorderStyle.solid,
                //       )),
                //   width: 200,
                //   height: 50,
                //   child: FlatButton(
                //     onPressed: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => SignUpScreen()));
                //     },
                //     child: Text(
                //       'Create new Account',
                //       style: TextStyle(
                //         fontFamily: Fonts.default_font,
                //         color: colors.buttonColor,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkSignIn() async {
    if (edtTextControllerEmail.text != '' &&
        edtTextControllerPassword.text != '') {
      String email = edtTextControllerEmail.text
          .replaceAll(new RegExp(r"\s+"), "")
          .toLowerCase();
      if (email == adminEmail) {
        await dbController.CheckSignIn(email, edtTextControllerPassword.text)
            .then((value) {
          if (value == 'wrong email') {
            setState(() {
              _displayLabel = true;
              _buttonPressed = false;

              errorHeading = 'Incorrect Email';
            });
          } else if (value == 'wrong password') {
            setState(() {
              _buttonPressed = false;

              _displayLabel = true;
              errorHeading = 'Incorrect Password';
            });
          } else {
            setState(() {
              _buttonPressed = false;
              _displayLabel = false;
              _passwordHide = true;
              edtTextControllerPassword.text = '';
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => dashboard(email: email)));
          }
        });
      } else {
        setState(() {
          _displayLabel = true;
          _buttonPressed = false;
          errorHeading = 'Incorrect Email';
        });
      }
    } else {
      setState(() {
        _buttonPressed = false;
        _displayLabel = true;
        errorHeading = 'Email or Password is empty';
      });
    }
  }
}
