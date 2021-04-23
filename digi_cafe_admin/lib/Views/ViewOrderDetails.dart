import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/OrderUIController.dart';
import 'package:digi_cafe_admin/Views/LoadingWidget.dart';
import 'MyWidgets.dart';
import 'package:digi_cafe_admin/Model/Order.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/Views/MyWidgets.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';

class ViewOrderDetails extends StatefulWidget {
  String orderNo;
  ViewOrderDetails(this.orderNo);
  @override
  State<StatefulWidget> createState() => _ViewOrderDetailsState();
}

class _ViewOrderDetailsState extends State<ViewOrderDetails> {
  var replyController = new TextEditingController();

  var _buttonPressed = false;
  OrderUIController _orderUIController;

  @override
  void initState() {
    super.initState();
    _orderUIController = new OrderUIController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidgets.getAppBar(),
      backgroundColor: colors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<Order>(
              future: _orderUIController.fetchOrderData(widget.orderNo),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return LoadingWidget();
                } else {
                  Order order = snapshot.data;
                  return ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * 0.7),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(60.0),
                              child: Text(
                                'Order Details',
                                style: TextStyle(
                                  fontFamily: Fonts.default_font,
                                  fontSize: Fonts.heading1_size,
                                ),
                              ),
                            ),
                            Text(
                              'Order # ' + widget.orderNo.toString(),
                              style: TextStyle(
                                  fontFamily: Fonts.default_font,
                                  fontSize: Fonts.label_size,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Date: ' +
                                  order.orderTime.day.toString() +
                                  '/' +
                                  order.orderTime.month.toString() +
                                  '/' +
                                  order.orderTime.year.toString(),
                              style: TextStyle(
                                  fontFamily: Fonts.default_font,
                                  fontSize: Fonts.label_size,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Time: ' +
                                  order.orderTime.hour.toString() +
                                  ':' +
                                  order.orderTime.minute.toString(),
                              style: TextStyle(
                                  fontFamily: Fonts.default_font,
                                  fontSize: Fonts.label_size,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: order.orderItems.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var item = order.orderItems.elementAt(index);
                                  return Wrap(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              child: Text(
                                                item.foodItem.name,
                                                style: TextStyle(
                                                  fontFamily:
                                                      Fonts.default_font,
                                                  fontSize: Fonts
                                                      .dishDescription_font,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                            child: Text(
                                              'x' + item.quantity.toString(),
                                              style: TextStyle(
                                                fontFamily: Fonts.default_font,
                                                fontSize: Fonts.label_size,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.25,
                                              child: Text(
                                                'Rs ' +
                                                    (item.foodItem.price *
                                                            item.quantity)
                                                        .toString(),
                                                style: TextStyle(
                                                  fontFamily:
                                                      Fonts.default_font,
                                                  fontSize: Fonts.label_size,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 20, right: 20, top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total',
                                    style: TextStyle(
                                      fontFamily: Fonts.default_font,
                                      fontSize: Fonts.label_size,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Rs ' + order.totalAmount.toString(),
                                    style: TextStyle(
                                      fontFamily: Fonts.default_font,
                                      fontSize: Fonts.label_size,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                }
              }),
        ),
      ),
    );
  }
}
