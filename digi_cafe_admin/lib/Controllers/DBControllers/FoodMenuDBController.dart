import 'dart:io';

import 'package:digi_cafe_admin/Model/FoodMenu.dart';
import 'package:digi_cafe_admin/Model/FoodItem.dart';
import 'package:digi_cafe_admin/Model/Voucher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodMenuDBController {
  var documentName = 'All';

  var collectionName = 'Foods';
  FirebaseUser user;
  var firestoreInstance;

  var nominatedItemsDocument = 'Nominated Items';
  FoodMenuDBController() {
    firestoreInstance = Firestore.instance;
  }
  Future<bool> addFoodMenu(FoodMenu foodMenu, File image) async {
    FoodItem _foodItem = foodMenu.foodList.first;
    await firestoreInstance
        .collection('Food Menu')
        .document("$documentName")
        .collection('$collectionName')
        .add({
      "category": foodMenu.category,
      "name": _foodItem.name,
      "description": _foodItem.description,
      "price": _foodItem.price,
      "stockLeft": _foodItem.stockLeft,
    }).then((value) async {
      // print(value.documentID);
      var id = value.documentID;
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('Food Menu/${value.documentID}');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      taskSnapshot.ref.getDownloadURL().then((value) async {
        print("Done: $value");
        await firestoreInstance
            .collection('Food Menu')
            .document("$documentName")
            .collection("$collectionName")
            .document(id)
            .updateData({"imgURL": value});
      });
    });
    return true;
  }

  Future<bool> updateFoodMenu(FoodMenu foodMenu) async {
    FoodItem _foodItem = foodMenu.foodList.first;
    await firestoreInstance
        .collection('Food Menu')
        .document("$documentName")
        .collection("$collectionName")
        .document(_foodItem.id)
        .updateData({
      "category": foodMenu.category,
      "name": _foodItem.name,
      "description": _foodItem.description,
      "price": _foodItem.price,
      "stockLeft": _foodItem.stockLeft,
    }).then((value) async {
      if (_foodItem.imgURL != null) {
        StorageReference firebaseStorageRef =
            FirebaseStorage.instance.ref().child('Food Menu/${_foodItem.id}');
        print(_foodItem.imgURL);
        File _image = File(_foodItem.imgURL);
        // print(_image.path);
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        taskSnapshot.ref.getDownloadURL().then((value) async {
          print("Done: $value");
          await firestoreInstance
              .collection('Food Menu')
              .document("$documentName")
              .collection("$collectionName")
              .document(_foodItem.id)
              .updateData({"imgURL": value});
        });
      }
    });

    return true;
  }

  Future<bool> deleteFoodItem(String id) async {
    print('yes');
    await firestoreInstance
        .collection('Food Menu')
        .document("$documentName")
        .collection("$collectionName")
        .document(id)
        .delete()
        .catchError((e) {
      print(e);
      return false;
    });

    StorageReference storageReferance = FirebaseStorage.instance.ref();
    await storageReferance.child('Food Menu/${id}').delete().catchError((e) {
      print(e);
    });

    return true;
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

  Future<dynamic> loadImageURL(var id) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Food Menu/${id}');

    await storageReference.getDownloadURL().then((fileURL) {
      return fileURL;
    });
  }

  Future<bool> updateFoodItemQuantity(FoodItem _foodItem) async {
    bool done = false;

    await firestoreInstance
        .collection('Food Menu')
        .document("$documentName")
        .collection("$collectionName")
        .document(_foodItem.id)
        .updateData({
      "stockLeft": _foodItem.stockLeft,
    }).then((value) async {
      done = true;
    });
    return done;
  }

  Stream<QuerySnapshot> getFoodMenuSnapshot() {
    Stream<QuerySnapshot> querySnapshot = firestoreInstance
        .collection('Food Menu')
        .document('$documentName')
        .collection('$collectionName')
        .orderBy('category', descending: false)
        // .where('category', isEqualTo: 'continental')
        .snapshots();
    return querySnapshot;
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

  Stream<QuerySnapshot> getCategorySnapshot() {
    Stream<QuerySnapshot> querySnapshot = firestoreInstance
        .collection('Category')
        // .where('category', isEqualTo: 'continental')
        .snapshots();
    return querySnapshot;
  }

  Stream<QuerySnapshot> getNominatedItemsSnapshot(String formatted) {
    Stream<QuerySnapshot> querySnapshot = firestoreInstance
        .collection('Food Menu')
        .document("$nominatedItemsDocument")
        .collection("$formatted")
        .snapshots();
    return querySnapshot;
  }

  Future<bool> addNominatedItems(
      List<String> itemsSelected, String formatted) async {
    await firestoreInstance
        .collection('Food Menu')
        .document("$nominatedItemsDocument")
        .collection("$formatted")
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.documents) {
        doc.reference.delete();
      }
    });

    for (int i = 0; i < itemsSelected.length; i++) {
      await firestoreInstance
          .collection('Food Menu')
          .document("$nominatedItemsDocument")
          .collection('$formatted')
          .document(itemsSelected[i])
          .setData({
        "item": 'a',
      }, merge: true);
    }

    return Future.value(true);
  }
}
