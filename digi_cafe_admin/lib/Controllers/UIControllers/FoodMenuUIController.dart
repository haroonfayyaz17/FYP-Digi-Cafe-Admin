import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_cafe_admin/Model/Voucher.dart';
import 'package:digi_cafe_admin/Model/FoodItem.dart';
import 'package:digi_cafe_admin/Model/FoodMenu.dart';
import 'package:digi_cafe_admin/Controllers/DBControllers/FoodMenuDBController.dart';

class FoodMenuUIController {
  FoodMenuDBController _foodMenuDBController;

  FoodMenu _foodMenu;
  FoodMenuUIController() {
    _foodMenuDBController = new FoodMenuDBController();
  }
  Future<bool> addFoodMenu(String itemName, String description,
      String chosencategory, String price, File image) async {
    FoodItem _foodItem = new FoodItem(
        null, itemName, description, image.path, double.parse(price), 0);
    List<FoodItem> _lst = new List();
    _foodMenu = new FoodMenu(null, _lst);
    _foodMenu.category = chosencategory;
    _foodMenu.foodList.add(_foodItem);
    bool result = await _foodMenuDBController.addFoodMenu(_foodMenu, image);
    return result;
  }

  Future<bool> updateFoodMenu(String id, String itemName, String description,
      String chosencategory, String price, String image) async {
    FoodItem _foodItem =
        new FoodItem(id, itemName, description, image, double.parse(price), 0);
    List<FoodItem> _lst = new List();
    _foodMenu = new FoodMenu(null, _lst);
    _foodMenu.category = chosencategory;
    _foodMenu.foodList.add(_foodItem);
    bool result = await _foodMenuDBController.updateFoodMenu(_foodMenu);
    return result;
  }

  Future<String> addCategory(String categoryName) async {
    String result =
        await _foodMenuDBController.addCategory(categoryName.toLowerCase());

    return Future.value(result);
  }

  Future<bool> addVoucher(String voucherTitle, String validity,
      String minimumSpend, String discount) async {
    Voucher voucher = new Voucher(
        title: voucherTitle,
        validity: validity,
        minimumSpend: minimumSpend,
        discount: discount);
    bool result = await _foodMenuDBController.addVoucher(voucher);

    return Future.value(result);
  }

  Future<bool> updateVoucher(String voucherTitle, String validity,
      String minimumSpend, String discount, String id) async {
    Voucher voucher = new Voucher(
        id: id,
        title: voucherTitle,
        validity: validity,
        minimumSpend: minimumSpend,
        discount: discount);
    bool result = await _foodMenuDBController.updateVoucher(voucher);

    return Future.value(result);
  }

  Future<bool> deleteFoodItem(String id) async {
    bool result = await _foodMenuDBController.deleteFoodItem(id);
    return result;
  }

  Future<bool> deleteVoucher(String id) async {
    bool result = await _foodMenuDBController.deleteVoucher(id);
    return result;
  }

  Future<dynamic> loadImageFromStorage(var id) async {
    var result = await _foodMenuDBController.loadImageURL(id);

    return Future.value(result);
  }

  Future<bool> updateFoodItemQuantity(var foodID, double qty) async {
    FoodItem _foodItem = new FoodItem(foodID, null, null, null, null, qty);

    bool result = await _foodMenuDBController.updateFoodItemQuantity(_foodItem);
    return result;
    // return Future.value(result);
  }

  Stream<QuerySnapshot> getFoodMenuSnapshot() {
    return _foodMenuDBController.getFoodMenuSnapshot();
  }

  Stream<QuerySnapshot> getCategorySnapshot() {
    return _foodMenuDBController.getCategorySnapshot();
  }

  Stream<QuerySnapshot> getVoucherSnapshot() {
    return _foodMenuDBController.getVoucherSnapshot();
  }

  Stream<QuerySnapshot> getNominatedItemsSnapshot(String formatted) {
    return _foodMenuDBController.getNominatedItemsSnapshot(formatted);
  }

  Future<bool> addNominatedItems(
      List<String> itemsSelected, String formatted) async {
    bool result =
        await _foodMenuDBController.addNominatedItems(itemsSelected, formatted);
    return Future.value(result);
  }
}
