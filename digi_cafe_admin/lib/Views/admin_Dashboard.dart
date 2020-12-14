import 'package:digi_cafe_admin/Views/ViewEmployees.dart';
import 'package:digi_cafe_admin/Views/EmptyCartScreen.dart';
import 'package:digi_cafe_admin/Views/ViewFoodMenu.dart';
import 'package:digi_cafe_admin/Views/ViewVouchers.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:digi_cafe_admin/Controllers/DBControllers/LoginDBController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/Views/NominateItemsScreen.dart';
import '../style/fonts_style.dart';
import 'NoIternetScreen.dart';

class dashboard extends StatelessWidget {
  var email;
  dashboard({this.email});
  @override
  Widget build(BuildContext context) {
    return _dashboard(
      email: email,
    );
    // return WillPopScope(
    //   onWillPop: () {
    //     //exit(0);
    //     Navigator.pop(context);
    //   },
    //   child: _dashboard(),
    // );
    // );
  }
}

class _dashboard extends StatefulWidget {
  var email;
  _dashboard({this.email});
  @override
  State<StatefulWidget> createState() => __dashboard();
}

class __dashboard extends State<_dashboard> {
  BuildContext _buildContext;
  LoginDBController _loginDBController;
  @override
  void initState() {
    super.initState();
    _loginDBController = new LoginDBController();
    // if (dbController.CheckSignIn(adminEmail, adminPassword) == null) {
    // }
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    // TODO: implement build
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          showDialogBox();
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: (MediaQuery.of(context).size.width *
                            Fonts.dashboardItem_heightFactor) -
                        50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    margin: EdgeInsets.all(10.0),
                    child: ClipRRect(
                      child: Image.asset(
                        'images/profile_pic.png',
                      ),
                    ),
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                FittedBox(
                                  child: Text(
                                    'Admin',
                                    style: TextStyle(
                                      fontFamily: Fonts.default_font,
                                      fontSize: Fonts.heading1_size,
                                    ),
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                                FittedBox(
                                  child: Text(
                                    '${widget.email}',
                                    style: TextStyle(
                                      fontFamily: Fonts.default_font,
                                      fontSize: Fonts.heading2_size,
                                    ),
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ]),
                        ),
                      ]),
                ],
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width *
                          Fonts.dashboardItem_widthFactor,
                      height: MediaQuery.of(context).size.width *
                          Fonts.dashboardItem_heightFactor,
                      child: InkWell(
                        onTap: () {
                          //TODO: Manage Employee click
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ViewEmployees()));
                        },
                        child: Card(
                          child: Column(children: <Widget>[
                            Container(
                              height: (MediaQuery.of(context).size.width *
                                      Fonts.dashboardItem_heightFactor) -
                                  30,
                              child: Image.asset('images/manage_employee.png'),
                            ),
                            Flexible(
                              child: Text(
                                'Manage Employees',
                                style: TextStyle(
                                  color: colors.labelColor,
                                  fontSize: Fonts.label_size,
                                  fontFamily: Fonts.default_font,
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width *
                          Fonts.dashboardItem_widthFactor,
                      height: MediaQuery.of(context).size.width *
                          Fonts.dashboardItem_heightFactor,
                      child: InkWell(
                        onTap: () {
                          //TODO: Manage Menu clicked
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new ViewFoodMenu()));
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (BuildContext context) =>
                          //             new AddFoodMenuScreen()));
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (BuildContext context) =>
                          //             new AddCategoryScreen()));
                        },
                        child: Card(
                          child: Column(children: <Widget>[
                            Container(
                              height: (MediaQuery.of(context).size.width *
                                      Fonts.dashboardItem_heightFactor) -
                                  30,
                              child: Image.asset('images/manage_menu.png'),
                            ),
                            Text(
                              'Manage Menu',
                              style: TextStyle(
                                color: colors.labelColor,
                                fontSize: Fonts.label_size,
                                fontFamily: Fonts.default_font,
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width *
                          Fonts.dashboardItem_widthFactor,
                      height: MediaQuery.of(context).size.width *
                          Fonts.dashboardItem_heightFactor,
                      child: InkWell(
                        onTap: () {
                          //TODO: Nominate Items
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new NominateItemsScreen()));
                        },
                        child: Card(
                          child: Column(children: <Widget>[
                            Container(
                              height: (MediaQuery.of(context).size.width *
                                      Fonts.dashboardItem_heightFactor) -
                                  30,
                              child: Image.asset('images/nominate.png'),
                            ),
                            Flexible(
                              child: Text(
                                'Nominate Items',
                                style: TextStyle(
                                  color: colors.labelColor,
                                  fontSize: Fonts.label_size,
                                  fontFamily: Fonts.default_font,
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width *
                          Fonts.dashboardItem_widthFactor,
                      height: MediaQuery.of(context).size.width *
                          Fonts.dashboardItem_heightFactor,
                      child: InkWell(
                        onTap: () {
                          //TODO: ViewSales
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new NoInternetScreen()));
                        },
                        child: Card(
                          child: Column(children: <Widget>[
                            Container(
                              height: (MediaQuery.of(context).size.width *
                                      Fonts.dashboardItem_heightFactor) -
                                  30,
                              child: Image.asset('images/sales.png'),
                            ),
                            Text(
                              'View Sales',
                              style: TextStyle(
                                color: colors.labelColor,
                                fontSize: Fonts.label_size,
                                fontFamily: Fonts.default_font,
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width *
                          Fonts.dashboardItem_widthFactor,
                      height: MediaQuery.of(context).size.width *
                          Fonts.dashboardItem_heightFactor,
                      child: InkWell(
                        onTap: () {
                          //TODO: Check Review click
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new EmptyCartScreen()));
                        },
                        child: Card(
                          child: Column(children: <Widget>[
                            Container(
                              height: (MediaQuery.of(context).size.width *
                                      Fonts.dashboardItem_heightFactor) -
                                  30,
                              child: Image.asset('images/review.png'),
                            ),
                            Flexible(
                              child: Text(
                                'Check Reviews',
                                style: TextStyle(
                                  color: colors.labelColor,
                                  fontSize: Fonts.label_size,
                                  fontFamily: Fonts.default_font,
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width *
                          Fonts.dashboardItem_widthFactor,
                      height: MediaQuery.of(context).size.width *
                          Fonts.dashboardItem_heightFactor,
                      child: InkWell(
                        child: Card(
                          child: Column(children: <Widget>[
                            Container(
                              height: (MediaQuery.of(context).size.width *
                                      Fonts.dashboardItem_heightFactor) -
                                  30,
                              child: Image.asset('images/complaints.png'),
                            ),
                            Text(
                              'Complaints/Suggestions',
                              style: TextStyle(
                                color: colors.labelColor,
                                fontSize: Fonts.label_size - 2,
                                fontFamily: Fonts.default_font,
                              ),
                            ),
                          ]),
                        ),
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (BuildContext context) =>
                          //             new AddVoucherScreen()));
                        },
                      ),
                    ),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width *
                          Fonts.dashboardItem_widthFactor,
                      height: MediaQuery.of(context).size.width *
                          Fonts.dashboardItem_heightFactor,
                      child: InkWell(
                        onTap: () {
                          //TODO: Check Review click
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new ViewVouchers()));
                        },
                        child: Card(
                          child: Column(children: <Widget>[
                            Container(
                              height: (MediaQuery.of(context).size.width *
                                      Fonts.dashboardItem_heightFactor) -
                                  30,
                              width: (MediaQuery.of(context).size.width *
                                      Fonts.dashboardItem_heightFactor) -
                                  48,
                              child: Image.asset('images/manage_voucher.png'),
                            ),
                            Flexible(
                              child: Text(
                                'Manage Vouchers',
                                style: TextStyle(
                                  color: colors.labelColor,
                                  fontSize: Fonts.label_size,
                                  fontFamily: Fonts.default_font,
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width *
                          Fonts.dashboardItem_widthFactor,
                      height: MediaQuery.of(context).size.width *
                          Fonts.dashboardItem_heightFactor,
                      // child: InkWell(
                      //   child: Card(
                      //     child: Column(children: <Widget>[
                      //       Container(
                      //         height: (MediaQuery.of(context).size.width *
                      //                 Fonts.dashboardItem_heightFactor) -
                      //             30,
                      //         child: Image.asset('images/complaints.png'),
                      //       ),
                      //       Text(
                      //         'Complaint/Suggestion',
                      //         style: TextStyle(
                      //           color: colors.labelColor,
                      //           fontSize: Fonts.label_size - 2,
                      //           fontFamily: Fonts.default_font,
                      //         ),
                      //       ),
                      //     ]),
                      //   ),
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (BuildContext context) =>
                      //                 new AddVoucherScreen()));
                      //   },
                      // ),
                    ),
                  ]),
              SizedBox(
                height: 10.0,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                width: MediaQuery.of(context).size.width - 10,
                child: FlatButton(
                  child: Text(
                    'Log Out',
                    style: TextStyle(
                      fontFamily: Fonts.default_font,
                      fontSize: Fonts.label_size,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    showDialogBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDialogBox() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text(
          'Do you want to Logout?',
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
                //TODO: Delete Employee
                Navigator.pop(_buildContext);
                await _loginDBController.signOut();
                Navigator.pop(context);
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
  }
}
