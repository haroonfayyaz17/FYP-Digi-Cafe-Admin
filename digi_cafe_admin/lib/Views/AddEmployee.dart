import 'dart:io';
import 'package:digi_cafe_admin/Model/Cafe%20Employee.dart';
import 'package:digi_cafe_admin/Views/AppBarWidget.dart';
import 'package:digi_cafe_admin/Views/LoadingWidget.dart';
import 'package:digi_cafe_admin/Views/login.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/EmployeeUIController.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/Icons/customIcons.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:digi_cafe_admin/Views/VIewEmployees.dart';
import '../style/colors.dart';

class AddEmployeeScreen extends StatelessWidget {
  AddEmployeeScreen({this.employee, this.actionType});

  CafeEmployee employee;
  String actionType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.getAppBar(),
      // backgroundColor: colors.buttonColor,
      backgroundColor: colors.backgroundColor,
      body: _AddEmployeeScreen(
        employee: employee,
        actionType: actionType,
      ),
    );
  }
}

_AddEmployeeScreen3State _addEmployeeScreen;

class _AddEmployeeScreen extends StatefulWidget {
  _AddEmployeeScreen({this.employee, this.actionType});
  CafeEmployee employee;
  String actionType;
  @override
  _AddEmployeeScreen3State createState() {
    _addEmployeeScreen =
        _AddEmployeeScreen3State(employee: employee, actionType: actionType);
    return _addEmployeeScreen;
  }
}

class _AddEmployeeScreen3State extends State<_AddEmployeeScreen> {
  var screenHeader;

  _AddEmployeeScreen3State({this.employee, this.actionType});
  CafeEmployee employee;
  String actionType;
  bool _buttonPressed = false;
  File _image;
  var edtPhoneController = new TextEditingController();
  var _displayLoadingWidget = false;

  TextEditingController _dateControllerText = new TextEditingController();
  PageController controller = PageController();
  String date;
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  List<String> genderOptionList;
  List<String> staffType;
  int count = 0;
  var _phoneNo = '';
  var _email = '';
  var _password = '';

  String chosenGender;
  String choosenstaffType;
  String chosenDegree;
  int currentIndex = 0;

  EmployeeUIController _employeeUIController = new EmployeeUIController();

  String code = '+92';

  var edtControllerName = new TextEditingController();

  String _name;

  String _nextLabel = 'Next>';

  String _confirmPassword;

  void setFieldsForUpdate() {
    setState(() {
      _dateControllerText.text = employee.Dob;
      edtControllerName.text = employee.Name;
      chosenGender = employee.Gender;
      choosenstaffType = employee.userType;
    });
    // debugPrint(__contactDetailsState.mounted.toString());
  }

