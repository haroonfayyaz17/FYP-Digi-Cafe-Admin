import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:digi_cafe_admin/Views/login.dart';
import 'package:digi_cafe_admin/style/Icons/customIcons.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/FoodMenuUIController.dart';
import 'dart:math' as math;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

import '../style/colors.dart';

class AddFoodMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: _AddFoodMenuScreen(),
    );
  }
}

class _AddFoodMenuScreen extends StatefulWidget {
  @override
  _AddFoodMenuScreen3State createState() => _AddFoodMenuScreen3State();
}

class _AddFoodMenuScreen3State extends State<_AddFoodMenuScreen> {
  TextEditingController _itemDescriptionController =
      new TextEditingController();
  PageController controller = PageController();
  File _image;
  var _msg = "Select Food Image";
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  List<String> categoryOptionList;

  String chosencategory;
  int currentIndex = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var edtControllerItemName = new TextEditingController();

  var edtControllerItemPrice = new TextEditingController();
  FoodMenuUIController _foodMenuUIController = new FoodMenuUIController();
  String _itemName;

  @override
  void initState() {
    super.initState();

    _fillCategoriesDropDown();
  }

  void _fillCategoriesDropDown() {
    categoryOptionList = <String>['Drinks', 'Continental', 'Pakistani'];
  }

