import 'package:digi_cafe_admin/Views/Login.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/FoodMenuUIController.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/Icons/customIcons.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MyWidgets.dart';
import '../style/colors.dart';

class AddCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidgets.getAppBar(text: 'Add Category'),
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
              BoxConstraints(minHeight: MediaQuery.of(context).size.height) *
                  0.8,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: MyWidgets.getTextWidget(
                      text: 'Add Category',
                      size: Fonts.heading1_size,
                      color: colors.buttonTextColor),
                ),
                SizedBox(
                  height: 75,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: MyWidgets.getTextWidget(
                          text: 'Category Name', size: Fonts.heading2_size)),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: TextFormField(
                    autofocus: true,
                    onChanged: _categoryNameChanged,
                    textCapitalization: TextCapitalization.words,
                    decoration: MyWidgets.getTextFormDecoration(
                        title: 'Category Name', icon: Icons.category),
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
                        child: MyWidgets.getTextWidget(
                            size: Fonts.button_size,
                            text: 'Add',
                            color: colors.buttonTextColor),
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
    MyWidgets.showToast(context, _message);
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
    if (value == 'true') {
      _showToast(context, "Record Added");
      Navigator.pop(context);
    } else if (value == 'false') {
      _showToast(context, "Fail to add record");
    } else {
      _showToast(context, "Category already exist");
    }
  }
}
