import 'dart:ui';

import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/material.dart';

class AppBarWidget {
  static Widget getAppBar() {
    return AppBar(
      title: Text(
        'Digi-Cafe Admin',
        style: TextStyle(
          fontFamily: Fonts.default_font,
          fontSize: Fonts.label_size,
        ),
      ),
    );
  }
}
