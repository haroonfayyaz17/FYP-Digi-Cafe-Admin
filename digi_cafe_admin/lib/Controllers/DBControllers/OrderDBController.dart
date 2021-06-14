import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_cafe_admin/Views/FeedbackDetailsClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:digi_cafe_admin/Model/Order.dart';
import 'package:digi_cafe_admin/Model/OrderItem.dart';
import 'package:digi_cafe_admin/Model/FoodItem.dart';
import 'FirebaseCloudMessaging.dart';
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
        .snapshots();

    querySnapshot.listen((event) {
      print(event.documents.length);
    });
    return querySnapshot;
  }

  Stream<QuerySnapshot> getComplaintsSnapshot(
      {String newValue = null, DateTime fromDate, DateTime toDate}) {
    if (newValue == null)
      return firestoreInstance
          .collection('Complaints')
          .orderBy('date', descending: true)
          .orderBy('category')
          .where("date", isGreaterThanOrEqualTo: fromDate)
          .where("date", isLessThanOrEqualTo: toDate)
          .snapshots();
    else {
      return firestoreInstance
          .collection('Complaints')
          .where('category', isEqualTo: '$newValue')
          .where("date", isGreaterThanOrEqualTo: fromDate)
          .where("date", isLessThanOrEqualTo: toDate)
          .orderBy('date', descending: true)
          .snapshots();
    }
  }

  Future<Order> getOrderItemsList(String orderNo, {bool detail = false}) async {
    //This function sends list of order items that wer ordered before
    //and are nominated in todays date as well
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);
    List<OrderItem> list = [];

    Order order = new Order(0, list, now, '');
    int no = int.parse(
      orderNo,
      radix: 10,
      onError: (source) {
        //change double to int
        return double.parse(source.toString()).toInt();
      },
    );
    QuerySnapshot snapshot = await firestoreInstance
        .collection('Orders')
        .where('orderNo', isEqualTo: no)
        .getDocuments();
    DocumentSnapshot element;
    if (snapshot.documents.length != 0) {
      element = snapshot.documents.first;
      order.orderTime = element.data['dateTime'].toDate();
      order.totalAmount = element.data['amount'];
      DocumentSnapshot personDoc = await firestoreInstance
          .collection('Person')
          .document(element.data['servedBy'])
          .get();
      print(personDoc.exists);
      if (personDoc.exists) {
        order.setServedBy = personDoc.data['Name'];
      }

      if (detail) {
        QuerySnapshot querySnapshot = await firestoreInstance
            .collection('Orders')
            .document(element.documentID)
            .collection('Items')
            .getDocuments();
        List<OrderItem> list = [];
        for (DocumentSnapshot element in querySnapshot.documents) {
          DocumentSnapshot doc = await firestoreInstance
              .collection('Food Menu')
              .document(element.documentID)
              .get();
          if (!doc.exists) return order;
          String docID = doc.documentID;
          String name = doc.data['name'];
          double price = doc.data['price'];
          FoodItem foodItem = new FoodItem(docID, name, "", "", price, 0);
          var orderItemQuantity = element.data['quantity'];
          list.add(new OrderItem(foodItem, orderItemQuantity));
        }
        order.orderItems = list;
      }
    }
    return order;
  }

  Future<void> changeComplaintStatus(String id, String status) async {
    await firestoreInstance.collection('Complaints').document(id).updateData({
      "status": status,
    });
  }

  Stream<QuerySnapshot> getSuggestionSnapshot(
      {DateTime fromDate, DateTime toDate}) {
    return firestoreInstance
        .collection('Suggestions')
        .orderBy('date', descending: true)
        .where("date", isGreaterThanOrEqualTo: fromDate)
        .where("date", isLessThanOrEqualTo: toDate)
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
    return feedbackDetails;
  }

  Future<void> submitReply(
      {String feedbackID,
      String reply,
      String type,
      String email,
      String text}) async {
    type == 'complaint'
        ? await firestoreInstance
            .collection('Complaints')
            .document(feedbackID)
            .updateData({
            "reply": reply,
          })
        : await firestoreInstance
            .collection('Suggestions')
            .document(feedbackID)
            .updateData({
            "reply": reply,
          });

    QuerySnapshot querySnapshot = await firestoreInstance
        .collection('Person')
        .where('email', isEqualTo: '$email')
        .limit(1)
        .getDocuments();

    for (DocumentSnapshot element in querySnapshot.documents) {
      sendNotifications('Admin\'s Response', element['tokenID'],
          'Complain: $text\n' + 'Reply: $reply');
    }
  }

  Future<void> sendNotifications(String title, var tokenId, String msg) async {
    FirebaseCloudMessaging firebaseCloudMessaging =
        new FirebaseCloudMessaging();

    firebaseCloudMessaging.sendAndRetrieveMessage(title, msg, tokenId);
  }

  Stream<QuerySnapshot> getDuesSnapshot() {
    Stream<QuerySnapshot> querySnapshot =
        firestoreInstance.collection('Faculty').snapshots();
    return querySnapshot;
  }

  Future<DocumentSnapshot> getPersonData(docId) async {
    return await firestoreInstance
        .collection('Person')
        .document(docId)
        .get()
        .then((value) {
      return value;
    });
  }

  Stream<QuerySnapshot> getDuesDetailSnapshot({String docId}) {
    Stream<QuerySnapshot> querySnapshot = firestoreInstance
        .collection('Faculty')
        .document(docId)
        .collection('Dues')
        .snapshots();
    return querySnapshot;
  }

  Stream<QuerySnapshot> getOrderReviewsSnapshot({int no}) {
    Stream<QuerySnapshot> querySnapshot;
    int l = 1, h = 5;
    if (no == 2) {
      l = 3;
      h = 5;
    } else if (no == 3) {
      l = 1;
      h = 3;
    }
    querySnapshot = firestoreInstance
        .collection('Orders')
        .where("rating", isGreaterThanOrEqualTo: l)
        .where("rating", isLessThanOrEqualTo: h)
        .orderBy('rating')
        .orderBy('orderNo', descending: true)
        .snapshots();
    return querySnapshot;
  }

  Future<DocumentSnapshot> getFoodItemData(docId) async {
    return await firestoreInstance
        .collection('Food Menu')
        .document(docId)
        .get()
        .then((value) {
      return value;
    });
  }

  Stream<QuerySnapshot> getOrderSnapshot(docID) {
    return firestoreInstance
        .collection('Orders')
        .document(docID)
        .collection('Items')
        .snapshots();
  }
}
