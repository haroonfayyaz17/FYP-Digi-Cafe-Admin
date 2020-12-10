import 'package:digi_cafe_admin/style/Icons/customIcons.dart';
import 'package:digi_cafe_admin/Views/admin_Dashboard.dart';
import 'package:digi_cafe_admin/Views/SignUp.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:digi_cafe_admin/Views/ViewFoodMenu.dart';
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

  var adminEmail = 'digiCafeAdmin@gmail.com';

  var adminPassword = 'admin123';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    edtTextControllerEmail = new TextEditingController();
    edtTextControllerPassword = new TextEditingController();
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
                    controller: edtTextControllerEmail,
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
                    controller: edtTextControllerPassword,
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
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      LoginDBController controller = new LoginDBController();
                      controller.CreateNewUser('$adminEmail', "$adminPassword");

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new dashboard()));
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (BuildContext context) =>
                      //             new ViewFoodMenu()));

                      // print(edtTextControllerEmail.text);
                      // print(edtTextControllerPassword.text);
                      // _loginController.CheckSignIn(edtTextControllerEmail.text,
                      //     edtTextControllerPassword.text);
                      // _loginController
                      //     .isEmailVerified()
                      //     .then((value) => print(value));
                      // setState(() {
                      //   _buttonPressed = true;
                      // });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        width: 1.0,
                        style: BorderStyle.solid,
                      )),
                  width: 200,
                  height: 50,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: Text(
                      'Create new Account',
                      style: TextStyle(
                        fontFamily: Fonts.default_font,
                        color: colors.buttonColor,
                      ),
                    ),
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
