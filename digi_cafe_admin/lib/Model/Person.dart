class Person {
  String _name, _emailAddress, _gender, _dob, _password, _phoneNo;

  String get Name {
    return _name;
  }

  void set Name(String _name) {
    this._name = _name;
  }

  String get EmailAddres {
    return _emailAddress;
  }

  void set EmailAddress(String _emailAddress) {
    this._emailAddress = _emailAddress;
  }

  String get Gender {
    return _gender;
  }

  void set Gender(String _gender) {
    this._gender = _gender;
  }

  String get Dob {
    return _dob;
  }

  void set Dob(String _dob) {
    this._dob = _dob;
  }

  String get Password {
    return _password;
  }

  void set Password(String _password) {
    this._password = _password;
  }

  String get PhoneNo {
    return _phoneNo;
  }

  void set PhoneNo(String _phoneNo) {
    this._phoneNo = _phoneNo;
  }

  Person(this._name, String _emailAddress, String _gender, String _dob,
      String _password, String _phoneNo) {
    this._name = _name;
    this._emailAddress = _emailAddress;
    this._gender = _gender;
    this._dob = _dob;
    this._password = _password;
    this._phoneNo = _phoneNo;
  }
}
