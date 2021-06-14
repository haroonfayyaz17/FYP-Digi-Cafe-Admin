import 'package:digi_cafe_admin/Model/OrderItem.dart';

class Order {
  String _orderNo, _review, _status;
  int _totalAmount;
  double _rating;
  List<OrderItem> _orderItems;
  DateTime _orderTime;
  String servedBy;

  Order(this._totalAmount, this._orderItems, this._orderTime, this._status) {
    this._totalAmount = _totalAmount;
    this._orderItems = _orderItems;
    this._orderTime = _orderTime;
    this._status = _status;
    this.servedBy = '';
  }
  String get getServedBy => this.servedBy;

  set setServedBy(String servedBy) => this.servedBy = servedBy;
  DateTime get orderTime {
    return _orderTime;
  }

  set orderTime(DateTime _orderTime) {
    this._orderTime = _orderTime;
  }

  String get orderNo {
    return _orderNo;
  }

  set orderNo(String _orderNo) {
    this._orderNo = _orderNo;
  }

  String get status {
    return _status;
  }

  set status(String _status) {
    this._status = _status;
  }

  String get review {
    return _review;
  }

  set review(String _review) {
    this._review = _review;
  }

  int get totalAmount {
    return _totalAmount;
  }

  set totalAmount(int _totalAmount) {
    this._totalAmount = _totalAmount;
  }

  double get rating {
    return _rating;
  }

  set rating(double _rating) {
    this._rating = _rating;
  }

  List<OrderItem> get orderItems {
    return _orderItems;
  }

  set orderItems(List<OrderItem> _orderItems) {
    this._orderItems = _orderItems;
  }
}