  void setPhoneNo() {
    setState(() {
      if (employee != null) {
        edtPhoneController.text = employee.PhoneNo;
        _phoneNo = employee.PhoneNo;
        _phoneNo = employee.PhoneNo;
      }
    });

    count++;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (actionType == 'update') {
        setFieldsForUpdate();
        setPhoneNo();
      }
    });

    _fillGendersDropDown();
    _fillPersonTypesDropDown();
  }

  // void _emailValue() {
  //   _email = edtControllerEmail.text;
  // }

  // void _passwordValue() {
  //   _password = edtControllerPassword.text;
  // }

  void _fillGendersDropDown() {
    genderOptionList = <String>['Male', 'Female', 'Other'];
  }

  void _fillPersonTypesDropDown() {
    staffType = <String>['Kitchen', 'Serving'];
  }

  onChangedFunction(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (actionType == 'update' && count < 1) {
      setFieldsForUpdate();
      setState(() {
        screenHeader = 'Update Employee';
      });
    } else {
      screenHeader = 'Add Employee';
    }

    Widget widget = Stack(children: [
      _displayLoadingWidget
          ? LoadingWidget()
          : Column(
              children: [
                Expanded(
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: onChangedFunction,
                    controller: controller,
                    children: [
                      SingleChildScrollView(
                        // physics: NeverScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    '${screenHeader}',
                                    style: TextStyle(
                                      fontSize: Fonts.heading1_size,
                                      fontFamily: Fonts.default_font,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                  child: Container(
                                    height: 150,
                                    width: MediaQuery.of(context).size.width *
                                        0.73,
                                    child: Image.asset(
                                      'images/innerImages/cook_img.jpg',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'Personal Information',
                                      style: TextStyle(
                                        fontSize: Fonts.heading_SampleText_size,
                                        fontFamily: Fonts.default_font,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                                  child: TextFormField(
                                    autofocus: true,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) =>
                                        FocusScope.of(context).nextFocus(),
                                    onChanged: (text) {
                                      _name = text;
                                    },
                                    controller: edtControllerName,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: colors.buttonColor,
                                            width: 1.3),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: colors.buttonColor,
                                            width: 1.3),
                                      ),
                                      hintText: 'Full Name',
                                      filled: true,
                                      fillColor: colors.backgroundColor,
                                      labelText: 'Full Name',
                                      icon: Icon(
                                        Icons.person_add,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                                  child: TextFormField(
                                    controller: _dateControllerText,
                                    readOnly: true,
                                    autofocus: true,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) =>
                                        FocusScope.of(context).nextFocus(),
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: colors.buttonColor,
                                            width: 1.3),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: colors.buttonColor,
                                            width: 1.3),
                                      ),
                                      hintText: 'Date Of Birth',
                                      filled: true,
                                      fillColor: colors.backgroundColor,
                                      labelText: 'Date Of Birth',
                                      icon: Icon(
                                        Icons.calendar_today,
                                      ),
                                    ),
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      ).then((value) {
                                        String day = value.day.toString();
                                        String month = value.month.toString();
                                        String year = value.year.toString();
                                        String date = '${day}-${month}-${year}';
                                        _dateControllerText.text = date;

                                        setState(() {
                                          _dateControllerText.text = date;
                                        });
                                      });
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                                  child: DropdownButtonFormField<String>(
                                    value: chosenGender,
                                    autofocus: true,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: colors.buttonColor,
                                            width: 1.3),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: colors.buttonColor,
                                            width: 1.3),
                                      ),
                                      hintText: 'Gender',
                                      filled: true,
                                      fillColor: colors.backgroundColor,
                                      labelText: 'Gender',
                                      icon: Icon(
                                        Icons.person_outline,
                                      ),
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        chosenGender = newValue;
                                      });
                                    },
                                    items: genderOptionList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                                  child: DropdownButtonFormField<String>(
                                    value: choosenstaffType,
                                    autofocus: true,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: colors.buttonColor,
                                            width: 1.3),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: colors.buttonColor,
                                            width: 1.3),
                                      ),
                                      hintText: 'Staff Type',
                                      filled: true,
                                      fillColor: colors.backgroundColor,
                                      labelText: 'Staff Type',
                                      icon: Icon(
                                        Icons.person,
                                      ),
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        choosenstaffType = newValue;
                                      });
                                    },
                                    items: staffType
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ContactDetailsWidget(),
                      if (actionType != 'update') ImageWidget(),
                      if (actionType != 'update') EmailDetails(),

                      // Container(
                      //   child: Center(
                      //     child: Column(
                      //       mainAxisSize: MainAxisSize.min,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Text(
                      //           'Just Finishing Up!',
                      //           style: TextStyle(
                      //             fontSize: Fonts.heading_SampleText_size,
                      //             fontFamily: Fonts.default_font,
                      //           ),
                      //         ),
                      //         SizedBox(
                      //           height: 50,
                      //         ),
                      //         Text(
                      //           'We have emailed you a link.\nClick on that link to verify your account',
                      //           style: TextStyle(
                      //             color: colors.buttonColor,
                      //             fontSize: Fonts.heading2_size,
                      //             fontFamily: Fonts.default_font,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Indicator(
                        positionIndex: 0,
                        currentIndex: currentIndex,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Indicator(
                        positionIndex: 1,
                        currentIndex: currentIndex,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      if (actionType != 'update')
                        Indicator(
                          positionIndex: 2,
                          currentIndex: currentIndex,
                        ),
                      SizedBox(
                        width: 10,
                      ),
                      if (actionType != 'update')
                        Indicator(
                          positionIndex: 3,
                          currentIndex: currentIndex,
                        )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () => previousFunction(),
                          child: Text(
                            '<Previous',
                            style: TextStyle(
                              fontSize: Fonts.heading2_size,
                              color: colors.buttonColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        InkWell(
                          onTap: () {
                            nextFunction();
                            // print(code + ' ' + edtControllerPhoneNo.text);
                          },
                          child: Text(
                            '$_nextLabel',
                            style: TextStyle(
                              fontSize: Fonts.heading2_size,
                              color: colors.buttonColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
    ]);
    // if (actionType == 'update') {
    //   setFieldsForUpdate();
    //   debugPrint('dfffd');
    // }
    return widget;
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //
  //   super.dispose();
  // }

  void _textEditingControllerListener() {
    _dateControllerText.text = date;
  }

  nextFunction() {
    double personal = 0, phoneNo = 1, email = 3, image = 2;
    if (count == 0) {
      setPhoneNo();
    }
    if (controller.page == personal) {
      if (edtControllerName.text == '') {
        _showToast(context, 'Enter full Name');
      } else if (_dateControllerText.text == '') {
        _showToast(context, 'Select Date Of Birth');
      } else if (chosenGender == null) {
        _showToast(context, 'Choose Gender');
      } else if (choosenstaffType == null) {
        _showToast(context, 'Choose Person Type');
      } else {
        if (actionType == 'update') {
          setState(() {
            _nextLabel = 'Update';
          });
        }
        controller.nextPage(duration: _kDuration, curve: _kCurve);
      }
    } else if (controller.page == phoneNo) {
      if (_phoneNo.toString().trim() == '') {
        _showToast(context, 'Enter Phone Number');
      } else {
        if (actionType == 'update') {
          updateEmployeeRecord();
        }
        controller.nextPage(duration: _kDuration, curve: _kCurve);
      }
    } else if (controller.page == email) {
      controller.nextPage(duration: _kDuration, curve: _kCurve);
      if (_email != '') {
        if (_password == '') {
          _showToast(context, 'Enter Password');
        } else if (_confirmPassword == '') {
          _showToast(context, 'Enter confirm password');
        } else {
          controller.nextPage(duration: _kDuration, curve: _kCurve);
          _functionSignUp();
        }
      } else {
        _functionSignUp();
      }
      // _functionSignUp();
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
    } else if (controller.page == image) {
      if (_image == null) {
        _showToast(context, 'Choose Profile Pic');
        return;
      } else {
        setState(() {
          _nextLabel = "Add";
        });
        controller.nextPage(duration: _kDuration, curve: _kCurve);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) => LoginScreen()));
      }
    } else {
      controller.nextPage(duration: _kDuration, curve: _kCurve);
    }
    // controller.nextPage(duration: _kDuration, curve: _kCurve);
  }

  previousFunction() {
    double personal = 0, phoneNo = 1, email = 3, image = 2;

    if (controller.page != phoneNo - 1 && actionType == 'update') {
      setState(() {
        _nextLabel = 'Next>';
      });
    }
    if (controller.page != email - 1) {
      setState(() {
        _nextLabel = 'Next>';
      });
    }
    if (controller.page == 0) {
      Navigator.pop(context);
    } else {
      controller.previousPage(duration: _kDuration, curve: _kCurve);
    }
  }

  Future<void> _functionSignUp() async {
    try {
      //   // Navigator.push(
      //   //   context,
      //   //   MaterialPageRoute(builder: (context) => DentistSetupProfile('_email')),
      //   // );
      setState(() {
        _displayLoadingWidget = true;
      });
      _email = _email.replaceAll(new RegExp(r"\s+"), "");
      _password = _password.trim();
      _emailDetailsState._validateInputs();
      if (_emailDetailsState._autoValidate == false) {
        print(_email + _password + _phoneNo);
        bool result = await _employeeUIController.addEmployee(
            edtControllerName.text,
            _dateControllerText.text,
            chosenGender,
            choosenstaffType,
            '${code}' + '${_phoneNo}',
            _email,
            _password,
            _image.path);
        print(result);
        if (result.toString() == "true") {
          print('sucessful');
          Navigator.pop(context);
        }
      } else {
        print('unsuccessful');
      }
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _displayLoadingWidget = false;
    });
  }

  Future<void> updateEmployeeRecord() async {
    setState(() {
      _displayLoadingWidget = true;
    });
    employee.Dob = _dateControllerText.text;
    employee.Gender = chosenGender;
    employee.PhoneNo = _phoneNo;
    employee.Name = edtControllerName.text;
    employee.userType = choosenstaffType;
    await _employeeUIController.updateEmployeeData(employee);
    _showToast(context, "Data updated Successfully");
    setState(() {
      _displayLoadingWidget = false;
    });
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (BuildContext context) => ViewEmployees()));
    Navigator.pop(context);
  }

  void _showToast(BuildContext context, var _message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text('$_message'),
        // action: SnackBarAction(
        //     label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void _valueChanged(String value) {
    setState(() {
      _phoneNo = value;
    });
  }

  Widget ContactDetailsWidget() {
    String code = '+92';

    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Contact Details',
                  style: TextStyle(
                    fontSize: Fonts.heading_SampleText_size,
                    fontFamily: Fonts.default_font,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                autofocus: true,
                onChanged: _valueChanged,
                controller: edtPhoneController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: colors.buttonColor, width: 1.3),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: colors.buttonColor, width: 1.3),
                  ),
                  hintText: 'Contact Number',
                  filled: true,
                  fillColor: colors.backgroundColor,
                  labelText: 'Contact Number',
                  icon: CountryCodePicker(
                    onChanged: (value) {
                      code = value.dialCode;
                      _addEmployeeScreen.setState(() {
                        _addEmployeeScreen.code = code;
                      });
                    },
                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                    initialSelection: 'PK',
                    favorite: ['+92', 'PK'],
                    // optional. Shows only country name and flag
                    showCountryOnly: false,
                    // optional. Shows only country name and flag when popup is closed.
                    showOnlyCountryWhenClosed: false,
                    // optional. aligns the flag and the Text left
                    alignLeft: false,
                  ),
                ),
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(top: 20),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.all(Radius.circular(10)),
            //     color: colors.buttonColor,
            //   ),
            //   child: FlatButton(
            //     onPressed: () async {
            //       if (code == "") {
            //         _showToast(context, "Select Country code");
            //         return;
            //       }
            //       print(code + edtControllerPhoneNo.text);
            //       FirebaseAuth auth = FirebaseAuth.instance;
            //       await auth.verifyPhoneNumber(
            //         phoneNumber: code + edtControllerPhoneNo.text,
            //         timeout: Duration(seconds: 120),
            //         verificationCompleted: (message) {
            //           print(message.providerId);
            //         },
            //         verificationFailed: (e) {
            //           print(e.message);
            //         },
            //         // codeSent: (String verificationId,
            //         //     int resendToken) async {
            //         //   // Update the UI - wait for the user to enter the SMS code
            //         //   String smsCode = 'xxxx';

            //         //   PhoneAuthCredential phoneAuthCredential =
            //         //       PhoneAuthProvider.credential(
            //         //           verificationId: verificationId,
            //         //           smsCode: smsCode);

            //         //   // Sign the user in (or link) with the credential
            //         //   await auth
            //         //       .signInWithCredential(phoneAuthCredential);
            //         // },
            //         codeAutoRetrievalTimeout:
            //             (String verificationId) {},
            //       );
            //     },
            //     child: Text(
            //       'Verify Number',
            //       style: TextStyle(
            //         fontSize: 18,
            //         fontFamily: Fonts.default_font,
            //         color: colors.backgroundColor,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

