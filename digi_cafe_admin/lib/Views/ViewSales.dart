import 'package:digi_cafe_admin/Controllers/UIControllers/OrderUIController.dart';
import 'package:digi_cafe_admin/Views/LoadingWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:digi_cafe_admin/Views/MenuItemWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:digi_cafe_admin/Model/Order.dart';

class ViewSales extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: _ViewSales(),
    );
  }
}

class _ViewSales extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => __ViewSales();
}

class __ViewSales extends State<_ViewSales> {
  List<MenuItemWidget> menuItemWidget = [];
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  OrderUIController _OrderUIController;

  Stream<QuerySnapshot> querySnapshot;

  BuildContext _buildContext;
  OrderUIController uiController;
  var _dateControllerText1 = new TextEditingController();
  var _dateControllerText2 = new TextEditingController();
  bool _buttonPressed = false;
  @override
  void initState() {
    super.initState();
    uiController = new OrderUIController();
    querySnapshot = uiController.getOrdersSnapshot();
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    // TODO: implement build
    return Scaffold(
      appBar: getSalesAppBar(),
      floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 20),
          backgroundColor: colors.buttonColor,
          children: []),
      body: Flex(
          direction: Axis.vertical,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: querySnapshot,
                builder: (context, snapshot) {
                  //return snapshot.hasData

                  return !snapshot.hasData
                      ? LoadingWidget()
                      : ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot element =
                                snapshot.data.documents[index];
                            Widget widget = SaleItemWidget(
                              date: element.documentID,
                              total: element.data['TotalAmount'],
                              orders: element.data['TotalOrders'],
                            );

                            return widget;
                          });
                },
              ),
            ),
          ]),
    );
  }

  void createFilterAlert(context) async {
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
      title: 'Select Dates',
      content: Column(
        children: [
          // DialogInstruction.getInstructionRow('Single tap to update Order'),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
            child: TextFormField(
              controller: _dateControllerText1,
              readOnly: true,
              autofocus: true,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colors.buttonColor, width: 1.3),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colors.buttonColor, width: 1.3),
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
                  String day = value.day.toString();
                  String month = value.month.toString();
                  String year = value.year.toString();
                  String date = '${day}-${month}-${year}';

                  _dateControllerText1.text = date;

                  setState(() {
                    _dateControllerText1.text = date;
                  });
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
            child: TextFormField(
              controller: _dateControllerText2,
              readOnly: true,
              autofocus: true,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colors.buttonColor, width: 1.3),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: colors.buttonColor, width: 1.3),
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
                  String day = value.day.toString();
                  String month = value.month.toString();
                  String year = value.year.toString();
                  String date = '${day}-${month}-${year}';

                  _dateControllerText2.text = date;
                  if (_dateControllerText2.text
                          .compareTo(_dateControllerText1.text) >=
                      0) {
                    setState(() {
                      _dateControllerText2.text = date;
                    });
                  } else {
                    setState(() {
                      _dateControllerText2.text = '';
                    });
                  }
                });
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colors.buttonColor,
            ),
            width: 150,
            height: 40,
            child: FlatButton(
              color: colors.buttonColor,
              child: Text(
                'Check Sales',
                style: TextStyle(
                  fontSize: Fonts.button_size,
                  fontFamily: Fonts.default_font,
                  color: colors.buttonTextColor,
                ),
              ),
              onPressed: () {
                FutureBuilder<bool>(
                  builder: (context, snapshot) {
                    return Container();
                  },
                );
              },
            ),
          ),
          // DialogInstruction.getInstructionRow('Long Press to delete Order'),
        ],
      ),
    ).show();
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

class SaleItemWidget extends StatefulWidget {
  String date;
  String total;
  String orders;
  SaleItemWidget({
    @required this.date,
    @required this.total,
    @required this.orders,
  });
  @override
  _SaleItemWidgetState createState() => _SaleItemWidgetState();
}

class _SaleItemWidgetState extends State<SaleItemWidget> {
  OrderUIController _OrderUIController;

  BuildContext _buildContext;

  // var quantityController = new TextEditingController();
  @override
  void initState() {
    _OrderUIController = new OrderUIController();
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
              child: Card(
                elevation: 10,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.6),
                                    child: Text(
                                      widget.date,
                                      style: TextStyle(
                                        fontFamily: Fonts.default_font,
                                        fontSize: Fonts.dishName_font,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Spacer(flex: 2),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Text(
                                      '${widget.orders}',
                                      style: TextStyle(
                                        fontFamily: Fonts.default_font,
                                        fontSize: Fonts.dishName_font,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                widget.total,
                                style: TextStyle(
                                  fontFamily: Fonts.default_font,
                                  fontSize: Fonts.dishDescription_font,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
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
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text('$_message'),
        // action: SnackBarAction(
        //     label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
