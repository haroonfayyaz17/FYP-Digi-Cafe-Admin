import 'package:digi_cafe_admin/Controllers/UIControllers/FoodMenuUIController.dart';
import 'package:digi_cafe_admin/Views/AddVoucher.dart';
import 'package:digi_cafe_admin/Views/AppBarWidget.dart';
import 'package:digi_cafe_admin/Views/DialogInstruction.dart';
import 'package:digi_cafe_admin/Views/LoadingWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:digi_cafe_admin/Views/MenuItemWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'VoucherItemWidget.dart';

// ViewVouchers todaysMenu;

class ViewVouchers extends StatelessWidget {
  // var fm;

  // ViewVouchers() {
  //   final foodList = [
  //     FoodItem('1', 'Biryani', 'Chicken Biryani', null, 120, 3),
  //     FoodItem('1', 'Shawarma', 'Zinger Shawarma', null, 60, 5),
  //     FoodItem('1', 'Sandwich', 'Egg & Chicken', null, 80, 10),
  //     FoodItem('1', 'Sandwich', 'Vegetable & Chicken', null, 50, 3),
  //   ];
  //   todaysMenu = new ViewVouchers('All', foodList);
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBarWidget.getAppBar(),
      backgroundColor: colors.backgroundColor,
      body: _ViewVouchers(),
    );
  }
}

class _ViewVouchers extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => __ViewVouchers();
}

class __ViewVouchers extends State<_ViewVouchers> {
  List<MenuItemWidget> menuItemWidget = [];

  FoodMenuUIController _foodMenuUIController;
  var prevCategory;
  var count = 0;
  Stream<QuerySnapshot> querySnapshot;

  BuildContext _buildContext;

  @override
  void initState() {
    super.initState();
    _foodMenuUIController = new FoodMenuUIController();
    querySnapshot = _foodMenuUIController.getVoucherSnapshot();
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
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
              label: 'Add Vouchers',
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
                            AddVoucherScreen(null, null)));
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
                            DocumentSnapshot voucher =
                                snapshot.data.documents[index];

                            // var url = null;
                            // storageReference.getDownloadURL().then((fileURL) {
                            //   url = fileURL;
                            //   print(fileURL);
                            // });
                            // var imgURL = loadPic(voucher.documentID);
                            // print(url);
                            Widget widget = VoucherItemWidget(
                              discount: voucher.data['discount'],
                              expiryDate: voucher.data['validity'],
                              minimumSpend: voucher.data['minimumSpend'],
                              voucherID: voucher.documentID,
                              title: voucher.data['title'],
                              context: context,
                            );

                            return widget;
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
            DialogInstruction.getInstructionRow('Single tap to update Voucher'),
            DialogInstruction.getInstructionRow('Long Press to delete Voucher'),
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
