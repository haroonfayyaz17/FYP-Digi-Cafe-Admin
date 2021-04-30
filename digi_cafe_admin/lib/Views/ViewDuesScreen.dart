import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/OrderUIController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'LoadingWidget.dart';
import 'MyWidgets.dart';
import 'package:digi_cafe_admin/Model/Faculty.dart';

class ViewDuesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ViewDuesScreen();
}

class _ViewDuesScreen extends State<ViewDuesScreen> {
  Stream<QuerySnapshot> querySnapshot;
  OrderUIController uiController;
  List<Faculty> cardsList = new List<Faculty>();
  @override
  void initState() {
    super.initState();
    uiController = new OrderUIController();

    querySnapshot = uiController.getDuesSnapshot();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: MyWidgets.getFilterAppBar(
          text: 'View Dues',
          child: Icons.notifications,
          onTap: () {
            MyWidgets.showConfirmationDialog(context,
                text: 'Do you want to notify all persons?', callback: () async {
              print(cardsList.length);
              for (int i = 0; i < cardsList.length; i++) {
                await uiController.sendNotifications(
                    'Pending Dues',
                    cardsList[i].Dob,
                    'Dear ${cardsList[i].Name}, you have Rs. ${cardsList[i].getDues()} pending dues. Kindly pay them as soon as possible.');
              }
            });
          }),
      backgroundColor: colors.backgroundColor,
      body: SingleChildScrollView(
        child: FutureBuilder<List<Faculty>>(
            future: uiController.getPersonData(),
            builder: (context, snap) {
              if (!snap.hasData) {
                return LoadingWidget();
              } else {
                return StreamBuilder<QuerySnapshot>(
                    stream: querySnapshot,
                    builder: (context, snapshot) {
                      cardsList = new List<Faculty>();
                      return !snapshot.hasData
                          ? LoadingWidget()
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (BuildContext context, int index) {
                                DocumentSnapshot duesDoc =
                                    snapshot.data.documents[index];
                                int ind =
                                    getListIndex(duesDoc.documentID, snap.data);
                                Faculty f;
                                if (ind != -1)
                                  f = new Faculty(
                                      snap.data[ind].Name,
                                      snap.data[ind].EmailAddres,
                                      duesDoc.documentID,
                                      snap.data[ind].Dob,
                                      '',
                                      duesDoc.data['dues'],
                                      '',
                                      '');
                                else
                                  f = new Faculty('', '', duesDoc.documentID,
                                      '', '', duesDoc.data['dues'], '', '');
                                if (f.getDues() != 0) cardsList.add(f);
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: 10, top: 10, right: 10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height:
                                      MediaQuery.of(context).size.width * 0.31,
                                  child: InkWell(
                                    onTap: () async {
                                      print(f.Name);
                                    },
                                    child: Card(
                                      elevation: 8,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            MyWidgets.getTextWidget(
                                                text: f.Name),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            MyWidgets.getTextWidget(
                                                text: f.EmailAddres,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            MyWidgets.getTextWidget(
                                                text: f.getDues().toString()),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                    });
              }
            }),
      ),
    );
  }

  int getListIndex(String docID, List<Faculty> list) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].Gender == docID) return i;
    }
    return -1;
  }
}
