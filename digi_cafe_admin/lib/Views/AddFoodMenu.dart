import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_cafe_admin/Model/FoodItem.dart';
import 'package:digi_cafe_admin/Model/FoodMenu.dart';
import 'package:digi_cafe_admin/Views/MyWidgets.dart';
import 'package:digi_cafe_admin/Views/LoadingWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/FoodMenuUIController.dart';
import '../style/colors.dart';

class AddFoodMenuScreen extends StatelessWidget {
  AddFoodMenuScreen({this.foodItem, this.actionType});
  FoodMenu foodItem;
  String actionType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _AddFoodMenuScreen(foodItem: foodItem, actionType: actionType),
    );
  }
}

class _AddFoodMenuScreen extends StatefulWidget {
  _AddFoodMenuScreen({this.foodItem, this.actionType});

  FoodMenu foodItem;
  String actionType;
  @override
  _AddFoodMenuScreen3State createState() =>
      _AddFoodMenuScreen3State(foodItem: foodItem, actionType: actionType);
}

class _AddFoodMenuScreen3State extends State<_AddFoodMenuScreen> {
  var screenHeader = 'Add Food Item';

  String _nextLabel = 'Next>';

  String _imageP;

  var _displayLoadingWidget = false;

  _AddFoodMenuScreen3State({this.foodItem, this.actionType});
  FoodMenu foodItem;
  String actionType;
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
  var _imageURL;
  Stream<QuerySnapshot> querySnapshot;

  var itemID;
  @override
  void initState() {
    super.initState();
    _imageURL = null;
    itemID = null;
    if (actionType == 'update') {
      screenHeader = 'Update Food Item';
      FoodItem item = foodItem.foodList.elementAt(0);
      edtControllerItemName.text = item.name;
      itemID = item.id;
      edtControllerItemPrice.text = item.price.toString();
      _itemDescriptionController.text = item.description;
      chosencategory = foodItem.category;
      _imageURL = item.imgURL;
    }
    querySnapshot = _foodMenuUIController.getCategorySnapshot();
  }

