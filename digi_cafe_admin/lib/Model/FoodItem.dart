class FoodItem {
  String _id, _name, _description, _imgURL;
  double _price, _stockLeft;

  FoodItem(String _id, String _name, String _description, String _imgURL,
      double _price, double _stockLeft) {
    this._id = _id;
    this._name = _name;
    this._description = _description;
    this._imgURL = _imgURL;
    this._price = _price;
    this._stockLeft = _stockLeft;
  }

  String get id {
    return _id;
  }

  set id(String _id) {
    this._id = _id;
  }

  String get name {
    return _name;
  }

  set name(String _name) {
    this._name = _name;
  }

  String get description {
    return _description;
  }

  set description(String _description) {
    this._description = _description;
  }

  String get imgURL {
    return _imgURL;
  }

  set imgURL(String _imgURL) {
    this._imgURL = _imgURL;
  }

  double get price {
    return _price;
  }

  set price(double _price) {
    this._price = _price;
  }

  double get stockLeft {
    return _stockLeft;
  }

  set stockLeft(double _stockLeft) {
    this._stockLeft = _stockLeft;
  }
}
