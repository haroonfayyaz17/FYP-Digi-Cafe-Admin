import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../style/fonts_style.dart';

class dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(
        primaryColor: colors.buttonColor,
        cursorColor: colors.cursorColor,
      ),
      home: Scaffold(
        body: _dashboard(),
      ),
    );
  }
}

class _dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => __dashboard();
}

class __dashboard extends State<_dashboard> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
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
                                  'admin@gmail.com',
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width *
                    Fonts.dashboardItem_widthFactor,
                height: MediaQuery.of(context).size.width *
                    Fonts.dashboardItem_heightFactor,
                child: InkWell(
                  onTap: () {
                    //TODO: Manage Employee click
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
                          'Manage Employee',
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width *
                    Fonts.dashboardItem_widthFactor,
                height: MediaQuery.of(context).size.width *
                    Fonts.dashboardItem_heightFactor,
                child: InkWell(
                  onTap: () {
                    //TODO: Nominate Items
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width *
                    Fonts.dashboardItem_widthFactor,
                height: MediaQuery.of(context).size.width *
                    Fonts.dashboardItem_heightFactor,
                child: InkWell(
                  onTap: () {
                    //TODO: Manage Employee click
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
                          'Check Review',
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
                        'Complaint/Suggestion',
                        style: TextStyle(
                          color: colors.labelColor,
                          fontSize: Fonts.label_size - 2,
                          fontFamily: Fonts.default_font,
                        ),
                      ),
                    ]),
                  ),
                ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
