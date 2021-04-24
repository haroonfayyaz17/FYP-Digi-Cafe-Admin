import 'package:digi_cafe_admin/Model/Voucher.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/FoodMenuUIController.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MyWidgets.dart';
import '../style/colors.dart';
import 'LoadingWidget.dart';

class AddVoucherScreen extends StatelessWidget {
  Voucher _voucher;
  var actionType;
  AddVoucherScreen(this._voucher, this.actionType);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: colors.buttonColor,
      backgroundColor: colors.backgroundColor,
      body: _AddVoucherScreen(_voucher, actionType),
    );
  }
}

_AddVoucherScreenState _addVoucherScreen;

class _AddVoucherScreen extends StatefulWidget {
  Voucher _voucher;
  var actionType;
  _AddVoucherScreen(this._voucher, this.actionType);
  @override
  _AddVoucherScreenState createState() {
    _addVoucherScreen = _AddVoucherScreenState();
    return _addVoucherScreen;
  }
}

class _AddVoucherScreenState extends State<_AddVoucherScreen> {
  FoodMenuUIController _foodMenuUIController;

  String _voucherTitle = '';

  var _dateControllerText;

  String _minimumSpend = '';

  String _validity = '';

  String _discount = '';

  String screenHeader;

  var _edtTitleController = new TextEditingController();

  var edtMinimumAmount = new TextEditingController();

  var edtDiscountController = new TextEditingController();

  String btnText;

  var _displayLoadingWidget = false;

  @override
  void initState() {
    super.initState();
    _foodMenuUIController = new FoodMenuUIController();
    _dateControllerText = new TextEditingController();
    if (widget.actionType == 'update') {
      screenHeader = 'Update Voucher';

      _edtTitleController.text = _voucherTitle = widget._voucher.getTitle;
      _dateControllerText.text = _validity = widget._voucher.getValidity;
      edtMinimumAmount.text = _minimumSpend = widget._voucher.getMinimumSpend;
      edtDiscountController.text = _discount = widget._voucher.getDiscount;
      btnText = 'Update';
    } else {
      screenHeader = 'Add Voucher';
      btnText = 'Add';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidgets.getAppBar(text: screenHeader),
      body: SafeArea(
        child: Stack(
          children: [
            _displayLoadingWidget
                ? LoadingWidget()
                : SingleChildScrollView(
                    // physics: NeverScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height) *
                          0.8,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 75,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: MyWidgets.getTextWidget(
                                      text: 'Voucher Details',
                                      size: Fonts.heading2_XL_size)),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                              child: TextFormField(
                                autofocus: true,
                                controller: _edtTitleController,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                onChanged: _voucherTitleChanged,
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
                                  hintText: 'Title',
                                  filled: true,
                                  fillColor: colors.backgroundColor,
                                  labelText: 'Title',
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                              child: TextFormField(
                                controller: _dateControllerText,
                                readOnly: true,
                                autofocus: true,
                                onChanged: _validityChanged,
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
                                  hintText: 'Expiry Date',
                                  filled: true,
                                  fillColor: colors.backgroundColor,
                                  labelText: 'Expiry Date',
                                ),
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  ).then((value) {
                                    if (value != null) {
                                      var current = DateTime.now();
                                      var newDate = new DateTime(
                                          current.year,
                                          current.month,
                                          current.day,
                                          0,
                                          0,
                                          0,
                                          0,
                                          0);

                                      if (value.compareTo(newDate) < 0) {
                                        _showToast(context,
                                            'Date should not be less than current date');
                                        _dateControllerText.text = '';

                                        setState(() {
                                          _dateControllerText.text = '';
                                          _validity = '';
                                        });
                                        return;
                                      }
                                      String day = value.day.toString();
                                      String month = value.month.toString();
                                      String year = value.year.toString();
                                      String date = '${day}-${month}-${year}';

                                      _dateControllerText.text = date;

                                      setState(() {
                                        _dateControllerText.text = date;
                                        _validity = date;
                                      });
                                    }
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                              child: TextFormField(
                                autofocus: true,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  DecimalTextInputFormatter(decimalRange: 2)
                                ],
                                controller: edtMinimumAmount,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                onChanged: _minimumSpendChanged,
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
                                  hintText: 'Minimum Spend Amount',
                                  filled: true,
                                  fillColor: colors.backgroundColor,
                                  labelText: 'Minimum Spend Amount',
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                              child: TextFormField(
                                autofocus: true,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                onChanged: _discountChanged,
                                inputFormatters: [
                                  DecimalTextInputFormatter(decimalRange: 2)
                                ],
                                controller: edtDiscountController,
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
                                  hintText: 'Discount',
                                  filled: true,
                                  fillColor: colors.backgroundColor,
                                  labelText: 'Discount',
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    color: colors.buttonColor,
                                  ),
                                  width: 100,
                                  height: 50,
                                  child: Center(
                                    child: MyWidgets.getTextWidget(
                                        text: btnText,
                                        size: Fonts.button_size,
                                        color: colors.buttonTextColor),
                                  ),
                                ),
                                onTap: _addVoucher,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _showToast(BuildContext context, var _message) {
    MyWidgets.showToast(context, _message);
  }

  void stopLoading() {
    setState(() {
      _displayLoadingWidget = false;
    });
  }

  Future<void> _addVoucher() async {
    setState(() {
      _displayLoadingWidget = true;
    });
    if (_voucherTitle.trim() == '') {
      _showToast(context, "Enter Voucher");
      stopLoading();
      return;
    }
    if (_validity.trim() == '') {
      _showToast(context, "Enter Expiry Date");
      stopLoading();
      return;
    }
    if (_minimumSpend.trim() == '') {
      _showToast(context, "Enter Minimum Spend Amount");
      stopLoading();
      return;
    }
    if (_discount.trim() == '') {
      _showToast(context, "Enter Discount");
      stopLoading();
      return;
    }
    if (double.parse(_minimumSpend) < double.parse(_discount)) {
      _showToast(
          context, "Minimum Spend Amount should be greater than Discount");
      stopLoading();
      return;
    }
    if (widget.actionType != 'update') {
      var value = await _foodMenuUIController.addVoucher(
          _voucherTitle, _validity, _minimumSpend, _discount);
      if (value) {
        await new Future.delayed(const Duration(seconds: 2));
        _showToast(context, "Record Added");
        setState(() {
          _displayLoadingWidget = false;
        });
        Navigator.pop(context);
        return;
      } else {
        _showToast(context, "Fail to add record");
        setState(() {
          _displayLoadingWidget = false;
        });
      }
    } else {
      var value = await _foodMenuUIController.updateVoucher(_voucherTitle,
          _validity, _minimumSpend, _discount, widget._voucher.getId);
      if (value) {
        _showToast(context, "Record updated");
        await new Future.delayed(const Duration(seconds: 2));
        setState(() {
          _displayLoadingWidget = false;
        });
        Navigator.pop(context);
        return;
      } else {
        _showToast(context, "Fail to update record");
        setState(() {
          _displayLoadingWidget = false;
        });
      }
    }
    setState(() {
      _displayLoadingWidget = false;
    });
  }

  void _voucherTitleChanged(String value) {
    _voucherTitle = value;
  }

  void _minimumSpendChanged(String value) {
    _minimumSpend = value;
  }

  void _validityChanged(String value) {
    _validity = value;
    print('vsv' + '$_validity');
  }

  void _discountChanged(String value) {
    _discount = value;
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
