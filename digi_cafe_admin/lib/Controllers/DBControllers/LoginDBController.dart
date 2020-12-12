import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class LoginDBController {
  FirebaseAuth _firebaseAuth;
  var _firebaseDatabase;
  FirebaseUser user;

  LoginDBController() {
    _firebaseAuth = FirebaseAuth.instance;
    _firebaseDatabase = FirebaseDatabase.instance.reference();
  }

  Future<String> CheckSignIn(String _username, String _password) async {
    String login = null;
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: _username, password: _password);
      user = result.user;
      if (user == null) {
        login = null;
      } else {
        login = user.uid;
      }
      print('id: ' + login);
    } catch (e) {
      if (e.code == 'ERROR_WRONG_PASSWORD') {
        login = 'wrong password';
      } else {
        login = 'wrong email';
      }
    }
    return login;
  }

  @override
  Future<String> resetPassword(String email) async {
    String login;
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return 'correct';
    } catch (e) {
      if (e.code == 'ERROR_INVALID_EMAIL') {
        return 'invalid';
      }

      // print(e.toString());
      // print(e.message);
    }
  }

  Future<String> CreateNewUser(String _username, String _password) async {
    String login = ' ';
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: _username, password: _password);
      sendEmailVerification(result.user);
      user = result.user;
      login = user.uid;
    } catch (e) {
      print(e);
      // print(e.toString());
      // print(e.message);
    }
    return login;
  }

  Future<FirebaseUser> getCurrentUser() async {
    user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification(FirebaseUser user) async {
    print(user);
    await user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}
