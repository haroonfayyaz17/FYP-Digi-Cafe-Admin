import 'dart:io';
import 'package:digi_cafe_admin/Controllers/DBControllers/FirebaseCloudMessaging.dart';
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
    var done = false;
    try {
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
        StorageReference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('Food Menu/${value.documentID}');
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        taskSnapshot.ref.getDownloadURL().then((value) async {
          await firestoreInstance
              .collection('Food Menu')
              .document("$documentName")
              .collection("$collectionName")
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

  Future<bool> updateFoodMenu(FoodMenu foodMenu) async {
    bool done;
    try {
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
      done = true;
    } catch (e) {
      done = false;
    }
    return done;
  }

  Future<bool> deleteFoodItem(String id) async {
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
        firestoreInstance
            .collection('Person')
            .document(element.documentID)
            .collection("Voucher")
            .document(id)
            .delete()
            .catchError((e) {
          print(e);
          done = false;
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
    print('yes');
    FirebaseCloudMessaging firebaseCloudMessaging =
        new FirebaseCloudMessaging();
    QuerySnapshot value = await firestoreInstance
        .collection('Person')
        .where('PType', whereIn: ["faculty", "student"]).getDocuments();
    for (DocumentSnapshot element in value.documents) {
      firebaseCloudMessaging.sendAndRetrieveMessage("Items Nominated",
          "The new items are nominated", element.data['tokenID']);
    }
  }

  Future<bool> addVoucher(Voucher voucher) async {
    var done = false;
    try {
      // await firestoreInstance.collection('Category').add({
      //   "name": categoryName,
      // }).then((value) async {
      //   done = true;
      // });

      await firestoreInstance.collection('Voucher').add({
        "title": voucher.getTitle,
        "validity": voucher.validity,
        'discount': voucher.discount,
        'minimumSpend': voucher.minimumSpend,
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
            // "title": voucher.title,
            // "validity": voucher.validity,
            // 'discount': voucher.discount,
            // 'minimumSpend': voucher.minimumSpend,
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
      // await firestoreInstance.collection('Category').add({
      //   "name": categoryName,
      // }).then((value) async {
      //   done = true;
      // });

      await firestoreInstance
          .collection('Voucher')
          .document(voucher.getId)
          .setData({
        "title": voucher.title,
        "validity": voucher.validity,
        'discount': voucher.discount,
        'minimumSpend': voucher.minimumSpend,
      }).then((value1) async {
        // var id = value1.documentID;
        // QuerySnapshot value =
        //     await firestoreInstance.collection('Person').getDocuments();
        // for (DocumentSnapshot element in value.documents) {
        //   firestoreInstance
        //       .collection('Person')
        //       .document(element.documentID)
        //       .collection("Voucher")
        //       .document(id)
        //       .setData({
        //     "title": voucher.title,
        //     "validity": voucher.validity,
        //     'discount': voucher.discount,
        //     'minimumSpend': voucher.minimumSpend,
        //     'usedOn': 'null',
        //   });
        //
        // }
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
          .document("$documentName")
          .collection("$collectionName")
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
        .document('$documentName')
        .collection('$collectionName')
        .orderBy('category', descending: false)
        // .where('category', isEqualTo: 'continental')
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
      int count = 0;
      for (DocumentSnapshot element in querySnapshot.documents) {
        count++;
        break;
      }
      if (count == 0) {
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
        "count": '0',
      }, merge: true);
    }
    sendNotifications();

    return Future.value(true);
  }

  Stream<QuerySnapshot> getVoucherSnapshot() {
    Stream<QuerySnapshot> querySnapshot = firestoreInstance
        .collection('Voucher')
        // .where('category', isEqualTo: 'continental')
        .snapshots();
    return querySnapshot;
  }
}
