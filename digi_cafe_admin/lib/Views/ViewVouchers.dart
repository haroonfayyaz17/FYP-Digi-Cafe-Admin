import 'package:digi_cafe_admin/Controllers/UIControllers/FoodMenuUIController.dart';
import 'package:digi_cafe_admin/Views/AddVoucher.dart';
import 'package:digi_cafe_admin/Views/MyWidgets.dart';
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

class ViewVouchers extends StatefulWidget {
  bool type = false;
  ViewVouchers({this.type});
  @override
  State<StatefulWidget> createState() => _ViewVouchers();
}

class _ViewVouchers extends State<ViewVouchers> {
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
    querySnapshot = _foodMenuUIController.getVoucherSnapshot(type: widget.type);
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    // TODO: implement build
    return Flex(
        direction: Axis.vertical,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: querySnapshot,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
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
                            Widget widget1 = VoucherItemWidget(
                              type: widget.type,
                              discount: voucher.data['discount'],
                              expiryDate: voucher.data['validity'],
                              minimumSpend: voucher.data['minimumSpend'],
                              voucherID: voucher.documentID,
                              title: voucher.data['title'],
                              context: context,
                            );

                            return widget1;
                          },
                        );
                } else
                  return LoadingWidget();
              },
            ),
          ),
        ]);
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
        child: MyWidgets.getTextWidget(text: data, size: Fonts.heading1_size),
      ),
    );
  }
}
