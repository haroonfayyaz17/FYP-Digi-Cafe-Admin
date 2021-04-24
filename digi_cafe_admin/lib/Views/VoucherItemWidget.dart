import 'package:digi_cafe_admin/Controllers/UIControllers/FoodMenuUIController.dart';
import 'package:digi_cafe_admin/Model/Voucher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'MyWidgets.dart';
import 'AddVoucher.dart';

class VoucherItemWidget extends StatefulWidget {
  var expiryDate, title, voucherID, minimumSpend, discount;
  BuildContext context;
  VoucherItemWidget(
      {@required this.voucherID,
      @required this.expiryDate,
      @required this.title,
      @required this.minimumSpend,
      @required this.discount,
      this.context});

  @override
  _VoucherItemWidgetState createState() => _VoucherItemWidgetState();
}

class _VoucherItemWidgetState extends State<VoucherItemWidget> {
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
            height: MediaQuery.of(context).size.height / 8,
            width: MediaQuery.of(context).size.width - 10,
            child: InkWell(
              onTap: () {
                //TODO: Update Voucher

                Voucher _voucher = new Voucher(
                  id: widget.voucherID,
                  title: widget.title,
                  minimumSpend: widget.minimumSpend,
                  validity: widget.expiryDate,
                  discount: widget.discount,
                  usedOn: null,
                );

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AddVoucherScreen(_voucher, "update")));
              },
              onLongPress: () {
                //TODO: Delete Voucher
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: MyWidgets.getTextWidget(
                        text: 'Do you want to remove Voucher?',
                        size: Fonts.heading2_size,
                        color: colors.labelColor),
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
                          child: MyWidgets.getTextWidget(
                              text: 'No',
                              size: Fonts.label_size,
                              color: colors.buttonTextColor),
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
                            //TODO: Delete Voucher
                            bool result = await _foodMenuUIController
                                .deleteVoucher(widget.voucherID);
                            print(result);
                            Navigator.pop(context);
                            if (result.toString() == "true") {
                              _showToast(widget.context,
                                  "Voucher deleted successfully");
                            } else {
                              _showToast(widget.context,
                                  "Voucher delete unsuccessful");
                            }
                          },
                          child: MyWidgets.getTextWidget(
                              text: 'Yes',
                              size: Fonts.label_size,
                              color: colors.buttonTextColor),
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
                    Row(
                      children: <Widget>[
                        Container(
                          margin:
                              EdgeInsets.only(left: 10, top: 15, bottom: 15),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  MyWidgets.getTextWidget(
                                      text: widget.title,
                                      size: Fonts.dishName_font,
                                      weight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis),
                                  Spacer(flex: 2),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: MyWidgets.getTextWidget(
                                        text: widget.expiryDate,
                                        size: Fonts.dishDescription_font,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                              MyWidgets.getTextWidget(
                                  text: 'Minimum Spend: ${widget.minimumSpend}',
                                  size: Fonts.dishDescription_font,
                                  overflow: TextOverflow.ellipsis),
                              MyWidgets.getTextWidget(
                                  text: 'Discount: ${widget.discount}',
                                  size: Fonts.dishDescription_font,
                                  overflow: TextOverflow.ellipsis),
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

  void _showToast(BuildContext context, var _message) {
    MyWidgets.showToast(context, _message);
  }
}
