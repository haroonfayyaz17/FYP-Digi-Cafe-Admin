import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_cafe_admin/Model/Voucher.dart';
import 'package:digi_cafe_admin/Model/FoodItem.dart';
import 'package:digi_cafe_admin/Model/Order.dart';
import 'package:digi_cafe_admin/Controllers/DBControllers/OrderDBController.dart';

class OrderUIController {
  OrderDBController _OrderDBController;

  Order _Order;
  OrderUIController() {
    _OrderDBController = new OrderDBController();
  }

  Stream<QuerySnapshot> getOrderSnapshot() {
    // return null;
  }
  // Future<bool> addOrder(String itemName, String description,
  //     String chosencategory, String price, File image) async {
  //   FoodItem _foodItem = new FoodItem(
  //       null, itemName, description, image.path, double.parse(price), 0);
  //   List<FoodItem> _lst = new List();
  //   _Order = new Order(null, _lst);
  //   _Order.category = chosencategory;
  //   _Order.foodList.add(_foodItem);
  //   bool result = await _OrderDBController.addOrder(_Order, image);
  //   return result;
  // }

  // Future<bool> updateOrder(String id, String itemName, String description,
  //     String chosencategory, String price, String image) async {
  //   FoodItem _foodItem =
  //       new FoodItem(id, itemName, description, image, double.parse(price), 0);
  //   List<FoodItem> _lst = new List();
  //   _Order = new Order(null, _lst);
  //   _Order.category = chosencategory;
  //   _Order.foodList.add(_foodItem);
  //   bool result = await _OrderDBController.updateOrder(_Order);
  //   return result;
  // }

  // Future<String> addCategory(String categoryName) async {
  //   String result =
  //       await _OrderDBController.addCategory(categoryName.toLowerCase());

  //   return Future.value(result);
  // }

  // Future<bool> addVoucher(String voucherTitle, String validity,
  //     String minimumSpend, String discount) async {
  //   Voucher voucher = new Voucher(
  //       title: voucherTitle,
  //       validity: validity,
  //       minimumSpend: minimumSpend,
  //       discount: discount);
  //   bool result = await _OrderDBController.addVoucher(voucher);

  //   return Future.value(result);
  // }

  // Future<bool> updateVoucher(String voucherTitle, String validity,
  //     String minimumSpend, String discount, String id) async {
  //   Voucher voucher = new Voucher(
  //       id: id,
  //       title: voucherTitle,
  //       validity: validity,
  //       minimumSpend: minimumSpend,
  //       discount: discount);
  //   bool result = await _OrderDBController.updateVoucher(voucher);

  //   return Future.value(result);
  // }

  // Future<bool> deleteFoodItem(String id) async {
  //   bool result = await _OrderDBController.deleteFoodItem(id);
  //   return result;
  // }

  // Future<bool> deleteVoucher(String id) async {
  //   bool result = await _OrderDBController.deleteVoucher(id);
  //   return result;
  // }

  // Future<dynamic> loadImageFromStorage(var id) async {
  //   var result = await _OrderDBController.loadImageURL(id);

  //   return Future.value(result);
  // }

  // Future<bool> updateFoodItemQuantity(var foodID, double qty) async {
  //   FoodItem _foodItem = new FoodItem(foodID, null, null, null, null, qty);

  //   bool result = await _OrderDBController.updateFoodItemQuantity(_foodItem);
  //   return result;
  //   // return Future.value(result);
  // }

  // Stream<QuerySnapshot> getOrderSnapshot() {
  //   return _OrderDBController.getOrderSnapshot();
  // }

  // Stream<QuerySnapshot> getCategorySnapshot() {
  //   return _OrderDBController.getCategorySnapshot();
  // }

  // Stream<QuerySnapshot> getVoucherSnapshot() {
  //   return _OrderDBController.getVoucherSnapshot();
  // }

  // Stream<QuerySnapshot> getNominatedItemsSnapshot(String formatted) {
  //   return _OrderDBController.getNominatedItemsSnapshot(formatted);
  // }

  // Future<bool> addNominatedItems(
  //     List<String> itemsSelected, String formatted) async {
  //   bool result =
  //       await _OrderDBController.addNominatedItems(itemsSelected, formatted);
  //   return Future.value(result);
  // }
}
