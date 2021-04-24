import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/OrderUIController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:digi_cafe_admin/Model/Complaint.dart';
import 'LoadingWidget.dart';
import 'package:intl/intl.dart';
import 'MyWidgets.dart';
import 'ViewFeedbackDetails.dart';

class ComplaintScreen extends StatefulWidget {
  ComplaintScreen({this.fromDate, this.toDate});
  DateTime fromDate;
  DateTime toDate;
  _ComplaintScreen complaintState;

  @override
  State<StatefulWidget> createState() {
    complaintState = new _ComplaintScreen();
    return complaintState;
  }
}

class _ComplaintScreen extends State<ComplaintScreen> {
  String chosenComplaint = 'All';
  OrderUIController orderUIController;
  String time;
  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  final List<String> complaintCategories = [
    'All',
    "Food",
    "Serving",
    "Environment",
    "Utensils",
    "Management",
    "Others",
  ];

  final ValueNotifier<Stream<QuerySnapshot>> _counter =
      ValueNotifier<Stream<QuerySnapshot>>(null);
  Stream<QuerySnapshot> querySnapshot;

  @override
  void initState() {
    super.initState();
    orderUIController = new OrderUIController();
    _counter.value = orderUIController.getComplaintsSnapshot();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Container(
              height: 57,
              child: DropdownButtonFormField<String>(
                value: chosenComplaint,
                autofocus: true,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: colors.buttonColor, width: 1.3),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: colors.buttonColor, width: 1.3),
                  ),
                  hintText: 'Complaint Category',
                  filled: true,
                  fillColor: colors.backgroundColor,
                  labelText: 'Complaint Category',
                ),
                onChanged: (String newValue) {
                  setState(() {
                    chosenComplaint = newValue;
                  });
                  getQuerySnapshot(newValue);
                },
                items: complaintCategories
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          ValueListenableBuilder(
            builder: (BuildContext context, Stream<QuerySnapshot> querySnapshot,
                Widget child) {
              return StreamBuilder<QuerySnapshot>(
                stream: querySnapshot,
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? LoadingWidget()
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            DocumentSnapshot complaintDoc =
                                snapshot.data.documents[index];

                            Complaint complaint = new Complaint(
                                complaintDoc.documentID.toString(),
                                complaintDoc.data["feedback"],
                                complaintDoc.data["status"],
                                complaintDoc.data["date"].toDate(),
                                complaintDoc.data["category"]);
                            return Container(
                              margin: EdgeInsets.only(left: 10, top: 10),
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.width * 0.22,
                              child: InkWell(
                                onDoubleTap: () async {
                                  await changeStatus(
                                      complaint.id, complaint.status);
                                },
                                onTap: () async {
                                  complaint.status == 'unread'
                                      ? await orderUIController
                                          .changeComplaintStatus(
                                              complaint.id, 'read')
                                      : null;

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ViewFeedbackDetails(
                                                  'complaint', complaint.id)));
                                },
                                child: Card(
                                  elevation: 8,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            MyWidgets.getTextWidget(
                                                text: complaint.category,
                                                weight: FontWeight.bold,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: MyWidgets.getTextWidget(
                                                  text: convertDateTimeDisplay(
                                                      complaint.time
                                                          .toString()),
                                                  weight: FontWeight.bold,
                                                  size: Fonts.label_size,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: MyWidgets.getTextWidget(
                                                text: complaint.text,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                        Spacer(flex: 2),
                                      ],
                                    ),
                                  ),
                                  color: complaint.status == 'read'
                                      // ? Colors.yellow[100]
                                      ? Colors.orange[50]
                                      : colors.backgroundColor,
                                  //
                                ),
                              ),
                            );
                          },
                        );
                },
              );
            },
            valueListenable: _counter,
            child: const Text('Good job!'),
          )
        ],
      ),
    );
  }

  void getQuerySnapshot(String newValue) async {
    if (newValue == 'All')
      _counter.value = orderUIController.getComplaintsSnapshot(
          fromDate: widget.fromDate, toDate: widget.toDate);
    else
      _counter.value = orderUIController.getComplaintsSnapshot(
          newValue: newValue, fromDate: widget.fromDate, toDate: widget.toDate);
  }

  Future<void> changeStatus(String id, String status) async {
    status == 'read'
        ? await orderUIController.changeComplaintStatus(id, 'unread')
        : await orderUIController.changeComplaintStatus(id, 'read');
  }
}
