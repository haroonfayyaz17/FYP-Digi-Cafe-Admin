import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'MyWidgets.dart';

class DialogInstruction {
  static Widget getInstructionRow(var instruction) {
    return Row(
      children: [
        MyWidgets.getIndicator(height: 8, width: 8),
        // Indicator(),
        Padding(
          padding: EdgeInsets.only(left: 5),
          child: MyWidgets.getTextWidget(
              text: instruction, size: Fonts.dialog_heading_size),
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
