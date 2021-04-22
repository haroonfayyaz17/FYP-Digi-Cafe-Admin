import 'package:digi_cafe_admin/Model/Suggestion.dart';

class Complaint extends Suggestion {
  String _category;

  Complaint(
      String id, String text, String status, DateTime time, String category)
      : super(id, text, status, time) {
    this._category = category;
  }

  void set category(String category) {
    this._category = category;
  }

  String get category {
    return this._category;
  }
}
