import 'dart:io';

import 'package:digi_cafe_admin/Model/FoodMenu.dart';
import 'package:digi_cafe_admin/Model/FoodItem.dart';
import 'package:digi_cafe_admin/Controllers/DBControllers/LoginDBController.dart';
import 'package:digi_cafe_admin/Model/Voucher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodMenuDBController {
  FirebaseUser user;
  var firestoreInstance;
  FoodMenuDBController() {
    firestoreInstance = Firestore.instance;
  }
  Future<bool> addFoodMenu(FoodMenu foodMenu, File image) async {
    FoodItem _foodItem = foodMenu.foodList.first;
    await firestoreInstance
        .collection('Food Menu')
        .document("1")
        .collection(foodMenu.category)
        .add({
      "name": _foodItem.name,
      "description": _foodItem.description,
      "price": _foodItem.price,
      "stockLeft": _foodItem.stockLeft,
    }).then((value) async {
      // print(value.documentID);
      StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child('Food Menu/${value.documentID}');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      taskSnapshot.ref.getDownloadURL().then(
            (value) => print("Done: $value"),
          );
    });
    return true;
  }

  Future<bool> addCategory(String categoryName) async {
    var done = false;
    await firestoreInstance.collection('Category').add({
      "name": categoryName,
    }).then((value) async {
      done = true;
    });
    return Future.value(done);
  }

  Future<bool> addVoucher(Voucher voucher) async {
    var done = false;
    // await firestoreInstance.collection('Category').add({
    //   "name": categoryName,
    // }).then((value) async {
    //   done = true;
    // });
    QuerySnapshot value =
        await firestoreInstance.collection('Person').getDocuments();

    for (DocumentSnapshot element in value.documents) {
      firestoreInstance
          .collection('Person')
          .document(element.documentID)
          .collection("Voucher")
          .add({
        "title": voucher.title,
        "validity": voucher.validity,
        'discount': voucher.discount,
        'minimumSpend': voucher.minimumSpend,
        'usedOn': 'null',
      });
      done = true;
    }

    return Future.value(done);
  }
}
