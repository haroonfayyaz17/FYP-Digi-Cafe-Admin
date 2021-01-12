import 'FoodItem.dart';

class OrderItem {
  FoodItem _foodItem;
  int _itemQuantity;

  OrderItem(FoodItem foodItem, int quantity) {
    this._foodItem = foodItem;
    this._itemQuantity = quantity;
  }

  FoodItem get foodItem {
    return this._foodItem;
  }

  set foodItem(FoodItem foodItem) {
    this._foodItem = foodItem;
  }

  int get quantity {
    return this._itemQuantity;
  }

  set quantity(int quantity) {
    this._itemQuantity = quantity;
  }
}