  onChangedFunction(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: onChangedFunction,
            controller: controller,
            children: [
              SingleChildScrollView(
                // physics: NeverScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Add Food',
                            style: TextStyle(
                              fontSize: Fonts.heading1_size,
                              fontFamily: Fonts.default_font,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width * 0.70,
                            child: Image.asset(
                              'images/innerImages/spoon.jpg',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        //                     this._id = _id;
                        // this._name = _name;
                        // this._description = _description;
                        // this._imgURL = _imgURL;
                        // this._price = _price;
                        // this._stockLeft = _stockLeft;
                        SizedBox(
                          // height: 50,
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              'Food Details',
                              style: TextStyle(
                                fontSize: Fonts.heading_SampleText_size,
                                fontFamily: Fonts.default_font,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                          child: TextFormField(
                            autofocus: true,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            onChanged: (text) {
                              _itemName = text;
                            },
                            controller: edtControllerItemName,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: colors.buttonColor, width: 1.3),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: colors.buttonColor, width: 1.3),
                              ),
                              hintText: 'Item Name',
                              filled: true,
                              fillColor: colors.backgroundColor,
                              labelText: 'Item Name',
                              icon: Icon(Icons.fastfood),
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: TextFormField(
                            controller: _itemDescriptionController,
                            autofocus: true,
                            maxLines: 2,
                            maxLength: 100,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: colors.buttonColor, width: 1.3),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: colors.buttonColor, width: 1.3),
                              ),
                              hintText: 'Item Description',
                              filled: true,
                              fillColor: colors.backgroundColor,
                              labelText: 'Item Description',
                              icon: Icon(
                                Icons.description,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
                          child: DropdownButtonFormField<String>(
                            value: chosencategory,
                            autofocus: true,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: colors.buttonColor, width: 1.3),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: colors.buttonColor, width: 1.3),
                              ),
                              hintText: 'Category',
                              filled: true,
                              fillColor: colors.backgroundColor,
                              labelText: 'Category',
                              icon: Icon(Icons.category_sharp),
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                chosencategory = newValue;
                              });
                            },
                            items: categoryOptionList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            'Set Price',
                            style: TextStyle(
                              fontSize: Fonts.heading_SampleText_size,
                              fontFamily: Fonts.default_font,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 50, 20, 5),
                        child: TextFormField(
                          autofocus: true,
                          inputFormatters: [
                            DecimalTextInputFormatter(decimalRange: 2)
                          ],
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          onChanged: (text) {
                            _itemName = text;
                          },
                          controller: edtControllerItemPrice,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: colors.buttonColor, width: 1.3),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: colors.buttonColor, width: 1.3),
                            ),
                            hintText: 'Price',
                            filled: true,
                            fillColor: colors.backgroundColor,
                            labelText: 'Price',
                            icon: Icon(Icons.money),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              'Upload Your Food Image',
                              style: TextStyle(
                                fontSize: Fonts.heading_SampleText_size,
                                fontFamily: Fonts.default_font,
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 50,
                        // ),
                        SizedBox(
                          height: 50,
                        ),
                        _image != null
                            ? Image.asset(
                                _image.path,
                                width: 175,
                                height: 175,
                              )
                            : Container(),
                        // SizedBox(
                        //   height: 50,
                        // ),
                        _image == null
                            ? Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      color: colors.buttonColor,
                                    ),
                                    width: 150,
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        'Choose Food Pic',
                                        style: TextStyle(
                                          fontFamily: Fonts.default_font,
                                          color: colors.buttonTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: chooseFile,
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: 50,
                        ),
                        _image != null
                            ? InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    color: Colors.red[400],
                                  ),
                                  width: 150,
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      'Remove',
                                      style: TextStyle(
                                        fontFamily: Fonts.default_font,
                                        color: colors.buttonTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: clearSelection,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Indicator(
                positionIndex: 0,
                currentIndex: currentIndex,
              ),
              SizedBox(
                width: 10,
              ),
              Indicator(
                positionIndex: 1,
                currentIndex: currentIndex,
              ),
              SizedBox(
                width: 10,
              ),
              Indicator(
                positionIndex: 2,
                currentIndex: currentIndex,
              ),
              // SizedBox(
              //   width: 10,
              // ),
              // Indicator(
              //   positionIndex: 3,
              //   currentIndex: currentIndex,
              // ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () => previousFunction(),
                  child: Text(
                    '<Previous',
                    style: TextStyle(
                      fontSize: Fonts.heading2_size,
                      color: colors.buttonColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                InkWell(
                  onTap: () {
                    nextFunction();
                  },
                  child: Text(
                    'Next>',
                    style: TextStyle(
                      fontSize: Fonts.heading2_size,
                      color: colors.buttonColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  nextFunction() {
    double foodDetails = 0, price = 1, image = 2;
    if (controller.page == foodDetails) {
      if (edtControllerItemName.text == '') {
        _showToast(context, 'Enter Item Name');
      } else if (_itemDescriptionController.text == '') {
        _showToast(context, 'Enter Item Description');
      } else if (chosencategory == null) {
        _showToast(context, 'Choose category');
      } else {
        controller.nextPage(duration: _kDuration, curve: _kCurve);
      }
    } else if (controller.page == price) {
      if (edtControllerItemPrice.text == '') {
        {
          _showToast(context, 'Enter Item Price');
        }
      } else {
        controller.nextPage(duration: _kDuration, curve: _kCurve);
      }
    } else if (controller.page == image) {
      if (_image == null) {
        _showToast(context, 'Select Food Image');
      } else {
        _addFoodRecord();
      }
    }
  }

  void clearSelection() {
    setState(() {
      _image = null;
    });
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  previousFunction() {
    if (controller.page == 0) {
      Navigator.pop(context);
    } else {
      controller.previousPage(duration: _kDuration, curve: _kCurve);
    }
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

  void _addFoodRecord() {
    String itemName = edtControllerItemName.text;
    String description = _itemDescriptionController.text;
    String price = edtControllerItemPrice.text;

    _foodMenuUIController.addFoodMenu(
        itemName, description, chosencategory, price, _image);
  }
}

class Indicator extends StatelessWidget {
  final int positionIndex, currentIndex;
  const Indicator({this.currentIndex, this.positionIndex});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
          border: Border.all(color: colors.buttonColor),
          color: positionIndex == currentIndex
              ? colors.buttonColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(100)),
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

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
          print('cxzcx');
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
