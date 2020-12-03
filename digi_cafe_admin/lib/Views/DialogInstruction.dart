import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DialogInstruction {
  static Widget getInstructionRow(var instruction) {
    return Row(
      children: [
        Indicator(),
        Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text(
            '$instruction',
            style: TextStyle(
              fontSize: Fonts.dialog_heading_size,
              fontFamily: Fonts.default_font,
            ),
          ),
        ),
      ],
    );
  }
}

class Indicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 9,
      width: 9,
      decoration: BoxDecoration(
          border: Border.all(color: colors.buttonColor),
          color: colors.buttonColor,
          borderRadius: BorderRadius.circular(100)),
    );
  }
}
