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

  @override
  void initState() {
    super.initState();
    _orderUIController = new OrderUIController();
    _feedbackDetails = new FeedbackDetails();
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
      await _orderUIController
          .getFeedbackData(widget.complaintID, widget.type)
          .then((value) {
        setState(() {
          _feedbackDetails = value;
        });
      });
    });
    return Scaffold(
      appBar: AppBarWidget.getAppBar(),
      backgroundColor: colors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //name
              Text(
                'name',
                style: TextStyle(
                  fontSize: Fonts.label_size,
                  fontFamily: Fonts.default_font,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
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
