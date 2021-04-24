import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_cafe_admin/Views/MyWidgets.dart';
import 'package:digi_cafe_admin/Views/DialogInstruction.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/EmployeeUIController.dart';
import 'package:digi_cafe_admin/Model/Cafe Employee.dart';
import 'package:digi_cafe_admin/Views/AddEmployee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'LoadingWidget.dart';

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
      titleStyle: MyWidgets.getTextStyle(
          size: Fonts.dialog_heading_size, weight: FontWeight.bold),
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
      appBar: MyWidgets.getAppBar(text: 'View Employees'),
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
              labelStyle:
                  MyWidgets.getTextStyle(size: Fonts.dialog_heading_size),
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
              labelStyle:
                  MyWidgets.getTextStyle(size: Fonts.dialog_heading_size),
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
  Stream<QuerySnapshot> querySnapshot;

  @override
  void initState() {
    uiController = new EmployeeUIController();
    querySnapshot = uiController.getEmployeeSnapshot();
  }

  Widget build(BuildContext context) {
    _buildContext = context;

    return Flex(
      direction: Axis.vertical,
      verticalDirection: VerticalDirection.down,
      children: <Widget>[
        Flexible(
          child: StreamBuilder<QuerySnapshot>(
            stream: querySnapshot,
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? LoadingWidget()
                  : ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot element =
                            snapshot.data.documents[index];
                        CafeEmployee employee = new CafeEmployee(
                            element.data["Name"],
                            element.data["email"],
                            element.data["gender"],
                            element.data["DOB"],
                            "",
                            element.data["phoneNo"],
                            element.data["PType"],
                            element.data['imgURL']);
                        // print('${element.data['imgURL']}');
                        employee.id = element.documentID;
                        return GestureDetector(
                          onTap: () {
                            //TODO: Update Employee
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AddEmployeeScreen(
                                            employee: employee,
                                            actionType: "update")));
                          },
                          onLongPress: () {
                            //TODO: Delete Employee
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                  content: MyWidgets.getTextWidget(
                                      text: 'Do you want to remove Employee?',
                                      size: Fonts.heading2_size,
                                      color: colors.labelColor),
                                  actions: <Widget>[
                                    Container(
                                      // width: MediaQuery.of(context).size.width * 0.3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: colors.buttonColor,
                                      ),
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: MyWidgets.getTextWidget(
                                            text: 'No',
                                            color: colors.buttonTextColor,
                                            size: Fonts.label_size),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: colors.buttonColor,
                                      ),
                                      child: FlatButton(
                                          onPressed: () async {
                                            //TODO: Delete Employee

                                            bool result = await uiController
                                                .deleteEmployee(employee.id);

                                            Navigator.pop(context);
                                            if (result.toString() == "true") {
                                              _showToast(_buildContext,
                                                  "Employee deleted successfully");
                                            } else {
                                              _showToast(_buildContext,
                                                  "Employee delete unsuccessful");
                                            }
                                          },
                                          child: MyWidgets.getTextWidget(
                                              text: 'Yes',
                                              color: colors.buttonTextColor,
                                              size: Fonts.label_size)),
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
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        child: employee.imgURL == null
                                            ? Image.asset(
                                                'images/profile_pic.png')
                                            : Image.network(employee.imgURL)),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              150,
                                          child: MyWidgets.getTextWidget(
                                              text: employee.Name,
                                              size: Fonts.heading1_size,
                                              weight: FontWeight.w500)),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              150,
                                          child: MyWidgets.getTextWidget(
                                            text: employee.userType,
                                            size: Fonts.heading2_size,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
            },
          ),
        ),
      ],
    );
  }

  void _showToast(BuildContext context, var _message) {
    MyWidgets.showToast(context, _message);
  }
}
