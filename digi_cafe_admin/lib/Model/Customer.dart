import 'Person.dart';

class Customer extends Person {
  Customer(String name, String emailAddress, String gender, String dob,
      String password)
      : super(name, emailAddress, gender, dob, password, '') {}
}
