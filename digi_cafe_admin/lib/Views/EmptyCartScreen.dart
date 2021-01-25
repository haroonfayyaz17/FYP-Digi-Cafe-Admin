import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/material.dart';

import '../style/colors.dart';

class EmptyCartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: _EmptyCartScreen(),
    );
  }
}

class _EmptyCartScreen extends StatefulWidget {
  @override
  _EmptyCartScreenState createState() => _EmptyCartScreenState();
}

class _EmptyCartScreenState extends State<_EmptyCartScreen> {
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
                      'Your Cart is empty',
                      style: TextStyle(
                        fontSize: Fonts.heading1_size,
                        fontFamily: Fonts.default_font,
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
                          'Add Items',
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

  void _showToast(BuildContext context, var _message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: colors.buttonColor,
        content: Text(
          '$_message',
          style: TextStyle(
            color: colors.textColor,
            fontFamily: Fonts.default_font,
            fontSize: Fonts.appBarTitle_size,
          ),
        ),
        // action: SnackBarAction(
        //     label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
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
