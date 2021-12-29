import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anonylist/services/database.dart';
import 'package:anonylist/templates/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as dev;

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create local user object with firebase info
  AppUser? _localUser(User? user) {
    return user != null ? AppUser(uid: user.uid, name: user.displayName) : null;
  }

  //Change user from Firebase type to local type
  Stream<AppUser?> get user {
    return _auth.authStateChanges().map((User? user) => _localUser(user));
  }

  //Sign in Anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _localUser(user);
    } catch (e) {
      dev.log(e.toString(), name:"services.auth.signInAnon", error: e);
      return null;
    }
  }

  //Sign in w/ email/pw
  Future signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if (user != null && user.uid != null) {
        DatabaseService database = DatabaseService(uid: user.uid);
        Object? userData = (await database.userCollection.doc(user.uid).get()).data();
        dev.log(userData.toString(), name: "User Data Object");
        database.updateProfilePicUrl();
      }
      return _localUser(user);
    } catch (e) {
      dev.log(e.toString(), name: "auth_svc.signUp");
      return null;
    }
  }

  //Register w/ email/pw
  Future signUp(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      user?.updateDisplayName(name);

      //set up userPreferences for new account in Database
      if (user != null && user.uid != null) {
        DatabaseService database = DatabaseService(uid: user.uid);
        await database.createUser(user.uid, name);
      }
      return _localUser(user);
    } catch (e) {
      dev.log(e.toString(), name: "auth_svc.signUp");
      return null;
    }
  }

  //Sign out
  Future signOut() async {
    try {
      DatabaseService().unlockDatabase();
      return await _auth.signOut();
    } catch (e) {
      dev.log(e.toString(), name:"services.auth.signOut", error: e);
      return null;
    }
  }
}