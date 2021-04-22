import 'package:digi_cafe_admin/Controllers/UIControllers/OrderUIController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/FoodMenuUIController.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/Views/AppBarWidget.dart';
import 'package:digi_cafe_admin/style/Icons/customIcons.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'FeedbackDetailsClass.dart';

class ViewFeedbackDetails extends StatefulWidget {
  String type;
  String complaintID;
  ViewFeedbackDetails(this.type, this.complaintID);
  @override
  State<StatefulWidget> createState() => _ViewFeedbackDetailsState();
}

class _ViewFeedbackDetailsState extends State<ViewFeedbackDetails> {
  OrderUIController _orderUIController;
  FeedbackDetails _feedbackDetails;

  var replyController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _orderUIController = new OrderUIController();
    _feedbackDetails = new FeedbackDetails();
    _orderUIController
        .getFeedbackData(widget.complaintID, widget.type)
        .then((value) {
      _feedbackDetails = value;
    });
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await _orderUIController
      //     .getFeedbackData(widget.complaintID, widget.type)
      //     .then((value) {
      //   setState(() {
      //     _feedbackDetails = value;
      //   });
      // });
    });
    return Scaffold(
      appBar: AppBarWidget.getAppBar(),
      backgroundColor: colors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
            child: FutureBuilder<FeedbackDetails>(
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else {
              FeedbackDetails details = snapshot.data;
              debugPrint(details.orderNo);
              return ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //name
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Text(
                            'Name: ${details.name}',
                            style: TextStyle(
                              fontSize: Fonts.heading2_size,
                              fontFamily: Fonts.default_font,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        //email
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            'Email: ${details.email}',
                            style: TextStyle(
                              fontSize: Fonts.heading2_size,
                              fontFamily: Fonts.default_font,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        //category
                        widget.type == 'complaint'
                            ? Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Text(
                                  'Category: ${details.category}',
                                  style: TextStyle(
                                    fontSize: Fonts.heading2_size,
                                    fontFamily: Fonts.default_font,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            : Container(),
                        //order

                        details.orderNo != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Order: ',
                                      style: TextStyle(
                                        fontSize: Fonts.heading2_size,
                                        fontFamily: Fonts.default_font,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        print('yes');
                                      },
                                      child: Text(
                                        '${details.orderNo}',
                                        style: TextStyle(
                                            fontSize: Fonts.link_size,
                                            fontFamily: Fonts.default_font,
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.blue),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        //feedback
                        Padding(
                          padding: const EdgeInsets.only(top: 14.0),
                          child: Text(
                            widget.type == 'complaint'
                                ? 'Customer Complaint'
                                : 'Customer Suggestion',
                            style: TextStyle(
                              fontSize: Fonts.heading3_size,
                              fontFamily: Fonts.default_font,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.all(10),
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: colors.buttonColor,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Text(
                            '${details.text}',
                            style: TextStyle(
                              fontSize: Fonts.heading2_size,
                              fontFamily: Fonts.default_font,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextField(
                              controller: this.replyController,
                              maxLines: 6,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                labelText: 'Write Reply',
                                hintText: 'Your text here',
                                border: OutlineInputBorder(),
                              ),
                              style: TextStyle(
                                fontSize: Fonts.heading2_size,
                                fontFamily: Fonts.default_font,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
          future: _orderUIController.getFeedbackData(
              widget.complaintID, widget.type),
        )

            //name

            //email
            //date
            //feedback text
            //reply textbox
            ),
      ),
    );
  }
}
