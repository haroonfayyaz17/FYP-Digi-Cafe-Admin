import 'package:digi_cafe_admin/Views/ComplaintSuggestionScreen.dart';
import 'package:digi_cafe_admin/Views/ViewEmployees.dart';
import 'package:digi_cafe_admin/Views/ViewFoodMenu.dart';
import 'package:digi_cafe_admin/Views/ViewSales.dart';
import 'package:digi_cafe_admin/Views/ViewVouchers.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:digi_cafe_admin/Controllers/DBControllers/LoginDBController.dart';
import 'package:flutter/cupertino.dart';
import 'ViewDuesScreen.dart';
import 'package:flutter/material.dart';
import 'MyWidgets.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/Views/NominateItemsScreen.dart';
import '../style/fonts_style.dart';

class Dashboard extends StatelessWidget {
  var email;
  Dashboard({this.email});
  @override
  Widget build(BuildContext context) {
    return _Dashboard(
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

class _Dashboard extends StatefulWidget {
  var email;
  _Dashboard({this.email});
  @override
  State<StatefulWidget> createState() => __Dashboard();
}

class __Dashboard extends State<_Dashboard> {
  BuildContext _buildContext;
  LoginDBController _loginDBController;
  @override
  void initState() {
    super.initState();
    _loginDBController = new LoginDBController();
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    // TODO: implement build
    return Scaffold(
      backgroundColor: colors.backgroundColor,
      appBar: MyWidgets.getAppBar(),
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
                    height: (MediaQuery.of(context).size.height *
                                Fonts.dashboardItem_heightFactor) *
                            0.5 -
                        60,
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
                        MyWidgets.getTextWidget(
                            text: 'Admin', size: Fonts.heading1_size),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 150,
                            maxWidth: MediaQuery.of(context).size.width * 0.6,
                          ),
                          child: MyWidgets.getTextWidget(
                              text: '${widget.email}',
                              size: Fonts.heading3_size - 1,
                              overflow: TextOverflow.visible),
                        ),
                      ]),
                ],
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MyWidgets.getDashboardItem(
                        childWidth: 30,
                        width: MediaQuery.of(context).size.width *
                            Fonts.dashboardItem_widthFactor,
                        height: MediaQuery.of(context).size.width *
                            Fonts.dashboardItem_heightFactor,
                        text: 'Manage Employees',
                        child: Image.asset('images/manage_employee.png'),
                        onTap: () => MyWidgets.changeScreen(
                            context: context, screen: new ViewEmployees())),
                    MyWidgets.getDashboardItem(
                        childWidth: 30,
                        width: MediaQuery.of(context).size.width *
                            Fonts.dashboardItem_widthFactor,
                        height: MediaQuery.of(context).size.width *
                            Fonts.dashboardItem_heightFactor,
                        text: 'Manage Menu',
                        child: Image.asset('images/manage_menu.png'),
                        onTap: () => MyWidgets.changeScreen(
                            context: context, screen: new ViewFoodMenu())),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MyWidgets.getDashboardItem(
                        childWidth: 30,
                        width: MediaQuery.of(context).size.width *
                            Fonts.dashboardItem_widthFactor,
                        height: MediaQuery.of(context).size.width *
                            Fonts.dashboardItem_heightFactor,
                        text: 'Nominate Items',
                        child: Image.asset('images/nominate.png'),
                        onTap: () => MyWidgets.changeScreen(
                            context: context,
                            screen: new NominateItemsScreen())),
                    MyWidgets.getDashboardItem(
                        width: MediaQuery.of(context).size.width *
                            Fonts.dashboardItem_widthFactor,
                        height: MediaQuery.of(context).size.width *
                            Fonts.dashboardItem_heightFactor,
                        text: 'View Sales',
                        child: Image.asset('images/sales.png'),
                        onTap: () => MyWidgets.changeScreen(
                            context: context, screen: new ViewSales())),
                  ]),
              Row(children: <Widget>[
                MyWidgets.getDashboardItem(
                    childWidth: 30,
                    width: MediaQuery.of(context).size.width *
                        Fonts.dashboardItem_widthFactor,
                    height: MediaQuery.of(context).size.width *
                        Fonts.dashboardItem_heightFactor,
                    text: 'Manage Vouchers',
                    child: Image.asset('images/manage_voucher.png'),
                    onTap: () => MyWidgets.changeScreen(
                        context: context, screen: new ViewVouchers())),
                MyWidgets.getDashboardItem(
                    childWidth: 30,
                    width: MediaQuery.of(context).size.width *
                        Fonts.dashboardItem_widthFactor,
                    height: MediaQuery.of(context).size.width *
                        Fonts.dashboardItem_heightFactor,
                    text: 'View Dues',
                    child: Image.asset('images/profile_pic.png'),
                    onTap: () => MyWidgets.changeScreen(
                        context: context, screen: new ViewDuesScreen())),
              ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MyWidgets.getDashboardItem(
                        width: MediaQuery.of(context).size.width *
                            Fonts.dashboardItem_widthFactor,
                        height: MediaQuery.of(context).size.width *
                            Fonts.dashboardItem_heightFactor,
                        text: 'Check Reviews',
                        child: Image.asset('images/review.png'),
                        onTap: () {}),
                    MyWidgets.getDashboardItem(
                        width: MediaQuery.of(context).size.width *
                            Fonts.dashboardItem_widthFactor,
                        height: MediaQuery.of(context).size.width *
                            Fonts.dashboardItem_heightFactor,
                        text: 'Complaints/Suggestions',
                        child: Image.asset('images/complaints.png'),
                        onTap: () => MyWidgets.changeScreen(
                            context: context,
                            screen: new ComplaintSuggestionScreen())),
                  ]),
              SizedBox(
                height: 10.0,
              ),
              MyWidgets.getButton(
                text: 'Log Out',
                color: Colors.red,
                radius: 10,
                width: MediaQuery.of(context).size.width - 10,
                onTap: () => showDialogBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDialogBox() async {
    MyWidgets.showConfirmationDialog(context, text: 'Do you want to Log Out?',
        callback: () async {
      Navigator.pop(_buildContext);
      await _loginDBController.signOut();
    });
  }
}
