import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_cafe_admin/Model/Cafe Employee.dart';
import 'package:digi_cafe_admin/Controllers/DBControllers/EmployeeDBController.dart';

class EmployeeUIController {
  EmployeeDBController _employeeDBController;
  CafeEmployee _employee;
  EmployeeUIController() {
    _employeeDBController = new EmployeeDBController();
  }
  Future<bool> addEmployee(
      String name,
      String date,
      String chosenGender,
      String choosenstaffType,
      String phoneNo,
      String email,
      String password,
      String imgURL) async {
    _employee = new CafeEmployee(name, email, chosenGender, date, password,
        phoneNo, choosenstaffType, imgURL);

    bool result = await _employeeDBController.addEmployee(_employee);
    return result;
  }

  // ViewEmployeesList() async {
  //   List<CafeEmployee> employee_list =
  //       await _employeeDBController.getEmployeesList();
  //   return employee_list;
  // }

  Future<bool> deleteEmployee(String id) async {
    bool result = await _employeeDBController.deleteEmployee(id);
    return result;
  }

  Future<bool> updateEmployeeData(CafeEmployee employee) async {
    await _employeeDBController.updateEmployeeData(employee).then((value) {
      return value;
    });
    // return result;
  }

  Stream<QuerySnapshot> getEmployeeSnapshot() {
    return _employeeDBController.getEmployeeSnapshot();
  }

  Future<bool> saveSettings(
      {String count, votes, String openingTime, String closingTime}) async {
    return await _employeeDBController.saveSettings(
        count, votes, openingTime, closingTime);
  }

  Future<DocumentSnapshot> getSettings() async {
    return await _employeeDBController.getSettings();
  }
}
