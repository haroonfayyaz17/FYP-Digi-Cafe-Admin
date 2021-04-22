import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_cafe_admin/Views/FeedbackDetailsClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:digi_cafe_admin/Model/Order.dart';
import 'package:intl/intl.dart';

class OrderDBController {
  var firestoreInstance;
  FirebaseUser user;
  var documentName = 'All';

  var collectionName = 'Orders';

  OrderDBController() {
    firestoreInstance = Firestore.instance;
  }

  Future<String> getOrderDocId(Order order) async {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(order.orderTime);
    DocumentSnapshot documentSnapshot =
        await firestoreInstance.collection('Orders').document().get();

    return documentSnapshot.documentID.toString();
  }

  Future<int> getOrderNo() async {
    QuerySnapshot querySnapshot = await firestoreInstance
        .collection('Orders')
        .orderBy("orderNo", descending: true)
        .limit(1)
        .getDocuments();

    for (DocumentSnapshot element in querySnapshot.documents) {
      return element.data['orderNo'];
    }

    return Future.value(0);
  }

  Future<bool> placeOrder(Order order) async {
    try {
      user = await FirebaseAuth.instance.currentUser();
      int orderNo;

      await getOrderNo().then((value) {
        orderNo = value + 1;
      });

      await getOrderDocId(order).then((value) async {
        await firestoreInstance.collection('Orders').document(value).setData({
          "orderNo": orderNo,
          "uid": user.uid,
          "dateTime": order.orderTime,
          "amount": order.totalAmount,
          "rating": 0,
          "review": null,
          "status": order.status,
        });

        var doc = await firestoreInstance
            .collection('Orders')
            .document(value)
            .collection("Items");

        var items = order.orderItems;

        for (int i = 0; i < items.length; i++) {
          doc.document(items.elementAt(i).foodItem.id).setData({
            "quantity": items.elementAt(i).quantity,
          });
        }
      });
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  Stream<QuerySnapshot> getOrdersSnapshot() {
    Stream<QuerySnapshot> querySnapshot = firestoreInstance
        .collection('Sales')
        .document('All Sale')
        .collection('Month')
        // .orderBy('dateTime', descending: true)
        // .where('category', isEqualTo: 'continental')
        .snapshots();
    //   .listen((snapshot) {
    //  double tempTotal = snapshot.documents.fold(0, (tot, doc) => tot + doc.data['amount']);

    return querySnapshot;
  }

  Future<Stream<QuerySnapshot>> getFilteredOrdersSnapshot(
      String filterType, DateTime fromDate, DateTime toDate) async {
    print(filterType +
        ' ' +
        fromDate.toLocal().toIso8601String() +
        ' ' +
        toDate.toLocal().toIso8601String());
    Stream<QuerySnapshot> querySnapshot = await firestoreInstance
        .collection('Sales')
        .document('All Sales')
        .collection(filterType)
        .where("date", isGreaterThanOrEqualTo: fromDate)
        .where("date", isLessThanOrEqualTo: toDate)
        // .orderBy('dateTime', descending: true)
        // .where('category', isEqualTo: 'continental')
        .snapshots();
    // print(querySnapshot.length);

    querySnapshot.listen((event) {
      print(event.documents.length);
    });
    return querySnapshot;
  }

  Stream<QuerySnapshot> getComplaintsSnapshot({String newValue = null}) {
    if (newValue == null)
      return firestoreInstance
          .collection('Complaints')
          .orderBy('category')
          .orderBy('date', descending: true)

          // .where('category', isEqualTo: 'Serving')
          .snapshots();
    else {
      return firestoreInstance
          .collection('Complaints')
          .where('category', isEqualTo: '$newValue')
          // .orderBy('category', descending: false)
          .orderBy('date', descending: true)
          .snapshots();
    }
  }

  Future<void> changeComplaintStatus(String id, String status) async {
    await firestoreInstance.collection('Complaints').document(id).updateData({
      "status": status,
    });
  }

  Stream<QuerySnapshot> getSuggestionSnapshot() {
    return firestoreInstance
        .collection('Suggestions')
        .orderBy('date', descending: true)

        // .where('category', isEqualTo: 'Serving')
        .snapshots();
  }

  Future<void> changeSuggestionStatus(String id, String status) async {
    await firestoreInstance.collection('Suggestions').document(id).updateData({
      "status": status,
    });
  }

  Future<FeedbackDetails> getFeedbackData(
      String complaintID, String type) async {
    FeedbackDetails feedbackDetails = new FeedbackDetails();
    DocumentSnapshot document;
    if (type == 'complaint')
      await firestoreInstance
          .collection('Complaints')
          .document(complaintID)
          .get()
          .then((value) => document = value);
    else {
      document = await firestoreInstance
          .collection('Suggestions')
          .document(complaintID)
          .get()
          .then((value) => document = value);
    }
    if (type == 'complaint') {
      feedbackDetails.text = document['feedback'];
      feedbackDetails.category = document['category'];
      feedbackDetails.orderNo = document['orderNo'];
    } else {
      feedbackDetails.text = document['suggestion'];
      feedbackDetails.orderNo = null;
    }
    feedbackDetails.dateTime = document['date'].toDate();
    feedbackDetails.id = document.documentID;
    feedbackDetails.reply = document['reply'];

    DocumentSnapshot document1;

    await firestoreInstance
        .collection('Person')
        .document(document['customerID'])
        .get()
        .then((value) => document1 = value);
    feedbackDetails.name = document1['Name'];
    feedbackDetails.email = document1['email'];
    print(feedbackDetails.text);
    return feedbackDetails;
  }
}
