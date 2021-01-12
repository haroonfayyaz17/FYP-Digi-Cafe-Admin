import 'package:digi_cafe_admin/Controllers/UIControllers/OrderUIController.dart';
import 'package:digi_cafe_admin/Model/Order.dart';
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

// ViewSales todaysMenu;

class ViewSales extends StatelessWidget {
  // var fm;

  // ViewSales() {
  //   final foodList = [
  //     FoodItem('1', 'Biryani', 'Chicken Biryani', null, 120, 3),
  //     FoodItem('1', 'Shawarma', 'Zinger Shawarma', null, 60, 5),
  //     FoodItem('1', 'Sandwich', 'Egg & Chicken', null, 80, 10),
  //     FoodItem('1', 'Sandwich', 'Vegetable & Chicken', null, 50, 3),
  //   ];
  //   todaysMenu = new ViewSales('All', foodList);
  // }

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

  OrderUIController _OrderUIController;
  var prevCategory;
  var count = 0;
  Stream<QuerySnapshot> querySnapshot;

  BuildContext _buildContext;

  var _dateControllerText = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _OrderUIController = new OrderUIController();
    querySnapshot = _OrderUIController.getOrderSnapshot();
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
          children: [
            SpeedDialChild(
              child: Icon(
                Icons.fastfood,
                color: colors.buttonTextColor,
              ),
              label: 'Add Orders',
              labelStyle: TextStyle(
                color: colors.buttonTextColor,
                fontFamily: Fonts.default_font,
                fontSize: Fonts.dialog_heading_size,
              ),
              labelBackgroundColor: colors.buttonColor,
              backgroundColor: colors.buttonColor,
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (BuildContext context) =>
                //             AddOrderScreen(null, null)));
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
                  return snapshot.hasData

                      // return !snapshot.hasData
                      ? LoadingWidget()
                      : ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot Order =
                                snapshot.data.documents[index];

                            // var url = null;
                            // storageReference.getDownloadURL().then((fileURL) {
                            //   url = fileURL;
                            //   print(fileURL);
                            // });
                            // var imgURL = loadPic(Order.documentID);
                            // print(url);
                            Widget widget = SaleItemWidget(
                              discount: Order.data['discount'],
                              expiryDate: Order.data['validity'],
                              minimumSpend: Order.data['minimumSpend'],
                              OrderID: Order.documentID,
                              title: Order.data['title'],
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
            DialogInstruction.getInstructionRow('Single tap to update Order'),
            DialogInstruction.getInstructionRow('Long Press to delete Order'),
          ],
        )).show();
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
      title: 'How to use?',
      content: Column(
        children: [
          // DialogInstruction.getInstructionRow('Single tap to update Order'),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
            child: TextFormField(
              controller: _dateControllerText,
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
                hintText: 'From Date',
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
                  var _dateControllerText;
                  _dateControllerText.text = date;

                  setState(() {
                    _dateControllerText.text = date;
                  });
                });
              },
            ),
          ),
          // DialogInstruction.getInstructionRow('Long Press to delete Order'),
        ],
      ),
      buttons: [
        DialogButton(
          onPressed: () {},
          child: Text(
            "Add to List",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ],
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
  var expiryDate, title, OrderID, minimumSpend, discount;
  BuildContext context;
  SaleItemWidget(
      {@required this.OrderID,
      @required this.expiryDate,
      @required this.title,
      @required this.minimumSpend,
      @required this.discount,
      this.context});

  @override
  _SaleItemWidgetState createState() => _SaleItemWidgetState();
}

class _SaleItemWidgetState extends State<SaleItemWidget> {
  OrderUIController _OrderUIController;

  BuildContext _buildContext;

  var quantityController = new TextEditingController();
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
              onTap: () {
                //TODO: Update Order

                // Order _Order = new Order(
                //     // id: widget.OrderID,
                //     // title: widget.title,
                //     // minimumSpend: widget.minimumSpend,
                //     // validity: widget.expiryDate,
                //     // discount: widget.discount,
                //     // usedOn: null,
                //     );

                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (BuildContext context) =>
                //             AddOrderScreen(_Order, "update")));
              },
              onLongPress: () {
                //TODO: Delete Order
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Text(
                      'Do you want to remove Order?',
                      style: TextStyle(
                        fontFamily: Fonts.default_font,
                        fontSize: Fonts.heading2_size,
                        color: colors.labelColor,
                      ),
                    ),
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
                          child: Text(
                            'No',
                            style: TextStyle(
                              fontFamily: Fonts.default_font,
                              fontSize: Fonts.label_size,
                              color: Colors.white,
                            ),
                          ),
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
                            //TODO: Delete Order
                            // bool result = await _OrderUIController.deleteOrder(
                            //     widget.OrderID);
                            // print(result);
                            // Navigator.pop(context);
                            // if (result.toString() == "true") {
                            //   _showToast(
                            //       widget.context, "Order deleted successfully");
                            // } else {
                            //   _showToast(
                            //       widget.context, "Order delete unsuccessful");
                            // }
                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(
                              fontFamily: Fonts.default_font,
                              fontSize: Fonts.label_size,
                              color: Colors.white,
                            ),
                          ),
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
                                  Text(
                                    widget.title,
                                    style: TextStyle(
                                      fontFamily: Fonts.default_font,
                                      fontSize: Fonts.dishName_font,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Spacer(flex: 2),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Text(
                                      '${widget.expiryDate}',
                                      style: TextStyle(
                                        fontFamily: Fonts.default_font,
                                        fontSize: Fonts.dishDescription_font,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Minimum Spend: ${widget.minimumSpend}',
                                style: TextStyle(
                                  fontFamily: Fonts.default_font,
                                  fontSize: Fonts.dishDescription_font,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Discount: ${widget.discount}',
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
