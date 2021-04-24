import 'dart:ui';

import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/material.dart';

class MyWidgets {
  static Widget getAppBar({String text = 'Digi Café Admin'}) {
    return AppBar(
      backgroundColor: colors.buttonColor,
      title: Text(
        '$text',
        style: TextStyle(
          fontFamily: Fonts.default_font,
          fontSize: Fonts.label_size,
        ),
      ),
    );
  }

  static Widget getTextWidget({
    String text = '',
    var size = Fonts.heading2_size,
    FontWeight weight = FontWeight.normal,
    var overflow = TextOverflow.visible,
    var color = Colors.black,
    TextAlign align = TextAlign.left,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return Text(
      '$text',
      style: TextStyle(
          fontSize: size,
          fontFamily: Fonts.default_font,
          fontWeight: weight,
          decoration: decoration,
          color: color),
      overflow: overflow,
      textAlign: align,
    );
  }

  static TextStyle getTextStyle(
      {var size = Fonts.heading2_size,
      FontWeight weight = FontWeight.normal,
      var color = colors.buttonTextColor}) {
    return TextStyle(
      color: color,
      fontFamily: Fonts.default_font,
      fontWeight: weight,
      fontSize: size,
    );
  }

  static showToast(BuildContext context, var _message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: colors.buttonColor,
        content: MyWidgets.getTextWidget(
            text: '$_message',
            color: colors.textColor,
            size: Fonts.appBarTitle_size),
      ),
    );
  }

  static Widget getIndicator(
      {double height = 12,
      double width = 12,
      int positionIndex = 0,
      currentIndex = 0}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          border: Border.all(color: colors.buttonColor),
          color: positionIndex == currentIndex
              ? colors.buttonColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(100)),
    );
  }
}
