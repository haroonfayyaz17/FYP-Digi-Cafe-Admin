class Suggestion {
  String _id;
  String _text;
  String _status;
  DateTime _time;

  Suggestion(String id, String text, String status, DateTime time) {
    this._id = id;
    this._text = text;
    this._status = status;
    this._time = time;
  }

  set id(String id) {
    this._id = id;
  }

  set text(String text) {
    this._text = text;
  }

  set status(String status) {
    this._status = status;
  }

  set time(DateTime time) {
    this._time = time;
  }

  String get id {
    return this._id;
  }

  String get text {
    return this._text;
  }

  String get status {
    return this._status;
  }

  DateTime get time {
    return this._time;
  }
}
