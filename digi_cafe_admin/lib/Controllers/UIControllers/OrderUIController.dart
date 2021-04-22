import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_cafe_admin/Model/Voucher.dart';
import 'package:digi_cafe_admin/Model/FoodItem.dart';
import 'package:digi_cafe_admin/Model/Order.dart';
import 'package:digi_cafe_admin/Controllers/DBControllers/OrderDBController.dart';

class OrderUIController {
  OrderDBController _orderDBController;

  Order _Order;
  OrderUIController() {
    _orderDBController = new OrderDBController();
  }

  Stream<QuerySnapshot> getOrdersSnapshot() {
    return _orderDBController.getOrdersSnapshot();
  }

  Future<Stream<QuerySnapshot>> getFilteredOrdersSnapshot(
      String filterType, DateTime fromDate, DateTime toDate) async {
    return await _orderDBController.getFilteredOrdersSnapshot(
        filterType, fromDate, toDate);
  }

  Stream<QuerySnapshot> getComplaintsSnapshot({String newValue = null}) {
    return _orderDBController.getComplaintsSnapshot(newValue: newValue);
  }

  Future<void> changeComplaintStatus(String id, String status) async {
    await _orderDBController.changeComplaintStatus(id, status);
  }

  Stream<QuerySnapshot> getSuggestionSnapshot() {
    return _orderDBController.getSuggestionSnapshot();
  }

  Future<void> changeSuggestionStatus(String id, String status) async {
    await _orderDBController.changeSuggestionStatus(id, status);
  }
}
