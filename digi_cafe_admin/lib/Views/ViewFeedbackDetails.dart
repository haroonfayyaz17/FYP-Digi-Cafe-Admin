import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/FoodMenuUIController.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/Views/AppBarWidget.dart';
import 'package:digi_cafe_admin/style/Icons/customIcons.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewFeedbackDetails extends StatefulWidget {
  String type;
  String complaintID;
  ViewFeedbackDetails(this.type, this.complaintID);
  @override
  State<StatefulWidget> createState() => _ViewFeedbackDetailsState();
}

class _ViewFeedbackDetailsState extends State<ViewFeedbackDetails> {
  String _categoryName = '';

  FoodMenuUIController _foodMenuUIController;

  @override
  void initState() {
    super.initState();
    _foodMenuUIController = new FoodMenuUIController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.getAppBar(),
      backgroundColor: colors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(),
      ),
    );
  }
}
