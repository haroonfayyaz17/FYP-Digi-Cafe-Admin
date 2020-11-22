import 'dart:io';

import 'package:digi_cafe_admin/Model/Cafe Employee.dart';
import 'package:digi_cafe_admin/Controllers/DBControllers/LoginDBController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EmployeeDBController {
  FirebaseUser user;
  var firestoreInstance;
  EmployeeDBController() {
    firestoreInstance = Firestore.instance;
  }
  Future<bool> addEmployee(CafeEmployee _employee) async {
    print('dfd');
    var uid = null;
    if (_employee.EmailAddres != "") {
      LoginDBController controller = new LoginDBController();
      uid = await controller.CreateNewUser(
          _employee.EmailAddres, _employee.Password);
    }
    if (uid == null) {
      print('jk');
      await firestoreInstance.collection('Person').add({
        "Name": _employee.Name,
        "email": _employee.EmailAddres,
        "PType": _employee.userType,
        "gender": _employee.Gender,
        "phoneNo": _employee.PhoneNo,
        "DOB": _employee.Dob
      }).then((value) async {
        var id = value.documentID;
        await firestoreInstance
            .collection('Employee')
            .document(id)
            .setData({"User Type": _employee.userType}).then((value) async {
          // print(value.documentID);
          File myFile = new File(_employee.imgURL);
          StorageReference firebaseStorageRef =
              FirebaseStorage.instance.ref().child('Employee/$id');
          StorageUploadTask uploadTask = firebaseStorageRef.putFile(myFile);
          StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
          taskSnapshot.ref.getDownloadURL().then(
                (value) => print("Done: $value"),
              );
        });
        return true;
      });
    } else {
      await firestoreInstance.collection('Person').document(uid).setData({
        "Name": _employee.Name,
        "email": _employee.EmailAddres,
        "PType": _employee.userType,
        "gender": _employee.Gender,
        "phoneNo": _employee.PhoneNo,
        "DOB": _employee.Dob
      }).then((value) {
        firestoreInstance
            .collection('Employee')
            .document(uid)
            .setData({"User Type": _employee.userType}).then((value) async {
          // print(value.documentID);
          File myFile = new File(_employee.imgURL);
          StorageReference firebaseStorageRef =
              FirebaseStorage.instance.ref().child('Employee/${uid}');
          StorageUploadTask uploadTask = firebaseStorageRef.putFile(myFile);
          StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
          taskSnapshot.ref.getDownloadURL().then(
                (value) => print("Done: $value"),
              );
        });
      });

      return true;
    }
  }

  Future<List<CafeEmployee>> getEmployeesList() async {
    try {
      List<CafeEmployee> list = new List<CafeEmployee>();
      QuerySnapshot value =
          await  firestoreInstance.collection('Person').getDocuments();
      for (DocumentSnapshot element in value.documents) {
        CafeEmployee employee = new CafeEmployee(
            element.data["Name"],
            element.data["email"],
            element.data["gender"],
            element.data["DOB"],
            "",
            element.data["phoneNo"],
            element.data["PType"],
            null);
        list.add(employee);
      }
      print(list.length);
      return list;
    } catch (e) {
      print(e);
    }
  }
}
