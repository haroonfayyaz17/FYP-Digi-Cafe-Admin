import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_cafe_admin/Controllers/DBControllers/EmployeeDBController.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/EmployeeUIController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'LoadingWidget.dart';
import 'MyWidgets.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: _SettingScreen(),
    );
  }
}

class _SettingScreen extends StatefulWidget {
  _SettingScreen();

  @override
  State<StatefulWidget> createState() => __SettingScreen();
}

class __SettingScreen extends State<_SettingScreen> {
  BuildContext _buildContext;
  var openingTime = '';
  var closingTime = '';
  var callsCount = 0;
  String selectionAllowed = 'Less Than 5';
  List<String> selectionList;
  CreateFormFieldDropDown selection;
  EmployeeUIController _controller;
  var edtControllerVotes;

  var _displayLoadingWidget = true;

  TimeOfDay opening = null;
  @override
  void initState() {
    super.initState();
    opening = MyWidgets.stringToTimeOfDay('9:00 AM');
    print(opening);
    _controller = new EmployeeUIController();
    edtControllerVotes = new TextEditingController();
    selectionList = [
      'Less Than 5',
      '5-10',
      '11-15',
      '16-20',
      'Greater Than 20'
    ];
    selection = new CreateFormFieldDropDown(
        dropDownList: selectionList,
        chosenType: selectionAllowed,
        title: 'Selection Allowed',
        type: 'Complaint',
        icon: Icons.select_all_outlined);
  }

  Future<void> loadSettingsData(BuildContext context) async {
    DocumentSnapshot snapshot = await _controller.getSettings();
    // print(snapshot.exists);
    if (snapshot.exists) {
      setState(() {
        opening = MyWidgets.stringToTimeOfDay(snapshot['openingTime']);
        openingTime = opening.format(context);
        closingTime = snapshot['closingTime'];
        var type = snapshot['selectionCount'];

        if (type == '0-5')
          selection.chosenType = 'Less Than 5';
        else if (type == '>20')
          selection.chosenType = 'Greater Than 20';
        else {
          selection.chosenType = type;
        }
        edtControllerVotes.text = snapshot['minVotes'];
        _displayLoadingWidget = false;
      });
    } else {
      setState(() {
        opening = MyWidgets.stringToTimeOfDay('9:00 AM');
        openingTime = '9:00 AM';
        closingTime = '9:00 PM';
        selection.chosenType = 'Less Than 5';
        edtControllerVotes.text = 5;
        _controller.saveSettings(
            count: '0-5',
            votes: edtControllerVotes.text,
            openingTime: openingTime,
            closingTime: closingTime);
        _displayLoadingWidget = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    if (callsCount == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await loadSettingsData(_buildContext);
        callsCount++;
      });
    }
    // TODO: implement build
    return Scaffold(
      appBar: MyWidgets.getAppBar(text: 'Settings'),
      backgroundColor: colors.backgroundColor,
      body: Stack(
        children: [
          _displayLoadingWidget
              ? LoadingWidget()
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyWidgets.getSettingsHeading(
                            title: 'Voting', top: 50.0),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0, right: 40),
                          child: selection,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20, right: 40),
                          child: TextFormField(
                            autofocus: true,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            controller: edtControllerVotes,
                            textCapitalization: TextCapitalization.words,
                            decoration: MyWidgets.getTextFormDecoration(
                                title: 'Minimum Votes Per Food Item',
                                hint: 'Votes/Item',
                                icon: Icons.confirmation_number),
                          ),
                        ),
                        MyWidgets.getSettingsHeading(
                            title: 'Cafe Timing', top: 50.0),
                        MyWidgets.getSettingsRow(
                            title: 'Opening Time',
                            iconData: FaIcon(
                              FontAwesomeIcons.clock,
                              color: colors.buttonColor,
                            ),
                            subTitle: '$openingTime',
                            onTap: () {
                              DateTime now = DateTime.now();
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: now.hour, minute: now.minute),
                              ).then((value) {
                                if (value != null)
                                  setState(() {
                                    opening = value;
                                    openingTime = value.format(context);
                                  });
                              });
                            }),
                        MyWidgets.getSettingsRow(
                            title: 'Closing Time',
                            subTitle: '$closingTime',
                            iconData: FaIcon(
                              FontAwesomeIcons.solidClock,
                              color: colors.buttonColor,
                            ),
                            onTap: () {
                              DateTime now = DateTime.now();
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: now.hour, minute: now.minute),
                              ).then((value) {
                                if (value != null) {
                                  int result =
                                      MyWidgets.compareTime(value, opening);
                                  if (result >= 0) {
                                    print('yes');
                                    setState(() {
                                      closingTime = value.format(context);
                                    });
                                  } else {
                                    MyWidgets.showToast(_buildContext,
                                        'Closing Time must be greater than Opening Time');
                                  }
                                }
                              });
                            }),
                        SizedBox(height: 50),
                        Align(
                            alignment: Alignment.center,
                            child: MyWidgets.getButton(
                                text: 'Save',
                                onTap: () {
                                  if (edtControllerVotes.text == null) {
                                    MyWidgets.showToast(_buildContext,
                                        'Enter Minimum Votes Per Food Item');
                                    return;
                                  }
                                  if (openingTime == '') {
                                    MyWidgets.showToast(
                                        _buildContext, 'Select Opening Time');
                                    return;
                                  }
                                  if (closingTime == '') {
                                    MyWidgets.showToast(
                                        _buildContext, 'Select Closing Time');
                                    return;
                                  }
                                  String count = '';
                                  if (selection.chosenType == 'Less Than 5')
                                    count = '0-5';
                                  else if (selection.chosenType ==
                                      'Greater Than 20')
                                    count = '>20';
                                  else {
                                    count = selection.chosenType;
                                  }
                                  setState(() {
                                    _displayLoadingWidget = true;
                                  });

                                  _controller
                                      .saveSettings(
                                          count: count,
                                          votes: edtControllerVotes.text,
                                          openingTime: openingTime,
                                          closingTime: closingTime)
                                      .then((value) {
                                    setState(() {
                                      _displayLoadingWidget = false;
                                    });
                                    if (value)
                                      MyWidgets.showToast(_buildContext,
                                          'Setting Updated Successfully');
                                    else
                                      MyWidgets.showToast(_buildContext,
                                          'An unexpected error has occurred. Try Again Later');
                                  });
                                })),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