_ImageWidgetState __imageWidgetState;

class ImageWidget extends StatefulWidget {
  @override
  _ImageWidgetState createState() {
    __imageWidgetState = new _ImageWidgetState();
    return __imageWidgetState;
  }
}

class _ImageWidgetState extends State<ImageWidget> {
  // Future<File> getImageFileFromAssets(String path) async {
  //   final byteData = await rootBundle.load('images/$path');

  //   final file = File('${(await getTemporaryDirectory()).path}/$path');
  //   await file.writeAsBytes(byteData.buffer
  //       .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  //   print('yes');
  //   return file;
  // }

  File _image;
  String _imagePath = null;
  var _msg = "Select Profile Pic";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // loadImage();
    // TODO: implement build
    return Container(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Upload Employee Profile Pic',
                      style: TextStyle(
                        fontSize: Fonts.heading_SampleText_size,
                        fontFamily: Fonts.default_font,
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 50,
                // ),
                SizedBox(
                  height: 50,
                ),

                _image != null
                    ? Image.asset(
                        _image.path,
                        width: 175,
                        height: 175,
                      )
                    : Container(),

                if (_image == null)
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: colors.buttonColor,
                        ),
                        width: 150,
                        height: 50,
                        child: Center(
                          child: Text(
                            'Choose Profile Pic',
                            style: TextStyle(
                              fontFamily: Fonts.default_font,
                              color: colors.buttonTextColor,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        _showPicker(context);
                      },
                    ),
                  ),

                SizedBox(
                  height: 50,
                ),
                _image != null
                    ? InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.red[400],
                          ),
                          width: 150,
                          height: 50,
                          child: Center(
                            child: Text(
                              'Remove',
                              style: TextStyle(
                                fontFamily: Fonts.default_font,
                                color: colors.buttonTextColor,
                              ),
                            ),
                          ),
                        ),
                        onTap: clearSelection,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: colors.buttonColor,
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library,
                          color: colors.buttonTextColor),
                      title: new Text(
                        'Photo Library',
                        style: TextStyle(
                          color: colors.buttonTextColor,
                          fontFamily: Fonts.default_font,
                          fontSize: Fonts.dialog_heading_size,
                        ),
                      ),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_camera,
                      color: colors.buttonTextColor,
                    ),
                    title: new Text(
                      'Camera',
                      style: TextStyle(
                        color: colors.buttonTextColor,
                        fontFamily: Fonts.default_font,
                        fontSize: Fonts.dialog_heading_size,
                      ),
                    ),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void clearSelection() {
    setState(() {
      _image = null;
    });
    _addEmployeeScreen.setState(() {
      _addEmployeeScreen._image = _image;
    });
  }

  Future _imgFromCamera() async {
    await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxHeight: 175,
      maxWidth: 175,
    ).then((image) {
      setState(() {
        _image = image;
      });
      _addEmployeeScreen.setState(() {
        _addEmployeeScreen._image = _image;
      });
    });
  }

  Future _imgFromGallery() async {
    await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 175,
      maxWidth: 175,
    ).then((image) {
      setState(() {
        _image = image;
      });
      _addEmployeeScreen.setState(() {
        _addEmployeeScreen._image = _image;
      });
    });
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((image) {
      setState(() {
        _image = image;
      });
      _addEmployeeScreen.setState(() {
        _addEmployeeScreen._image = _image;
      });
    });
  }
}

