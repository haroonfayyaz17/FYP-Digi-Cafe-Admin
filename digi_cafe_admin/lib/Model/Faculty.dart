import 'Customer.dart';

class Faculty extends Customer {
  int _dues;
  String _officeNumber, _department;

  Faculty(String name, String emailAddress, String gender, String dob,
      String password, int _dues, String _officeNumber, String _department)
      : super(name, emailAddress, gender, dob, password) {
    this._dues = _dues;
    this._officeNumber = _officeNumber;
    this._department = _department;
  }

  int getDues() {
    return _dues;
  }

  setDues(int _dues) {
    this._dues = _dues;
  }

  String get officeNumber {
    return _officeNumber;
  }

  set officeNumber(String _officeNumber) {
    this._officeNumber = _officeNumber;
  }

  String get department {
    return _department;
  }

  set department(String _department) {
    this._department = _department;
  }
}
