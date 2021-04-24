import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/material.dart';
import '../style/colors.dart';

class NoInternetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: _NoInternetScreen(),
    );
  }
}

class _NoInternetScreen extends StatefulWidget {
  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<_NoInternetScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
                maxWidth: MediaQuery.of(context).size.width),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'No Internet Connection',
                      style: TextStyle(
                        fontSize: Fonts.heading1_size,
                        fontFamily: Fonts.default_font,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 25, bottom: 30),
                      child: Text(
                        'What to do next?',
                        style: TextStyle(
                          fontSize: Fonts.heading2_XL_size,
                          fontFamily: Fonts.default_font,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 10, left: 25, right: 25, bottom: 10),
                      child: Row(
                        children: [
                          Indicator(),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Make sure Wi-fi is on.',
                              style: TextStyle(
                                fontSize: Fonts.heading3_size,
                                fontFamily: Fonts.default_font,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 25, right: 25),
                      child: Row(
                        children: [
                          Indicator(),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Airplane Mode is off.',
                              style: TextStyle(
                                fontSize: Fonts.heading3_size,
                                fontFamily: Fonts.default_font,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: colors.buttonColor,
                      ),
                      width: 150,
                      height: 50,
                      child: FlatButton(
                        child: Text(
                          'Try Again',
                          style: TextStyle(
                            fontFamily: Fonts.default_font,
                            color: colors.buttonTextColor,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Indicator extends StatelessWidget {
  // final int positionIndex, currentIndex;
  // const Indicator({this.currentIndex, this.positionIndex});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
          border: Border.all(color: colors.buttonColor),
          color: colors.buttonColor,
          borderRadius: BorderRadius.circular(100)),
    );
  }
}