_EmailDetailsState _emailDetailsState;

class EmailDetails extends StatefulWidget {
  @override
  _EmailDetailsState createState() {
    _emailDetailsState = _EmailDetailsState();
    return _emailDetailsState;
  }
}

class _EmailDetailsState extends State<EmailDetails> {
  bool _autoValidate = false;
  bool _passwordHide = true;
  bool _confirmPasswordHide = true;

  Icon _passwordIcon = Icon(
    Icons.remove_red_eye,
    size: 22,
  );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Icon _confirmIcon = Icon(Icons.remove_red_eye, size: 22);
  var _email;
  var _confirmPassword;
  var _password;

  void _validateInputs() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
        _formKey.currentState.save();
        setState(() {
          _autoValidate = false;
        });
      } else {
//    If all data are not valid then start auto validation.
        setState(() {
          _autoValidate = true;
        });
      }
    }
  }

  String validateEmail(String value) {
    if (value != '') {
      Pattern pattern1 =
          r'(^[A-Za-z0-9._%+-]+@nu.edu.pk)|(^[A-Za-z0-9._%+-]+@cfd.nu.edu.pk)';

      RegExp regex1 = new RegExp(pattern1);
      if (!regex1.hasMatch(value.trim()))
        return 'Enter Valid Email';
      else {
        return null;
      }
    } else {
      return null;
    }
  }

  String validatePassword(String value) {
    if (value != '') {
      String pattern =
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
      RegExp regExp = new RegExp(pattern);
      if (regExp.hasMatch(value)) {
        return null;
      } else {
        return 'Password must contain Minimum 1 Upper case,\nMinimum 1 lowercase,\n Minimum 1 Numeric Number,\n Minimum 1 Special Character';
      }
    } else {
      return null;
    }
  }

  String validateconfirmPassword(String value) {
    if (_confirmPassword != '' && _password != '') {
      if (_confirmPassword != _password) {
        return 'Both Passwords doesn\'t match';
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return SingleChildScrollView(
      // physics: NeverScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Login Information(Optional)',
                      style: TextStyle(
                        fontSize: Fonts.heading_SampleText_size,
                        fontFamily: Fonts.default_font,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    validator: validateEmail,
                    onChanged: _emailValueChanged,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: colors.buttonColor, width: 1.3),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: colors.buttonColor, width: 1.3),
                      ),
                      hintText: 'Email Address',
                      filled: true,
                      fillColor: colors.backgroundColor,
                      labelText: 'Email Address',
                      icon: Icon(
                        Icons.email,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    obscureText: _passwordHide,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    validator: validatePassword,
                    onChanged: _passwordValueChanged,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: colors.buttonColor, width: 1.3),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: colors.buttonColor, width: 1.3),
                      ),
                      hintText: 'Password',
                      filled: true,
                      suffixIcon: InkWell(
                        child: _passwordIcon,
                        onTap: () {
                          setState(() {
                            _passwordHide = !_passwordHide;
                            if (_passwordHide) {
                              _passwordIcon = Icon(
                                Icons.remove_red_eye,
                                size: 22,
                              );
                            } else {
                              _passwordIcon = Icon(
                                PasswordCross.eye_slash,
                                size: 22,
                              );
                            }
                          });
                        },
                      ),
                      fillColor: colors.backgroundColor,
                      labelText: 'Password',
                      icon: Icon(Icons.vpn_key),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    obscureText: _confirmPasswordHide,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    validator: validateconfirmPassword,
                    onChanged: _confirmPasswordValueChanged,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: colors.buttonColor, width: 1.3),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: colors.buttonColor, width: 1.3),
                      ),
                      hintText: 'Confirm Password',
                      filled: true,
                      suffixIcon: InkWell(
                        child: _confirmIcon,
                        onTap: () {
                          setState(() {
                            _confirmPasswordHide = !_confirmPasswordHide;
                            if (_confirmPasswordHide) {
                              _confirmIcon = Icon(
                                Icons.remove_red_eye,
                                size: 22,
                              );
                            } else {
                              _confirmIcon = Icon(
                                PasswordCross.eye_slash,
                                size: 22,
                              );
                            }
                          });
                        },
                      ),
                      fillColor: colors.backgroundColor,
                      labelText: 'Confirm Password',
                      icon: Icon(Icons.vpn_key),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _emailValueChanged(String value) {
    setState(() {
      _email = value;
    });
    _addEmployeeScreen.setState(() {
      _addEmployeeScreen._email = _email;
    });
  }

  void _confirmPasswordValueChanged(String value) {
    setState(() {
      _password = value;
    });
    _addEmployeeScreen.setState(() {
      _addEmployeeScreen._password = _password;
    });
  }

  void _passwordValueChanged(String value) {
    setState(() {
      _confirmPassword = value;
    });
    _addEmployeeScreen.setState(() {
      _addEmployeeScreen._confirmPassword = _confirmPassword;
    });
  }
}

class Indicator extends StatelessWidget {
  final int positionIndex, currentIndex;
  const Indicator({this.currentIndex, this.positionIndex});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
          border: Border.all(color: colors.buttonColor),
          color: positionIndex == currentIndex
              ? colors.buttonColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(100)),
    );
  }
}
