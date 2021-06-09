import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
final _auth = FirebaseAuth.instance;

class FireBase {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static instantiate(){

  }
}

class Auth {

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();







  Future<UserCredential> signUp(String email, String password) async {
    final authResult = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);


    return authResult;
  }

  Future<UserCredential> signIn(String email, String password, bool silientsignin) async {
    final authResult = await _auth.signInWithEmailAndPassword(
        email: email, password: password).then((value) =>
      silientsignin == true ?   putinshared(email ,password) : null

    );
    return authResult;
  }

  Future<UserCredential> signInsilently(String email, String password) async {
    final authResult = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return authResult;
  }



  putinshared(email , password) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString("passord", password);
  }





}
