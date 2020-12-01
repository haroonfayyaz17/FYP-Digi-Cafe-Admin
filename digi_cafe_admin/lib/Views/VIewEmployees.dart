import 'package:digi_cafe_admin/Views/AppBarWidget.dart';
import 'package:digi_cafe_admin/Views/DialogInstruction.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/EmployeeUIController.dart';
import 'package:digi_cafe_admin/Model/Cafe Employee.dart';
import 'package:digi_cafe_admin/Views/AddEmployee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ViewEmployees extends StatelessWidget {
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
            DialogInstruction.getInstructionRow(
                'Single tap to update employee\ndata'),
            DialogInstruction.getInstructionRow(
                'Long Press to delete employee\ndata'),
          ],
        )).show();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBarWidget.getAppBar(),
      body: _ViewEmployees(),
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
              label: 'Add Employee',
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
                            AddEmployeeScreen()));
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
    );
  }
}

class _ViewEmployees extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return __ViewEmployees();
  }
}

class __ViewEmployees extends State<_ViewEmployees> {
  EmployeeUIController uiController;
  List<CafeEmployee> employees;
  BuildContext _buildContext;
  @override
  void initState() {
    uiController = new EmployeeUIController();
    _getEmployeesList();
  }

  Future _getEmployeesList() async {
    List<CafeEmployee> list = await uiController.ViewEmployeesList();

    setState(() {
      employees = list;
    });
  }

  Widget build(BuildContext context) {
    _buildContext = context;

    return SingleChildScrollView(
      child: employees == null
          ? ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child: Center(
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        strokeWidth: 10,
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Colors.orangeAccent),
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      padding: EdgeInsets.only(left: 40, top: 25),
                      child: Image.asset('images/logo.png'),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: employees.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    //TODO: Update Employee
                    debugPrint('${employees.elementAt(index).id}');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddEmployeeScreen(
                                    employee: employees.elementAt(index),
                                    actionType: "update")));
                  },
                  onLongPress: () {
                    //TODO: Delete Employee
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                          content: Text(
                            'Do you want to remove Employee?',
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: colors.buttonColor,
                              ),
                              child: FlatButton(
                                onPressed: () async {
                                  //TODO: Delete Employee

                                  bool result =
                                      await uiController.deleteEmployee(
                                          employees.elementAt(index).id);

                                  Navigator.pop(context);
                                  if (result.toString() == "true") {
                                    _showToast(_buildContext,
                                        "Employee deleted successfully");
                                    _getEmployeesList();
                                  } else {
                                    _showToast(_buildContext,
                                        "Employee delete unsuccessful");
                                  }
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
                          ]),
                    );
                  },
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 10,
                    ),
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(10.0),
                            height: 120.0,
                            width: 120,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: employees.elementAt(index).imgURL == null
                                    ? Image.asset('images/profile_pic.png')
                                    : Image.network(
                                        employees.elementAt(index).imgURL)),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width - 150,
                                child: Text(
                                  employees.elementAt(index).Name,
                                  style: TextStyle(
                                      fontFamily: Fonts.default_font,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 150,
                                child: Text(
                                  employees.elementAt(index).userType,
                                  style: TextStyle(
                                    fontFamily: Fonts.default_font,
                                    fontSize: 21,
                                  ),
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
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
