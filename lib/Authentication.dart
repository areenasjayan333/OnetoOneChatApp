import 'package:firebase_auth/firebase_auth.dart';

Future<User?> createAccount(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    User? user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      print("Account created successfully");
      return user;
    } else {
      print("Account creator failed");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User?> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    User? user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      print("Login successfully");
      return user;
    } else {
      print("Login failed");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

// user.updateProfile(displayname : name)
Future logOut() async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    await _auth.signOut();
  } catch (e) {
    print(e);
  }
}
