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
  NominateItemsDataSource _ds;

  List<SalesViewItems> nominateItems;

  OrderUIController _orderUIController;
  var _displayLoadingWidget = false;
  Stream<QuerySnapshot> selectedItemsSnapshot;

  bool _buttonPressed = false;

  var totalOrders;
  var totalAmount;
  double amount = 0, orders = 0;
  @override
  void initState() {
    super.initState();
    uiController = new OrderUIController();
    querySnapshot = uiController.getOrdersSnapshot();
    // button = FlatButton(
    //     child: Text(""),
    //     onPressed: () {
    //       print('yes');
    //       setState(() {
    //         // totalOrders = 'Total Orders: ' +
    //         //     orders.toStringAsFixed(1);
    //         // totalAmount = 'Total Amount: ' +
    //         //     amount.toStringAsFixed(1);
    //         totalOrders = 'Total Orders: ';
    //         totalAmount = 'Total Amount: ';
    //       });
    //     });
    // button.color = colors.backgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    // TODO: implement build
    return Scaffold(
      appBar: getSalesAppBar(),
      bottomNavigationBar: Row(
        children: [Text('$totalOrders'), Text('$totalAmount')],
      ),
      body: Flex(
        direction: Axis.vertical,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Flexible(
            //ye paginated ka hai
            child: Stack(
              children: [
                _displayLoadingWidget
                    ? LoadingWidget()
                    : StreamBuilder<QuerySnapshot>(
                        stream: querySnapshot,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.done:
                              print('yes');
                              setState(() {
                                // totalOrders = 'Total Orders: ' +
                                //     orders.toStringAsFixed(1);
                                // totalAmount = 'Total Amount: ' +
                                //     amount.toStringAsFixed(1);
                                totalOrders = 'Total Orders: ';
                                totalAmount = 'Total Amount: ';
                              });
                              return Container();
                              break;
                            case ConnectionState.active:
                              if (snapshot.hasData) {
                                List<SalesViewItems> listItems = new List();
                                double amount = 0, orders = 0;
                                for (int count = 0;
                                    count < snapshot.data.documents.length;
                                    count++) {
                                  DocumentSnapshot element =
                                      snapshot.data.documents[count];
                                  SalesViewItems items = new SalesViewItems(
                                      element.documentID,
                                      // element.data['date'],
                                      element.data['totalOrders'],
                                      element.data['totalAmount']);
                                  if (items.orders != null) {
                                    orders += items.orders;
                                  }
                                  if (items.total != null) {
                                    amount += items.total;
                                  }
                                  listItems.add(items);
                                }
                                // for (var x = 0; x < listItems.length; x++) {
                                //   print(listItems[x].date);
                                //   print(listItems[x].total);
                                //   print(listItems[x].orders);
                                // }

                                // button.onPressed();
                                _ds = new NominateItemsDataSource(listItems);
                                // return Container(
                                //   color: colors.backgroundColor,
                                // );
                                return SingleChildScrollView(
                                  child: PaginatedDataTable(
                                    header: Center(
                                      child: Text(
                                        'View Sales',
                                        style: TextStyle(
                                          fontSize: Fonts.heading1_size,
                                          fontFamily: Fonts.default_font,
                                        ),
                                      ),
                                    ),
                                    // dataRowHeight:
                                    //     MediaQuery.of(context).size.height *
                                    //         0.7 /
                                    //         _rowsPerPage,
                                    rowsPerPage: _rowsPerPage,
                                    availableRowsPerPage: <int>[5, 10, 20],
                                    onRowsPerPageChanged: (int value) {
                                      setState(() {
                                        _rowsPerPage = value;
                                      });
                                    },
                                    showCheckboxColumn: false,
                                    columns: kTableColumns,
                                    source: _ds,
                                  ),
                                );
                              } else {
                                return LoadingWidget();
                              }
                              break;
                            default:
                              // setState(() {
                              //   // totalOrders = 'Total Orders: ' +
                              //   //     orders.toStringAsFixed(1);
                              //   // totalAmount = 'Total Amount: ' +
                              //   //     amount.toStringAsFixed(1);
                              //   totalOrders = 'Total Orders: ';
                              //   totalAmount = 'Total Amount: ';
                              // });
                              print('${snapshot.connectionState}');
                              return Container();
                              break;
                          }
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
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
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  List<SalesViewItems> nominateItems;
  BuildContext _buildContext;

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
            child: InkWell(
              child: Column(
                children: <Widget>[
                  // ye table hai
                  // Padding(
                  //   padding: EdgeInsets.all(8.0),
                  //   child: Text(
                  //     "TOTAL SALES",
                  //     // textScaleFactor: 2.0,
                  //     style: TextStyle(
                  //       fontSize: Fonts.heading1_size,
                  //       fontFamily: Fonts.default_font,
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.all(10.0),
                  //   child: Table(
                  //     border: TableBorder.all(
                  //         width: 1.5, color: colors.buttonColor),
                  //     children: [
                  //       TableRow(children: [
                  //         Padding(
                  //           padding: const EdgeInsets.only(),
                  //           child: Text(
                  //             "Date",
                  //             style: TextStyle(
                  //               fontWeight: FontWeight.bold,
                  //               fontSize: Fonts.heading2_size,
                  //               fontFamily: Fonts.default_font,
                  //             ),
                  //           ),
                  //         ),
                  //         Text(
                  //           "Orders",
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: Fonts.heading2_size,
                  //             fontFamily: Fonts.default_font,
                  //           ),
                  //         ),
                  //         Text(
                  //           "Sale",
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: Fonts.heading2_size,
                  //             fontFamily: Fonts.default_font,
                  //           ),
                  //         ),
                  //       ]),
                  //       TableRow(children: [
                  //         Text(
                  //           widget.date,
                  //           style: TextStyle(
                  //             fontFamily: Fonts.default_font,
                  //             fontSize: Fonts.heading2_XL_size,
                  //             // fontWeight: FontWeight.bold,
                  //           ),
                  //           overflow: TextOverflow.ellipsis,
                  //         ),
                  //         // Spacer(flex: 2),
                  //         Text(
                  //           widget.orders,
                  //           style: TextStyle(
                  //             fontFamily: Fonts.default_font,
                  //             fontSize: Fonts.heading2_XL_size,
                  //           ),
                  //           overflow: TextOverflow.ellipsis,
                  //         ),
                  //         // Spacer(flex: 2),
                  //         Text(
                  //           widget.total,
                  //           style: TextStyle(
                  //             fontFamily: Fonts.default_font,
                  //             fontSize: Fonts.heading2_XL_size,
                  //           ),
                  //           overflow: TextOverflow.ellipsis,
                  //         ),
                  //         //Spacer(flex: 2),
                  //       ]),
                  //     ],
                  //   ),
                  // )
                ],
                //   ),
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

//idr se paginated shuru ho gya
////// Columns in table.
const kTableColumns = <DataColumn>[
  DataColumn(
    label: Text(
      'Date',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: Fonts.heading2_size,
        fontFamily: Fonts.default_font,
      ),
    ),
  ),
  DataColumn(
    label: Text(
      'Orders',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: Fonts.heading2_size,
        fontFamily: Fonts.default_font,
      ),
    ),
    numeric: true,
  ),
  DataColumn(
    label: Text(
      'Total Sale',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: Fonts.heading2_size,
        fontFamily: Fonts.default_font,
      ),
    ),
    numeric: true,
  ),
];

////// Data class.
class SalesViewItems {
  SalesViewItems(this.date, this.orders, this.total);
  var itemID;
  var date;
  var orders;
  var total;
  bool selected = false;
}

////// Data source class for obtaining row data for PaginatedDataTable.
class NominateItemsDataSource extends DataTableSource {
  NominateItemsDataSource(List<SalesViewItems> nominate) {
    nominateItems = nominate;
  }
  int _selectedCount = 0;
  List<SalesViewItems> nominateItems;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= nominateItems.length) return null;

    final SalesViewItems _nominateItems = nominateItems[index];
    return DataRow.byIndex(
        index: index,
        selected: _nominateItems.selected,
        cells: <DataCell>[
          DataCell(
            Text(
              _nominateItems.date,
              style: TextStyle(
                fontSize: Fonts.heading3_size,
                fontFamily: Fonts.default_font,
              ),
            ),
          ),
          DataCell(
            Text(
              _nominateItems.orders.toString(),
              style: TextStyle(
                fontSize: Fonts.heading3_size,
                fontFamily: Fonts.default_font,
              ),
            ),
          ),
          DataCell(
            Text(
              _nominateItems.total.toString(),
              style: TextStyle(
                fontSize: Fonts.heading3_size,
                fontFamily: Fonts.default_font,
              ),
            ),
          ),
        ]);
  }

  @override
  int get rowCount {
    return nominateItems.length;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
