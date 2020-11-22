import 'package:digi_cafe_admin/Views/login.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/FoodMenuUIController.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/Icons/customIcons.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../style/colors.dart';

class AddCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: colors.buttonColor,
      backgroundColor: colors.backgroundColor,
      body: _AddCategoryScreen(),
    );
  }
}

_AddCategoryScreenState _addCategoryScreen;

class _AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() {
    _addCategoryScreen = _AddCategoryScreenState();
    return _addCategoryScreen;
  }
}

class _AddCategoryScreenState extends State<_AddCategoryScreen> {
  String _categoryName = '';

  FoodMenuUIController _foodMenuUIController;

  @override
  void initState() {
    super.initState();
    _foodMenuUIController = new FoodMenuUIController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        // physics: NeverScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Add Category',
                    style: TextStyle(
                      fontSize: Fonts.heading1_size,
                      fontFamily: Fonts.default_font,
                    ),
                  ),
                ),
                SizedBox(
                  height: 75,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Category Name',
                      style: TextStyle(
                        fontSize: Fonts.heading2_size,
                        fontFamily: Fonts.default_font,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: TextFormField(
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    onChanged: _categoryNameChanged,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: colors.buttonColor, width: 1.3),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: colors.buttonColor, width: 1.3),
                      ),
                      hintText: 'Category Name',
                      filled: true,
                      fillColor: colors.backgroundColor,
                      labelText: 'Category Name',
                      icon: Icon(
                        Icons.person_add,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: colors.buttonColor,
                      ),
                      width: 100,
                      height: 50,
                      child: Center(
                        child: Text(
                          'Add',
                          style: TextStyle(
                            fontFamily: Fonts.default_font,
                            color: colors.buttonTextColor,
                          ),
                        ),
                      ),
                    ),
                    onTap: _addCategory,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
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

  void _categoryNameChanged(String value) {
    _categoryName = value;
  }

  Future<void> _addCategory() async {
    if (_categoryName.trim() == '') {
      _showToast(context, "Enter category");
      return;
    }
    var value = await _foodMenuUIController.addCategory(_categoryName);
    if (value) {
      _showToast(context, "Record Added");
      Navigator.pop(context);
    } else {
      _showToast(context, "Fail to add record");
    }
  }
}
