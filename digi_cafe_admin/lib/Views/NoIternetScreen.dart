import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/material.dart';
import '../style/colors.dart';
import 'MyWidgets.dart';

class NoInternetScreen extends StatelessWidget {
  NoInternetScreen({this.screen = null});
  var screen;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: _NoInternetScreen(screen: screen),
    );
  }
}

class _NoInternetScreen extends StatefulWidget {
  _NoInternetScreen({this.screen = null});
  var screen;
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
    return SingleChildScrollView(
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
                  padding:
                      EdgeInsets.only(top: 10, left: 40, right: 25, bottom: 10),
                  child: Row(
                    children: [
                      MyWidgets.getIndicator(),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: MyWidgets.getTextWidget(
                            text: 'Make sure Wi-fi/Mobile Data is on.',
                            size: Fonts.heading3_size),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 10, left: 40, right: 25),
                  child: Row(
                    children: [
                      MyWidgets.getIndicator(),
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
                  child: MyWidgets.getButton(
                      text: 'Try Again',
                      onTap: () {
                        Navigator.pop(context);
                        if (widget.screen != null)
                          MyWidgets.changeScreen(
                              context: context, screen: widget.screen);
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
