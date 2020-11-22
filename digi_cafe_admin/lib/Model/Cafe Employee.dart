import 'package:digi_cafe_admin/Model/Person.dart';

class CafeEmployee extends Person {
  String _userType;
  String _imgURL;

  String get imgURL => _imgURL;

  set imgURL(String value) => _imgURL = value;

  CafeEmployee(String name, String emailAddress, String gender, String dob,
      String password, String phoneNo, String userType, String imgUrl)
      : super(name, emailAddress, gender, dob, password, phoneNo) {
    this._userType = userType;
    this._imgURL = imgUrl;
  }

  String get userType {
    return _userType;
  }

  set userType(String user) {
    this._userType = user;
  }
}
