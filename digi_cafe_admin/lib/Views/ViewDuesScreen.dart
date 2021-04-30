import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_cafe_admin/Controllers/UIControllers/OrderUIController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'LoadingWidget.dart';
import 'MyWidgets.dart';

class ViewDuesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ViewDuesScreen();
}

class _ViewDuesScreen extends State<ViewDuesScreen> {
  Stream<QuerySnapshot> querySnapshot;
  OrderUIController uiController;

  List<Dues> cardsList = new List<Dues>();

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
                    cardsList[i].getTokenId,
                    'Dear ${cardsList[i].getName}, you have Rs. ${cardsList[i].getDuesTotal.toInt().toString()} pending dues. Kindly pay them as soon as possible.');
              }
            });
          }),
      backgroundColor: colors.backgroundColor,
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: querySnapshot,
            builder: (context, snapshot) {
              cardsList = new List<Dues>();
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
                        Dues dues = new Dues(
                            docID: duesDoc.documentID,
                            duesTotal: duesDoc.data['dues'].toDouble());
                        // dues.setDocID = duesDoc.documentID;
                        // print(dues.docID);
                        return FutureBuilder<DocumentSnapshot>(
                            future: uiController.getPersonData(dues.docID),
                            builder: (context, snap) {
                              if (!snap.hasData) {
                                return Container();
                              } else {
                                if (snap.data.exists) {
                                  dues.setEmail = snap.data['email'];
                                  dues.setName = snap.data['Name'];
                                  dues.setTokenId = snap.data['tokenID'];
                                }
                                cardsList.add(dues);
                                return Container(
                                  margin: EdgeInsets.only(left: 10, top: 10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height:
                                      MediaQuery.of(context).size.width * 0.31,
                                  child: InkWell(
                                    onTap: () async {
                                      print(dues.getName);
                                      // MyWidgets.changeScreen(
                                      //     context: context,
                                      //     screen: ViewFeedbackDetails(
                                      //         'complaint', complaint.id));
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
                                                text: dues.getName),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            MyWidgets.getTextWidget(
                                                text: dues.getEmail,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            MyWidgets.getTextWidget(
                                                text: dues.getDuesTotal
                                                    .toInt()
                                                    .toString()),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            });
                      },
                    );
            }),
      ),
    );
  }
}

class Dues {
  double duesTotal;
  String tokenId;

  String docID;
  String email;
  String name;

  String get getTokenId => this.tokenId;

  set setTokenId(String tokenId) => this.tokenId = tokenId;
  String get getEmail => this.email;

  set setEmail(String email) => this.email = email;

  get getName => this.name;

  set setName(name) => this.name = name;
  double get getDuesTotal => this.duesTotal;

  set setDuesTotal(double duesTotal) => this.duesTotal = duesTotal;

  get getDocID => this.docID;

  set setDocID(docID) => this.docID = docID;

  Dues({this.duesTotal, this.docID});
}
