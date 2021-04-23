import 'dart:ui';

import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/material.dart';

class MyWidgets {
  static Widget getAppBar() {
    return AppBar(
      backgroundColor: colors.buttonColor,
      title: Text(
        'Digi Café Admin',
        style: TextStyle(
          fontFamily: Fonts.default_font,
          fontSize: Fonts.label_size,
        ),
      ),
    );
  }

  static Widget getTextWidget(
      {String text = '',
      var size = Fonts.heading2_size,
      FontWeight weight = FontWeight.normal,
      var overflow = TextOverflow.visible,
      var color = Colors.black}) {
    return Text(
      '$text',
      style: TextStyle(
          fontSize: size,
          fontFamily: Fonts.default_font,
          fontWeight: weight,
          color: color),
      overflow: overflow,
    );
  }
}
