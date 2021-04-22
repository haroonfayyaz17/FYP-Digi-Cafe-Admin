class FeedbackDetails {
  String _id;
  String _text;
  DateTime _dateTime;
  String _name;
  String _email;
  String _reply;
  String _category;
  String _orderNo;

  FeedbackDetails(
      {String id = '',
      String name = '',
      String email = '',
      String text = '',
      String reply = '',
      DateTime date,
      String category = '',
      String orderNo=''}) {
    _id = id;
    _name = name;
    _email = email;
    _text = text;
    _reply = reply;
    _dateTime = date;
    _category = category;
    _orderNo = orderNo;
  }

  String get orderNo => this._orderNo;

  set orderNo(String value) => this._orderNo = value;

  get category => this._category;

  set category(value) => this._category = value;

  String get id => this._id;

  set id(String value) => this._id = value;

  get text => this._text;

  set text(value) => this._text = value;

  get dateTime => this._dateTime;

  set dateTime(value) => this._dateTime = value;

  get name => this._name;

  set name(value) => this._name = value;

  get email => this._email;

  set email(value) => this._email = value;

  get reply => this._reply;

  set reply(value) => this._reply = value;
}
