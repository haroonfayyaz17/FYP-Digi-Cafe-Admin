import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:digi_cafe_admin/Model/Order.dart';
import 'package:intl/intl.dart';

class OrderDBController {
  var firestoreInstance;
  FirebaseUser user;

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
}
