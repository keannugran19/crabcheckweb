import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

String? uid;
String? userEmail;
String? name;

Future<User?> signInWithEmailPassword(String email, String password) async {
  await Firebase.initializeApp();
  User? user;

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    user = userCredential.user;

    if (user != null) {
      uid = user.uid;
      userEmail = user.email;
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided');
    }
  }

  return user;
}

Future<void> getUser() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    userEmail = user.email;
    print('User is signed in with uid: ${user.uid}');
  } else {
    userEmail = null;
    print('No user is signed in.');
  }
}

Future<String> signOut() async {
  await _auth.signOut();

  uid = null;
  userEmail = null;

  return "User signed out";
}
