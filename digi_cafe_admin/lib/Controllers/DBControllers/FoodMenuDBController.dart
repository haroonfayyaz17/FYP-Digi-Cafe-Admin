import 'dart:io';
import 'package:digi_cafe_admin/Controllers/DBControllers/FirebaseCloudMessaging.dart';
import 'package:digi_cafe_admin/Model/FoodMenu.dart';
import 'package:digi_cafe_admin/Model/FoodItem.dart';
import 'package:digi_cafe_admin/Model/Voucher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
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
  Future<bool> addFoodMenu(
      FoodMenu foodMenu, File image, bool autoRestock) async {
    var done = false;
    try {
      DateTime dateTime = DateTime.now();
      DateTime dt = new DateTime(dateTime.year, dateTime.month, dateTime.day);
      FoodItem _foodItem = foodMenu.foodList.first;
      await firestoreInstance.collection('Food Menu').add({
        "category": foodMenu.category,
        "name": _foodItem.name,
        "description": _foodItem.description,
        "price": _foodItem.price,
        "rating": 0,
        "review": null,
        "totalOrders": 0,
        "totalRatings": 0,
        "deleted": false,
        "lastUpdated": dt,
        "autoRestock": autoRestock,
        "defaultStock": _foodItem.stockLeft,
        "votes": 0,
        "isNominated": false,
        "stockLeft": _foodItem.stockLeft,
      }).then((value) async {
        var id = value.documentID;
        StorageReference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('Food Menu/${value.documentID}');
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        taskSnapshot.ref.getDownloadURL().then((value) async {
          await firestoreInstance
              .collection('Food Menu')
              .document(id)
              .updateData({"imgURL": value});
        });
      });

      done = true;
    } catch (e) {
      done = false;
    }
    return done;
  }

  Future<bool> updateFoodMenu(FoodMenu foodMenu, bool autoRestock) async {
    bool done;
    try {
      FoodItem _foodItem = foodMenu.foodList.first;
      await firestoreInstance
          .collection('Food Menu')
          .document(_foodItem.id)
          .updateData({
        "category": foodMenu.category,
        "name": _foodItem.name,
        "description": _foodItem.description,
        "price": _foodItem.price,
        "stockLeft": _foodItem.stockLeft,
        "defaultStock": _foodItem.stockLeft,
        "autoRestock": autoRestock,
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
                .document(_foodItem.id)
                .updateData({"imgURL": value});
          });
        }
      });
      done = true;
    } catch (e) {
      done = false;
    }
    return done;
  }

  Future<bool> deleteFoodItem(String id) async {
    return await firestoreInstance
        .collection('Food Menu')
        .document(id)
        .updateData({
      "deleted": true,
      "isNominated": false,
      "stockLeft": 0
    }).then((value) async {
      return true;
    });
  }

  Future<bool> deleteVoucher(String id) async {
    var done = false;
    await firestoreInstance
        .collection('Voucher')
        .document("$id")
        .delete()
        .then((value1) async {
      QuerySnapshot value = await firestoreInstance
          .collection('Person')
          .where('PType', whereIn: ["faculty", "student"]).getDocuments();
      for (DocumentSnapshot element in value.documents) {
        await firestoreInstance
            .collection('Person')
            .document(element.documentID)
            .collection("Voucher")
            .document(id)
            .get()
            .then((value) {
          if (value.exists)
            value.reference.delete().catchError((e) {
              print(e);
              done = false;
            });
        });
      }
      done = true;
    }).catchError((e) {
      print(e);
      done = false;
    });
    // print(done);
    return done;
  }

  Future<void> sendNotifications() async {
    var date = DateTime.now();

    var dateTxt = DateFormat('EEEE, d MMM, yyyy')
        .format(date); // prints Tuesday, 10 Dec, 2019

    FirebaseCloudMessaging firebaseCloudMessaging =
        new FirebaseCloudMessaging();
    QuerySnapshot value = await firestoreInstance
        .collection('Person')
        .where('PType', whereIn: ["faculty", "student"]).getDocuments();
    for (DocumentSnapshot element in value.documents) {
      firebaseCloudMessaging.sendAndRetrieveMessage(
          "Items Nominated",
          "Hi! ${element.data['Name']}, Your wait is over. The new items for $dateTxt are nominated. Vote for your favorite food items to see them in the upcoming menu",
          element.data['tokenID']);
    }
  }

  Future<bool> addVoucher(Voucher voucher) async {
    var done = false;
    try {
      await firestoreInstance.collection('Voucher').add({
        "title": voucher.getTitle,
        "validity": voucher.validity,
        'discount': voucher.discount,
        'minimumSpend': voucher.minimumSpend,
        'cancel': false,
      }).then((value1) async {
        var id = value1.documentID;
        QuerySnapshot value = await firestoreInstance
            .collection('Person')
            .where('PType', whereIn: ["faculty", "student"]).getDocuments();
        for (DocumentSnapshot element in value.documents) {
          firestoreInstance
              .collection('Person')
              .document(element.documentID)
              .collection("Voucher")
              .document(id)
              .setData({
            'usedOn': 'null',
          });
        }
        done = true;
      });
    } catch (e) {
      done = false;
    }
    return Future.value(done);
  }

  Future<bool> updateVoucher(Voucher voucher) async {
    var done = false;
    try {
      await firestoreInstance
          .collection('Voucher')
          .document(voucher.getId)
          .updateData({
        "title": voucher.title,
        "validity": voucher.validity,
        'discount': voucher.discount,
        'minimumSpend': voucher.minimumSpend,
      }).then((value1) async {
        done = true;
      });
    } catch (e) {
      done = false;
    }

    return Future.value(done);
  }

  Future<dynamic> loadImageURL(var id) async {
    try {
      StorageReference storageReference =
          FirebaseStorage.instance.ref().child('Food Menu/${id}');

      await storageReference.getDownloadURL().then((fileURL) {
        return fileURL;
      });
    } catch (e) {
      return '';
    }
  }

  Future<bool> updateFoodItemQuantity(FoodItem _foodItem) async {
    bool done = false;
    try {
      await firestoreInstance
          .collection('Food Menu')
          .document(_foodItem.id)
          .updateData({
        "stockLeft": _foodItem.stockLeft,
      }).then((value) async {
        done = true;
      });
    } catch (e) {
      done = false;
    }
    return done;
  }

  Stream<QuerySnapshot> getFoodMenuSnapshot() {
    Stream<QuerySnapshot> querySnapshot = firestoreInstance
        .collection('Food Menu')
        .where('deleted', isEqualTo: false)
        .orderBy('category', descending: false)
        .snapshots();
    return querySnapshot;
  }

  Future<String> addCategory(String categoryName) async {
    var done = '';
    try {
      QuerySnapshot querySnapshot = await firestoreInstance
          .collection('Category')
          .where('name', isEqualTo: '$categoryName')
          .getDocuments();

      if (querySnapshot.documents.length == 0) {
        await firestoreInstance.collection('Category').add({
          "name": categoryName,
        }).then((value) async {
          done = 'true';
        });
      } else {
        done = 'exist';
      }
    } catch (e) {
      done = 'false';
    }

    return Future.value(done);
  }

  Stream<QuerySnapshot> getCategorySnapshot() {
    Stream<QuerySnapshot> querySnapshot =
        firestoreInstance.collection('Category').snapshots();
    return querySnapshot;
  }

  Future<bool> addNominatedItems(List<String> itemsSelected) async {
    DateTime dateTime = DateTime.now();
    DateTime dt = new DateTime(dateTime.year, dateTime.month, dateTime.day);
    await firestoreInstance
        .collection('Food Menu')
        .getDocuments()
        .then((snapshot) async {
      for (DocumentSnapshot doc in snapshot.documents) {
        if (itemsSelected.contains(doc.documentID)) {
          if (dt.compareTo(doc['lastUpdated'].toDate()) != 0) {
            await firestoreInstance
                .collection('Food Menu')
                .document(doc.documentID)
                .updateData(
                    {"lastUpdated": dt, "isNominated": true, "votes": 0});
          } else {
            await firestoreInstance
                .collection('Food Menu')
                .document(doc.documentID)
                .updateData({"isNominated": true});
          }
        } else {
          await firestoreInstance
              .collection('Food Menu')
              .document(doc.documentID)
              .updateData(
                  {"lastUpdated": dt, "isNominated": false, "votes": 0});
        }
      }
    });

    sendNotifications();

    return Future.value(true);
  }

  Stream<QuerySnapshot> getVoucherSnapshot({bool type = false}) {
    Stream<QuerySnapshot> querySnapshot = firestoreInstance
        .collection('Voucher')
        .where('cancel', isEqualTo: type)
        .snapshots();
    return querySnapshot;
  }

  Future<bool> autoRestockAll() async {
    await firestoreInstance
        .collection('Food Menu')
        .where('autoRestock', isEqualTo: true)
        .getDocuments()
        .then((snapshot) async {
      for (DocumentSnapshot doc in snapshot.documents) {
        var stock = doc.data['defaultStock'];
        await firestoreInstance
            .collection('Food Menu')
            .document(doc.documentID)
            .updateData({"stockLeft": stock});
      }
    });
  }
}
