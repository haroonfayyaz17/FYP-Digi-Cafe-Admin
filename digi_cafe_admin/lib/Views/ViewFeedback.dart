import 'package:digi_cafe_admin/Controllers/UIControllers/OrderUIController.dart';
import 'package:digi_cafe_admin/Views/LoadingWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:digi_cafe_admin/Views/MenuItemWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ViewFeedback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: _ViewFeedback(),
    );
  }
}

class _ViewFeedback extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => __ViewFeedback();
}

class __ViewFeedback extends State<_ViewFeedback>
    with TickerProviderStateMixin {
  List<String> filterTypeOptionList = <String>['Daily', 'Monthly', 'Yearly'];

  String chosenFilterType;
  String chosenFilterCategory;
  BuildContext _buildContext;
  AnimationController _controller;

  var _fromDateController = new TextEditingController();
  var _toDateController = new TextEditingController();
  StateSetter _setState;

  var _displayLoadingWidget = false;
  Stream<QuerySnapshot> selectedItemsSnapshot;

  bool _buttonPressed = false;

  var totalOrders = '';
  var totalAmount = '';
  double amount = 0, orders = 0;

  var displayAlertMsg = false;

  DateTime fromDate;

  DateTime toDate;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    // TODO: implement build
    return Scaffold(
      appBar: getSalesAppBar(),
      body: Container(),
    );
  }

  void createFilterAlert(context) async {
    // _fromDateController.text = _toDateController.text = '';
    displayAlertMsg = false;
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
        title: 'Filter Results',
        content: StatefulBuilder(
          // You need this, notice the parameters below:
          builder: (BuildContext context, StateSetter setState) {
            _setState = setState;
            return Column(
              children: [
                displayAlertMsg
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                        child: Text(
                          'Incomplete Fields',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: Fonts.dialog_heading_size,
                              fontFamily: Fonts.default_font,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : Container(),
                // DialogInstruction.getInstructionRow('Single tap to update Order'),
                // Padding(
                //   padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                //   child: DropdownButtonFormField<String>(
                //     value: chosenFilterType,
                //     autofocus: true,
                //     icon: Icon(Icons.arrow_drop_down),
                //     iconSize: 24,
                //     decoration: InputDecoration(
                //       focusedBorder: OutlineInputBorder(
                //         borderSide:
                //             BorderSide(color: colors.buttonColor, width: 1.3),
                //       ),
                //       enabledBorder: OutlineInputBorder(
                //         borderSide:
                //             BorderSide(color: colors.buttonColor, width: 1.3),
                //       ),
                //       hintText: 'FilterCategory',
                //       filled: true,
                //       fillColor: colors.backgroundColor,
                //       labelText: 'FilterCategory',
                //       icon: Icon(
                //         Icons.person_outline,
                //       ),
                //     ),
                //     onChanged: (String newValue) {
                //       setState(() {
                //         chosenFilterCategory = newValue;
                //       });
                //     },
                //     items: filterTypeOptionCategory
                //         .map<DropdownMenuItem<String>>((String value) {
                //       return DropdownMenuItem<String>(
                //         value: value,
                //         child: Text(
                //           value,
                //         ),
                //       );
                //     }).toList(),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: DropdownButtonFormField<String>(
                    value: chosenFilterType,
                    autofocus: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: colors.buttonColor, width: 1.3),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: colors.buttonColor, width: 1.3),
                      ),
                      hintText: 'FilterType',
                      filled: true,
                      fillColor: colors.backgroundColor,
                      labelText: 'FilterType',
                      icon: Icon(
                        Icons.person_outline,
                      ),
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        chosenFilterType = newValue;
                      });
                    },
                    items: filterTypeOptionList
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
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: TextFormField(
                    controller: _fromDateController,
                    readOnly: true,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
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
                      filled: true,
                      fillColor: colors.backgroundColor,
                      labelText: 'From Date',
                      icon: Icon(
                        Icons.calendar_today,
                      ),
                    ),
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      ).then((value) {
                        if (value != null) {
                          String day = value.day.toString();
                          String month = value.month.toString();
                          String year = value.year.toString();
                          String date = '${day}-${month}-${year}';

                          _fromDateController.text = date;

                          setState(() {
                            fromDate = value;
                            _fromDateController.text = date;
                          });
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: TextFormField(
                    controller: _toDateController,
                    readOnly: true,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
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
                      filled: true,
                      fillColor: colors.backgroundColor,
                      labelText: 'To Date',
                      icon: Icon(
                        Icons.calendar_today,
                      ),
                    ),
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      ).then((value) {
                        if (value != null) {
                          String day = value.day.toString();
                          String month = value.month.toString();
                          String year = value.year.toString();
                          String date = '${day}-${month}-${year}';
                          toDate = value;

                          if (value.compareTo(fromDate) >= 0) {
                            setState(() {
                              _toDateController.text = date;
                            });
                          } else {
                            setState(() {
                              _toDateController.text = '';
                            });
                          }
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30, right: 10, bottom: 5, top: 5),
                  child: ClipPath(
                    clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25)))),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.buttonColor,
                      ),
                      child: FlatButton(
                        color: colors.buttonColor,
                        child: Text(
                          'Apply',
                          style: TextStyle(
                            fontSize: Fonts.button_size,
                            fontFamily: Fonts.default_font,
                            color: colors.buttonTextColor,
                          ),
                        ),
                        onPressed: () async {
                          DateTime fromDateTemp = fromDate;
                          DateTime toDateTemp = toDate;

                          if (chosenFilterType != null &&
                              (_fromDateController.text != null ||
                                  _fromDateController.text != '') &&
                              (_toDateController.text != null ||
                                  _toDateController.text != '')) {
                            String type;
                            if (chosenFilterType == 'Daily') {
                              type = 'Date';

                              fromDateTemp = new DateTime(fromDate.year,
                                  fromDate.month, fromDate.day, 0, 0, 0, 0, 0);
                              toDateTemp = new DateTime(toDate.year,
                                  toDate.month, toDate.day, 0, 0, 0, 0, 0);
                            } else if (chosenFilterType == 'Monthly') {
                              type = 'Month';
                              fromDateTemp = new DateTime(fromDate.year,
                                  fromDate.month, 1, 0, 0, 0, 0, 0);
                              toDateTemp = new DateTime(
                                  toDate.year, toDate.month, 1, 0, 0, 0, 0, 0);
                            } else {
                              type = 'Year';
                              fromDateTemp = new DateTime(
                                  fromDate.year, 1, 1, 0, 0, 0, 0, 0);
                              toDateTemp = new DateTime(
                                  toDate.year, 1, 1, 0, 0, 0, 0, 0);
                            }
                          } else {
                            setState(() {
                              displayAlertMsg = true;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
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

  Widget getSalesAppBar() {
    return AppBar(
      backgroundColor: colors.buttonColor,
      title: Text(
        'Digi Café Admin',
        style: TextStyle(
          fontFamily: Fonts.default_font,
          fontSize: Fonts.label_size,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 18.0, right: 20),
          child: InkWell(
            child: Text(
              'Filter',
              style: TextStyle(
                fontFamily: Fonts.default_font,
                fontSize: Fonts.label_size,
              ),
            ),
            onTap: () {
              createFilterAlert(context);
            },
          ),
        ),
      ],
    );
  }
}

String getAlphabeticalMonth(int month, int year) {
  if (month != null) {
    // var lst = docID.split('-');
    var months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month] + ', ' + year.toString();
  }
  return '';
}

void _showToast(BuildContext context, var _message) {
  final scaffold = Scaffold.of(context);
  scaffold.showSnackBar(
    SnackBar(
      backgroundColor: colors.buttonColor,
      content: Text(
        '$_message',
        style: TextStyle(
          color: colors.textColor,
          fontFamily: Fonts.default_font,
          fontSize: Fonts.appBarTitle_size,
        ),
      ),
      // action: SnackBarAction(
      //     label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}
