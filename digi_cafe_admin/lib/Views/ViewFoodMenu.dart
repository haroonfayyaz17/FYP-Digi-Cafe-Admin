import 'package:digi_cafe_admin/Controllers/UIControllers/FoodMenuUIController.dart';
import 'package:digi_cafe_admin/Views/AddCategory.dart';
import 'package:digi_cafe_admin/Views/AddFoodMenu.dart';
import 'package:digi_cafe_admin/Views/AppBarWidget.dart';
import 'package:digi_cafe_admin/Views/DialogInstruction.dart';
import 'package:digi_cafe_admin/Views/LoadingWidget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:digi_cafe_admin/Views/admin_Dashboard.dart';
import 'package:digi_cafe_admin/Model/foodMenu.dart';
import 'package:digi_cafe_admin/Model/FoodItem.dart';
import 'package:digi_cafe_admin/Views/MenuItemWidget.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// ViewFoodMenu todaysMenu;

class ViewFoodMenu extends StatelessWidget {
  // var fm;

  // ViewFoodMenu() {
  //   final foodList = [
  //     FoodItem('1', 'Biryani', 'Chicken Biryani', null, 120, 3),
  //     FoodItem('1', 'Shawarma', 'Zinger Shawarma', null, 60, 5),
  //     FoodItem('1', 'Sandwich', 'Egg & Chicken', null, 80, 10),
  //     FoodItem('1', 'Sandwich', 'Vegetable & Chicken', null, 50, 3),
  //   ];
  //   todaysMenu = new ViewFoodMenu('All', foodList);
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBarWidget.getAppBar(),
      backgroundColor: colors.backgroundColor,
      body: _ViewFoodMenu(),
    );
  }
}

class _ViewFoodMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => __ViewFoodMenu();
}

class __ViewFoodMenu extends State<_ViewFoodMenu> {
  List<MenuItemWidget> menuItemWidget = [];

  FoodMenuUIController _foodMenuUIController;
  var prevCategory;
  var count = 0;
  Stream<QuerySnapshot> querySnapshot;

  @override
  void initState() {
    super.initState();
    _foodMenuUIController = new FoodMenuUIController();
    querySnapshot = _foodMenuUIController.getFoodMenuSnapshot();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 20),
          backgroundColor: colors.buttonColor,
          children: [
            SpeedDialChild(
              child: Icon(
                Icons.fastfood,
                color: colors.buttonTextColor,
              ),
              label: 'Add Food Item',
              labelStyle: TextStyle(
                color: colors.buttonTextColor,
                fontFamily: Fonts.default_font,
                fontSize: Fonts.dialog_heading_size,
              ),
              labelBackgroundColor: colors.buttonColor,
              backgroundColor: colors.buttonColor,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AddFoodMenuScreen()));
              },
            ),
            SpeedDialChild(
              child: Icon(
                Icons.category_sharp,
                color: colors.buttonTextColor,
              ),
              label: 'Add Category',
              labelStyle: TextStyle(
                color: colors.buttonTextColor,
                fontFamily: Fonts.default_font,
                fontSize: Fonts.dialog_heading_size,
              ),
              labelBackgroundColor: colors.buttonColor,
              backgroundColor: colors.buttonColor,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AddCategoryScreen()));
              },
            ),
            SpeedDialChild(
              child: Icon(
                Icons.help_outline,
                color: Colors.blue[800],
              ),
              backgroundColor: colors.backgroundColor,
              label: 'Help',
              labelStyle: TextStyle(
                color: colors.buttonTextColor,
                fontFamily: Fonts.default_font,
                fontSize: Fonts.dialog_heading_size,
              ),
              labelBackgroundColor: colors.buttonColor,
              onTap: () {
                createHelpAlert(context);
              },
            ),
          ]),
      body: Flex(
          direction: Axis.vertical,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: querySnapshot,
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? LoadingWidget()
                      : ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot dish =
                                snapshot.data.documents[index];

                            // var url = null;
                            // storageReference.getDownloadURL().then((fileURL) {
                            //   url = fileURL;
                            //   print(fileURL);
                            // });
                            // var imgURL = loadPic(dish.documentID);
                            // print(url);
                            Widget widget = MenuItemWidget(
                                quantity: dish.data['stockLeft'],
                                foodImg: dish.data['imgURL'],
                                category: dish.data['category'],
                                foodID: dish.documentID,
                                price: dish.data['price'].toString(),
                                description: dish.data['description'],
                                name: dish.data['name']);

                            Widget x = Column(
                              children: [
                                index > 0
                                    ? snapshot.data.documents[index - 1]
                                                .data['category'] !=
                                            dish.data['category']
                                        ? getTextWidget(dish.data['category'])
                                        : Container()
                                    : getTextWidget(dish.data['category']),
                                widget,
                              ],
                            );

                            return x;
                          },
                        );
                },
              ),
            ),
          ]),
    );
  }

  void createHelpAlert(context) async {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
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
    Alert(
        context: context,
        style: alertStyle,
        title: 'How to use?',
        content: Column(
          children: [
            DialogInstruction.getInstructionRow(
                'Single tap to update food item'),
            DialogInstruction.getInstructionRow(
                'Double tap to update quantity'),
            DialogInstruction.getInstructionRow(
                'Long Press to delete food item'),
          ],
        )).show();
  }

  Widget getTextWidget(var data) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          data,
          style: TextStyle(
            fontSize: Fonts.heading1_size,
            fontFamily: Fonts.default_font,
          ),
        ),
      ),
    );
  }
}
