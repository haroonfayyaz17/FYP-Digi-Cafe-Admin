import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/style/colors.dart';

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
  NominateItemsDataSource _ds = new NominateItemsDataSource();
  @override
  Widget build(BuildContext context) {
    _rowsPerPage = _rowsPerPage > _ds.nominateItems.length
        ? _ds.nominateItems.length
        : _rowsPerPage;
    return SafeArea(
      child: Container(
        color: colors.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: SingleChildScrollView(
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
              dataRowHeight:
                  MediaQuery.of(context).size.height * 0.7 / _rowsPerPage,
              rowsPerPage:
                  // _rowsPerPage,
                  _ds.nominateItems.length < _rowsPerPage
                      ? _ds.nominateItems.length
                      : _rowsPerPage,
              availableRowsPerPage: <int>[5, _ds.nominateItems.length, 10, 20],
              onRowsPerPageChanged: (int value) {
                setState(() {
                  _rowsPerPage = value;
                });
              },
              columns: kTableColumns,
              source: _ds,
            ),
          ),
        ),
      ),
    );
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
];

////// Data class.
class NominateItems {
  NominateItems(this.itemName, this.price);
  final String itemName;

  final double price;
  bool selected = false;
}

////// Data source class for obtaining row data for PaginatedDataTable.
class NominateItemsDataSource extends DataTableSource {
  NominateItemsDataSource() {
    nominateItems = <NominateItems>[
      NominateItems('Frozen yogurt', 6.0),
      NominateItems('Ice cream sandwich', 9.0),
      NominateItems('Eclair', 16.0),
      NominateItems('Cupcake', 3.7),
      NominateItems('Gingerbread', 16.0),
      NominateItems('Cupcake', 3.7),
      NominateItems('Gingerbread', 16.0)
    ];
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
        ]);
  }

  @override
  int get rowCount => nominateItems.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
