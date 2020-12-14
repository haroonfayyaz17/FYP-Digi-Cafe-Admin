import 'package:digi_cafe_admin/Controllers/UIControllers/FoodMenuUIController.dart';
import 'package:digi_cafe_admin/Model/FoodItem.dart';
import 'package:digi_cafe_admin/Model/FoodMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';

import 'AddFoodMenu.dart';

class MenuItemWidget extends StatefulWidget {
  var foodImg, price, description, name, foodID;
  var category;
  var quantity;

  MenuItemWidget(
      {@required this.foodImg,
      @required this.foodID,
      @required this.description,
      @required this.name,
      @required this.price,
      this.category,
      this.quantity});

  @override
  _MenuItemWidgetState createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  FoodMenuUIController _foodMenuUIController;

  BuildContext _buildContext;

  var quantityController = new TextEditingController();
  @override
  void initState() {
    _foodMenuUIController = new FoodMenuUIController();
  }

  @override
  Widget build(BuildContext context) {
    this._buildContext = context;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3.5,
            width: MediaQuery.of(context).size.width - 10,
            child: InkWell(
              onTap: () {
                //TODO: Update Employee
                FoodItem foodItem = new FoodItem(
                    widget.foodID,
                    widget.name,
                    widget.description,
                    widget.foodImg,
                    double.parse(widget.price),
                    0);
                List<FoodItem> list = new List();
                list.add(foodItem);
                FoodMenu menu = new FoodMenu(widget.category, list);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AddFoodMenuScreen(
                            foodItem: menu, actionType: "update")));
              },
              onDoubleTap: () {
                //TODO: UpdateQuantity
                createAlert(context);
              },
              onLongPress: () {
                //TODO: Delete Employee
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Text(
                      'Do you want to remove Employee?',
                      style: TextStyle(
                        fontFamily: Fonts.default_font,
                        fontSize: Fonts.heading2_size,
                        color: colors.labelColor,
                      ),
                    ),
                    actions: <Widget>[
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: colors.buttonColor,
                        ),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'No',
                            style: TextStyle(
                              fontFamily: Fonts.default_font,
                              fontSize: Fonts.label_size,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: colors.buttonColor,
                        ),
                        child: FlatButton(
                          onPressed: () async {
                            //TODO: Delete Food
                            Navigator.pop(context);
                            bool result = await _foodMenuUIController
                                .deleteFoodItem(widget.foodID);

                            if (result.toString() == "true") {
                              _showToast(_buildContext,
                                  "Food Item deleted successfully");
                            } else {
                              _showToast(_buildContext,
                                  "Food Item delete unsuccessful");
                            }
                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(
                              fontFamily: Fonts.default_font,
                              fontSize: Fonts.label_size,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Card(
                elevation: 10,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: (MediaQuery.of(context).size.height / 3.5) - 70,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: <Widget>[
                          widget.foodImg == null
                              ? Image.asset('images/logo.png')
                              : Image.network(widget.foodImg),
                          Container(
                            height: 37,
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(15.0, 20.0)),
                            ),
                            child: FittedBox(
                              child: Text(
                                'PKR ' + widget.price,
                                style: TextStyle(
                                  fontFamily: Fonts.default_font,
                                  fontSize: Fonts.label_size,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.6),
                                    child: Text(
                                      widget.name,
                                      style: TextStyle(
                                        fontFamily: Fonts.default_font,
                                        fontSize: Fonts.dishName_font,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Spacer(flex: 2),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Text(
                                      'Qty: ${widget.quantity.toInt().toString()}',
                                      style: TextStyle(
                                        fontFamily: Fonts.default_font,
                                        fontSize: Fonts.dishName_font,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                widget.description,
                                style: TextStyle(
                                  fontFamily: Fonts.default_font,
                                  fontSize: Fonts.dishDescription_font,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void createAlert(context) async {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromRight,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 500),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        fontSize: Fonts.dialog_heading_size,
        fontFamily: Fonts.default_font,
      ),
    );
    Alert(
        context: context,
        style: alertStyle,
        title: 'Enter Quantity of Item',
        content: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(0),
              child: TextFormField(
                inputFormatters: [DecimalTextInputFormatter(decimalRange: 0)],
                keyboardType: TextInputType.number,
                controller: quantityController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  fillColor: colors.backgroundColor,
                  labelText: 'Quantity',
                  icon: Icon(Icons.format_list_numbered),
                ),
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            color: colors.buttonColor,
            onPressed: () async {
              print(quantityController.text);
              if (quantityController.text != null) {
                try {
                  // FutureBuilder<bool>(
                  //     future: updateQuantity(),
                  //     builder:
                  //         (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  //       if (snapshot.hasData) {
                  //         print('${snapshot.data}');
                  //       }
                  //     });
                  bool result =
                      await _foodMenuUIController.updateFoodItemQuantity(
                          widget.foodID, double.parse(quantityController.text));

                  if (result) {
                    _showToast(context, 'Quantity Updated Successfully');
                  } else {
                    _showToast(context, 'Quantity Update Unsuccessful');
                  }
                  Navigator.of(context, rootNavigator: true).pop();
                } catch (ex) {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              } else {
                Navigator.of(context, rootNavigator: true).pop();
              }
            },
            child: Text(
              'Update Quantity',
              style: TextStyle(
                fontSize: Fonts.heading2_size,
                fontFamily: Fonts.default_font,
                color: colors.buttonTextColor,
              ),
            ),
          )
        ]).show();
    setState(() {
      int x = widget.quantity.toInt();
      quantityController.text = x.toString();
    });
  }

  Future<bool> updateQuantity() async {
    bool result = await _foodMenuUIController.updateFoodItemQuantity(
        widget.foodID, double.parse(quantityController.text));
    return result;
  }

  void _showToast(BuildContext context, var _message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text('$_message'),
        // action: SnackBarAction(
        //     label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
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