  onChangedFunction(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidgets.getAppBar(text: '$screenHeader'),
      body: Stack(
        children: [
          _displayLoadingWidget
              ? LoadingWidget()
              : StreamBuilder<QuerySnapshot>(
                  stream: querySnapshot,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<String> listItems = new List();
                      for (int count = 0;
                          count < snapshot.data.documents.length;
                          count++) {
                        DocumentSnapshot dish = snapshot.data.documents[count];

                        listItems.add(dish.data['name']);
                      }
                      categoryOptionList = listItems;

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
                                            minHeight: MediaQuery.of(context)
                                                .size
                                                .height) *
                                        0.8,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 40,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 20, 0),
                                          child: Container(
                                            height: 150,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.70,
                                            child: Image.asset(
                                              'images/innerImages/spoon.jpg',
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 20),
                                            child: MyWidgets.getTextWidget(
                                              text: 'Food Details',
                                              size:
                                                  Fonts.heading_SampleText_size,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              20, 10, 20, 5),
                                          child: TextFormField(
                                            autofocus: true,
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (_) =>
                                                FocusScope.of(context)
                                                    .nextFocus(),
                                            onChanged: (text) {
                                              _itemName = text;
                                            },
                                            controller: edtControllerItemName,
                                            textCapitalization:
                                                TextCapitalization.words,
                                            decoration:
                                                MyWidgets.getTextFormDecoration(
                                                    title: 'Item Name',
                                                    icon: Icons.fastfood),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 5, 20, 5),
                                          child: TextFormField(
                                            controller:
                                                _itemDescriptionController,
                                            autofocus: true,
                                            maxLines: 2,
                                            maxLength: 100,
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (_) =>
                                                FocusScope.of(context)
                                                    .nextFocus(),
                                            textCapitalization:
                                                TextCapitalization.words,
                                            decoration:
                                                MyWidgets.getTextFormDecoration(
                                                    title: 'Item Description',
                                                    icon: Icons.description),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 20, 5),
                                          child:
                                              DropdownButtonFormField<String>(
                                            value: chosencategory,
                                            autofocus: true,
                                            icon: Icon(Icons.arrow_drop_down),
                                            iconSize: 24,
                                            decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: colors.buttonColor,
                                                    width: 1.3),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: colors.buttonColor,
                                                    width: 1.3),
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
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
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
                                Container(
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 20),
                                            child: MyWidgets.getTextWidget(
                                                text: 'Set Price',
                                                size: Fonts
                                                    .heading_SampleText_size),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              20, 50, 20, 5),
                                          child: TextFormField(
                                            autofocus: true,
                                            inputFormatters: [
                                              DecimalTextInputFormatter(
                                                  decimalRange: 0)
                                            ],
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (_) =>
                                                FocusScope.of(context)
                                                    .nextFocus(),
                                            onChanged: (text) {
                                              _itemName = text;
                                            },
                                            controller: edtControllerItemPrice,
                                            textCapitalization:
                                                TextCapitalization.words,
                                            decoration:
                                                MyWidgets.getTextFormDecoration(
                                                    title: 'Price',
                                                    icon: Icons.money),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                            minHeight: MediaQuery.of(context)
                                                .size
                                                .height) *
                                        0.8,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: MyWidgets.getTextWidget(
                                                text: 'Upload Your Food Image',
                                                size: Fonts
                                                    .heading_SampleText_size,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 50,
                                          ),
                                          _imageURL != null
                                              ? Image.network(
                                                  _imageURL,
                                                  width: 275,
                                                  height: 275,
                                                )
                                              : Container(),
                                          _image != null
                                              ? Image.asset(
                                                  _image.path,
                                                  width: 225,
                                                  height: 225,
                                                )
                                              : Container(),
                                          _image == null && _imageURL == null
                                              ? Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 50),
                                                  child: MyWidgets.getButton(
                                                    text: 'Choose Food Pic',
                                                    width: 150,
                                                    callback: () =>
                                                        _showPicker(context),
                                                  ),
                                                )
                                              : Container(),
                                          SizedBox(
                                            height: 50,
                                          ),
                                          _image != null || _imageURL != null
                                              ? MyWidgets.getButton(
                                                  text: 'Remove',
                                                  color: Colors.red[400],
                                                  callback: () =>
                                                      clearSelection())
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
                                MyWidgets.getIndicator(
                                    positionIndex: 0,
                                    currentIndex: currentIndex),
                                SizedBox(
                                  width: 10,
                                ),
                                MyWidgets.getIndicator(
                                    positionIndex: 1,
                                    currentIndex: currentIndex),
                                SizedBox(
                                  width: 10,
                                ),
                                MyWidgets.getIndicator(
                                    positionIndex: 3,
                                    currentIndex: currentIndex),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 50.0),
                            child: Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () => previousFunction(),
                                    child: MyWidgets.getTextWidget(
                                        text: '<Previous',
                                        size: Fonts.heading2_size,
                                        color: colors.buttonColor),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      nextFunction();
                                    },
                                    child: MyWidgets.getTextWidget(
                                        text: '$_nextLabel',
                                        size: Fonts.heading2_size,
                                        color: colors.buttonColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Stack(
                        children: [
                          LoadingWidget(),
                        ],
                      );
                    }
                  }),
        ],
      ),
    );
  }

  nextFunction() async {
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
        if (actionType == 'update') {
          setState(() {
            _nextLabel = "Update";
          });
        } else {
          setState(() {
            _nextLabel = "Add";
          });
        }
        controller.nextPage(duration: _kDuration, curve: _kCurve);
      }
    } else if (controller.page == image) {
      if (_imageURL == null && _image == null && actionType == 'update') {
        _showToast(context, 'Select Food Image');
      } else if (_image == null && actionType != 'update') {
        _showToast(context, 'Select Food Image');
      } else {
        if (actionType == 'update') {
          await _updateFoodRecord();
        } else {
          _addFoodRecord();
        }
      }
    }
  }

  void clearSelection() {
    setState(() {
      _image = null;
      _imageURL = null;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: colors.buttonColor,
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library,
                          color: colors.buttonTextColor),
                      title: MyWidgets.getTextWidget(
                          text: 'Photo Library',
                          size: Fonts.dialog_heading_size,
                          color: colors.buttonTextColor),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_camera,
                      color: colors.buttonTextColor,
                    ),
                    title: MyWidgets.getTextWidget(
                        text: 'Camera',
                        size: Fonts.dialog_heading_size,
                        color: colors.buttonTextColor),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future _imgFromCamera() async {
    await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
      maxHeight: 225,
      maxWidth: 225,
    ).then((image) {
      setState(() {
        _image = image;
        _imageP = image == null ? null : _image.path;
        // print(_image.path);
      });
    });
  }

  Future _imgFromGallery() async {
    await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
      maxHeight: 225,
      maxWidth: 225,
    ).then((image) {
      setState(() {
        _image = image;
        _imageP = image == null ? null : _image.path;
        // print(_image.path);
      });
    });
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
        _imageP = _image.path;
      });
    });
  }

  previousFunction() {
    int image = 2;
    if (controller.page != image - 1) {
      setState(() {
        _nextLabel = 'Next>';
      });
    }
    if (controller.page == 0) {
      Navigator.pop(context);
    } else {
      controller.previousPage(duration: _kDuration, curve: _kCurve);
    }
  }

  void _showToast(BuildContext context, var _message) {
    MyWidgets.showToast(context, _message);
  }

  Future<void> _addFoodRecord() async {
    setState(() {
      _displayLoadingWidget = true;
    });
    String itemName = edtControllerItemName.text;
    String description = _itemDescriptionController.text;
    String price = edtControllerItemPrice.text;

    await _foodMenuUIController.addFoodMenu(
        itemName, description, chosencategory, price, _image);
    setState(() {
      _displayLoadingWidget = false;
    });
    _showToast(context, 'Data added successfully');
    Navigator.pop(context);
  }

  Future<void> _updateFoodRecord() async {
    setState(() {
      _displayLoadingWidget = true;
    });
    String itemName = edtControllerItemName.text;
    String description = _itemDescriptionController.text;
    String price = edtControllerItemPrice.text;
    bool result;
    if (_imageURL != null) {
      result = await _foodMenuUIController.updateFoodMenu(
          itemID, itemName, description, chosencategory, price, null);
    } else {
      result = await _foodMenuUIController.updateFoodMenu(
          itemID, itemName, description, chosencategory, price, _imageP);
    }
    setState(() {
      _displayLoadingWidget = false;
    });
    if (result == true) {
      _showToast(context, 'Data updated successfully');
      Navigator.pop(context);
    } else {
      _showToast(context, 'Data update unsuccessfully');
    }
  }
}
