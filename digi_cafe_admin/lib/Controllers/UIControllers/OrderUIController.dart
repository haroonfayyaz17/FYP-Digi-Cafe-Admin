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
}
