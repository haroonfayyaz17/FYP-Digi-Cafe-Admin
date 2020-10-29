import 'package:flutter/foundation.dart';

import 'FoodItem.dart';

class FoodMenu {
  String _category;
  List<FoodItem> _food = new List();
  FoodMenu(this._category, this._food);

  set category(String category) {
    this._category = category;
  }

  String get category {
    return this._category;
  }

  set foodList(List<FoodItem> food) {
    this._food = food;
  }

  List<FoodItem> get foodList {
    return this._food;
  }
}
