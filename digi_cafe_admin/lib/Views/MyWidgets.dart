import 'dart:ui';
import 'dart:math' as math;
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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

  static InputDecoration getTextFormDecoration(
      {String title = 'Name',
      IconData icon = Icons.person,
      var suffix = null,
      var border = null,
      var addBorder = true,
      String hint = null}) {
    return InputDecoration(
      focusedBorder: addBorder
          ? OutlineInputBorder(
              borderSide: BorderSide(color: colors.buttonColor, width: 1.3),
            )
          : null,
      enabledBorder: addBorder
          ? OutlineInputBorder(
              borderSide: BorderSide(color: colors.buttonColor, width: 1.3),
            )
          : null,
      border: border,
      hintText: hint == null ? title : hint,
      filled: true,
      fillColor: colors.backgroundColor,
      labelText: title,
      suffixIcon: suffix,
      icon: icon == null ? null : Icon(icon),
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

  static AlertStyle getAlertStyle(
      {AnimationType animation = AnimationType.fromTop}) {
    return AlertStyle(
      animationType: animation,
      isCloseButton: true,
      isButtonVisible: false,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 1000),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
          fontSize: Fonts.dialog_heading_size,
          fontFamily: Fonts.default_font,
          fontWeight: FontWeight.bold),
    );
  }
}

class CreateFormFieldDropDown extends StatefulWidget {
  List<String> dropDownList;
  VoidCallback complaintCallback;
  var type = null;
  var title;

  IconData icon;
  CreateFormFieldDropDown(
      {this.dropDownList,
      this.chosenType,
      this.title = 'Filter Type',
      this.icon = Icons.filter,
      this.type,
      this.complaintCallback});

  String chosenType;
  _CreateFormFieldDropDown state;
  @override
  State<StatefulWidget> createState() => state = _CreateFormFieldDropDown();
}

class _CreateFormFieldDropDown extends State<CreateFormFieldDropDown> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.chosenType,
      autofocus: true,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      decoration: MyWidgets.getTextFormDecoration(
          title: widget.title, icon: widget.icon),
      onChanged: (String newValue) {
        setState(() {
          widget.chosenType = newValue;
        });
        if (widget.type == 'complaint') widget.complaintCallback();
      },
      items: widget.dropDownList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
          ),
        );
      }).toList(),
    );
  }
}

class TextForm extends StatefulWidget {
  String value;

  // MyCustomForm({ Key key }) : super(key: key);
  TextForm({this.label = 'date', this.icon = Icons.calendar_today, Key key})
      : super(key: key);
  String label;
  final IconData icon;
  TextEditingController controller;

  _TextForm state;
  @override
  State<StatefulWidget> createState() => state = _TextForm();
}

class _TextForm extends State<TextForm> {
  // TextEditingController controller;

  @override
  void initState() {
    super.initState();
    widget.controller = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      controller: widget.controller,
      onChanged: (value) {
        setState(() {
          widget.value = value;
        });
      },
      textCapitalization: TextCapitalization.words,
      decoration: MyWidgets.getTextFormDecoration(
          title: widget.label, icon: widget.icon),
    );
  }
}

class TextFormDate extends StatefulWidget {
  TextFormDate({this.label = 'date', this.icon = Icons.calendar_today, Key key})
      : super(key: key);
  String type;
  String label;
  final IconData icon;
  DateTime date;
  TextEditingController controller;

  _TextFormDate state;
  @override
  State<StatefulWidget> createState() => state = _TextFormDate();
}

class _TextFormDate extends State<TextFormDate> {
  // TextEditingController controller;

  @override
  void initState() {
    super.initState();
    widget.controller = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.controller,
        readOnly: true,
        autofocus: true,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
        textCapitalization: TextCapitalization.words,
        decoration: MyWidgets.getTextFormDecoration(
            title: widget.label, icon: widget.icon),
        onTap: () {
          displayDatePicker(context);
        });
  }

  void displayDatePicker(context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    ).then((value) {
      if (value != null) {
        String day = value.day.toString();
        String month = value.month.toString();
        String year = value.year.toString();
        String date = '${day}-${month}-${year}';

        widget.controller.text = date;

        setState(() {
          widget.date = value;
          widget.controller.text = date;
        });
      }
    });
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange == 0);

  final int decimalRange;
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;
      if (isNumeric(value)) {
        if (value.contains(".")) {
          // if (value.substring(value.indexOf(".") + 1).contains(".")) {
          //   truncated = oldValue.text;
          //   newSelection = oldValue.selection;
          // }
          truncated = oldValue.text;
          newSelection = oldValue.selection;
        }
        if (value.contains(".") &&
            value.substring(value.indexOf(".") + 1).length > decimalRange) {
          truncated = oldValue.text;
          newSelection = oldValue.selection;
        } else if (value == ".") {
          truncated = "0.";

          newSelection = newValue.selection.copyWith(
            baseOffset: math.min(truncated.length, truncated.length + 1),
            extentOffset: math.min(truncated.length, truncated.length + 1),
          );
        }
      } else {
        if (value != '') {
          truncated = oldValue.text;
          newSelection = oldValue.selection;
        }
      }
      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}
