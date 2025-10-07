import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up function
  Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Error during sign up: $e");
      return null;
    }
  }

  // Sign In function
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Error during sign in: $e");
      return null;
    }
  }

  // Log out function
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Current User function
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  bool isAlreadyLoggedIn(){
    final user = _auth.currentUser;
    if(user == null) {
      return false;
    } else if((user.uid ?? "") != ""){
      return true;
    }else{
      return false;
    }
  }
}
