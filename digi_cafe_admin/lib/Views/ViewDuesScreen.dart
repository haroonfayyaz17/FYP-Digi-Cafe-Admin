import 'package:digi_cafe_admin/Controllers/UIControllers/OrderUIController.dart';
import 'package:digi_cafe_admin/Model/Order.dart';
import 'package:digi_cafe_admin/Views/LoadingWidget.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MyWidgets.dart';

class ViewDues extends StatefulWidget {
  const ViewDues({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ViewDues();
}

class _ViewDues extends State<ViewDues> {
  OrderUIController orderUIController;

  @override
  void initState() {
    // TODO: implement initState

    orderUIController = new OrderUIController();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: MyWidgets.getAppBar(text: 'View Dues'),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder(
                future: getOrderListOfThisUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingWidget();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return SingleChildScrollView(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            Order order = snapshot.data.elementAt(index);

                            return Card(
                              elevation: 2,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.95,
                                height: MediaQuery.of(context).size.width * 0.3,
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Order #' + order.orderNo,
                                          style: TextStyle(
                                            fontFamily: Fonts.default_font,
                                            fontSize: Fonts.heading3_size,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          order.orderTime.toString(),
                                          style: TextStyle(
                                            fontFamily: Fonts.default_font,
                                            fontSize: Fonts.label_size,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'PKR ' + order.totalAmount.toString(),
                                          style: TextStyle(
                                            fontFamily: Fonts.default_font,
                                            fontSize: Fonts.label_size,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }

  Future<List<Order>> getOrderListOfThisUser() async {
    // return await orderUIController.getOrdersList();
  }
}
