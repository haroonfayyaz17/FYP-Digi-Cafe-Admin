import 'dart:io';
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

  Future<bool> addCategory(String categoryName) async {
    bool result = await _foodMenuDBController.addCategory(categoryName);

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
}
