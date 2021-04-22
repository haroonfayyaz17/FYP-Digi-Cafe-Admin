import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/OrderUIController.dart';
import 'package:digi_cafe_admin/Model/Complaint.dart';
import 'package:digi_cafe_admin/Model/Suggestion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:intl/intl.dart';
import 'LoadingWidget.dart';
import 'ViewFeedbackDetails.dart';

class SuggestionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SuggestionScreen();
}

class _SuggestionScreen extends State<SuggestionScreen> {
  String chosenComplaint = 'All';
  OrderUIController orderUIController;

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  final ValueNotifier<Stream<QuerySnapshot>> _counter =
      ValueNotifier<Stream<QuerySnapshot>>(null);
  Stream<QuerySnapshot> querySnapshot;

  @override
  void initState() {
    super.initState();
    orderUIController = new OrderUIController();
    _counter.value = orderUIController.getSuggestionSnapshot();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return SingleChildScrollView(
      child: Column(
        children: [
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

                            Suggestion complaint = new Suggestion(
                              complaintDoc.documentID.toString(),
                              complaintDoc.data[
                                  "suggestion"], //backend se ara snapshot main
                              complaintDoc.data["status"],
                              complaintDoc.data["date"].toDate(),
                            );
                            // String convertTime =
                            //     complaint.time.DateTime.now();
                            // if (complaint.time != null) {
                            //   String day = complaint.time.day.toString();
                            //   String month = complaint.time.month.toString();
                            //   String year = complaint.time.year.toString();
                            //   String date = '${day}-${month}-${year}';
                            //   String time = date;
                            // }
                            return Container(
                              margin: EdgeInsets.only(left: 10, top: 10),
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.width * 0.22,
                              child: InkWell(
                                onDoubleTap: () {
                                  complaint.status == 'read'
                                      ? orderUIController
                                          .changeSuggestionStatus(
                                              complaint.id, 'unread')
                                      : orderUIController
                                          .changeSuggestionStatus(
                                              complaint.id, 'read');
                                },
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ViewFeedbackDetails(
                                                  'suggestion', complaint.id)));
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
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                convertDateTimeDisplay(
                                                    complaint.time.toString()),
                                                style: TextStyle(
                                                  fontSize: Fonts.label_size,
                                                  fontFamily:
                                                      Fonts.default_font,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              complaint.text,
                                              style: TextStyle(
                                                fontSize: Fonts.heading2_size,
                                                fontFamily: Fonts.default_font,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
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

  void getQuerySnapshot() async {
    _counter.value = orderUIController.getSuggestionSnapshot();
  }
}
