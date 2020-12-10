import 'package:digi_cafe_admin/Controllers/UIControllers/FoodMenuUIController.dart';
import 'package:digi_cafe_admin/Views/AppBarWidget.dart';
import 'package:digi_cafe_admin/Views/LoadingWidget.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:intl/intl.dart';

_NominateItemsState state;

class NominateItemsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      // backgroundColor: colors.backgroundColor,
      child: NominateItemsState(),
    );
  }
}

class NominateItemsState extends StatefulWidget {
  const NominateItemsState({Key key}) : super(key: key);

  @override
  _NominateItemsState createState() {
    state = _NominateItemsState();
    return state;
  }
}

class _NominateItemsState extends State<NominateItemsState> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  List<NominateItems> nominateItems;

  FoodMenuUIController _foodMenuUIController;
  NominateItemsDataSource _ds;
  Stream<QuerySnapshot> querySnapshot;
  Stream<QuerySnapshot> selectedItemsSnapshot;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext _buildContext;
  var _displayLoadingWidget = false;
  @override
  void initState() {
    super.initState();
    _foodMenuUIController = new FoodMenuUIController();
    querySnapshot = _foodMenuUIController.getFoodMenuSnapshot();
    selectedItemsSnapshot =
        _foodMenuUIController.getNominatedItemsSnapshot(null);
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarWidget.getAppBar(),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 120, right: 120, bottom: 5),
          child: ClipPath(
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)))),
            child: Container(
              decoration: BoxDecoration(
                color: colors.buttonColor,
              ),
              width: 50,
              height: 30,
              child: FlatButton(
                color: colors.buttonColor,
                child: Text(
                  'Nominate Items',
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
                    future: _nominateSelectedItems(context),
                  );
                },
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Stack(children: [
            _displayLoadingWidget
                ? LoadingWidget()
                : StreamBuilder<QuerySnapshot>(
                    stream: querySnapshot,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<NominateItems> listItems = new List();
                        for (int count = 0;
                            count < snapshot.data.documents.length;
                            count++) {
                          DocumentSnapshot dish =
                              snapshot.data.documents[count];
                          NominateItems items = new NominateItems(
                              dish.documentID,
                              dish.data['name'],
                              dish.data['price'].toDouble(),
                              dish.data['stockLeft'].toDouble());
                          listItems.add(items);
                        }
                        _ds = new NominateItemsDataSource(listItems);
                        // return Container(
                        //   color: colors.backgroundColor,
                        // );
                        return SingleChildScrollView(
                          child: PaginatedDataTable(
                            header: Center(
                              child: Text(
                                'Nominate Items',
                                style: TextStyle(
                                  fontSize: Fonts.heading1_size,
                                  fontFamily: Fonts.default_font,
                                ),
                              ),
                            ),
                            dataRowHeight: MediaQuery.of(context).size.height *
                                0.7 /
                                _rowsPerPage,
                            rowsPerPage: _rowsPerPage,
                            availableRowsPerPage: <int>[5, 10, 20],
                            onRowsPerPageChanged: (int value) {
                              setState(() {
                                _rowsPerPage = value;
                              });
                            },
                            columns: kTableColumns,
                            source: _ds,
                          ),
                        );
                      } else {
                        return LoadingWidget();
                      }
                    }),
          ]),
        ));

    // _rowsPerPage = _rowsPerPage > _ds.nominateItems.length
    //     ? _ds.nominateItems.length
    //     : _rowsPerPage;
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

  Future<bool> _nominateSelectedItems(context) async {
    setState(() {
      _displayLoadingWidget = true;
    });
    List<String> _itemsSelected = new List();
    for (int i = 0; i < _ds.nominateItems.length; i++) {
      if (_ds.nominateItems[i].selected) {
        _itemsSelected.add(_ds.nominateItems[i].itemID);
      }
    }
    if (_itemsSelected.length > 0) {
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      final String formatted = formatter.format(now);
      bool result = await _foodMenuUIController.addNominatedItems(
          _itemsSelected, formatted);
      setState(() {
        _displayLoadingWidget = false;
      });
      if (result) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Items Nominated Successfully'),
          duration: Duration(seconds: 3),
        ));
      }
    }
    //  else {
    //   _scaffoldKey.currentState.showSnackBar(SnackBar(
    //     content: Text('No Item Selected'),
    //     duration: Duration(seconds: 3),
    //   ));
    //   // _showToast(context, 'No Item Selected');
    // }
    return Future.value(true);
  }
}

////// Columns in table.
const kTableColumns = <DataColumn>[
  DataColumn(
    label: Text(
      'Item Name',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: Fonts.heading2_size,
        fontFamily: Fonts.default_font,
      ),
    ),
  ),
  DataColumn(
    label: Text(
      'Price',
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
      'Stock',
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
class NominateItems {
  NominateItems(this.itemID, this.itemName, this.price, this.quantity);
  var itemID;
  final String itemName;
  final double quantity;
  final double price;
  bool selected = false;
}

////// Data source class for obtaining row data for PaginatedDataTable.
class NominateItemsDataSource extends DataTableSource {
  NominateItemsDataSource(List<NominateItems> nominate) {
    nominateItems = nominate;
  }
  int _selectedCount = 0;
  List<NominateItems> nominateItems;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= nominateItems.length) return null;

    final NominateItems _nominateItems = nominateItems[index];
    return DataRow.byIndex(
        index: index,
        selected: _nominateItems.selected,
        onSelectChanged: (bool value) {
          // allow only 4 selections
          if (_selectedCount > 3 && value) {
            print('Selection limit reached');
            return;
          }
          if (_nominateItems.selected != value) {
            _selectedCount += value ? 1 : -1;
            assert(_selectedCount >= 0);
            _nominateItems.selected = value;
            notifyListeners();
          }
        },
        cells: <DataCell>[
          DataCell(
            Text(
              _nominateItems.itemName,
              style: TextStyle(
                fontSize: Fonts.heading3_size,
                fontFamily: Fonts.default_font,
              ),
            ),
          ),
          DataCell(
            Text(
              _nominateItems.price.toStringAsFixed(1),
              style: TextStyle(
                fontSize: Fonts.heading3_size,
                fontFamily: Fonts.default_font,
              ),
            ),
          ),
          DataCell(
            Text(
              _nominateItems.quantity.toStringAsFixed(1),
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
