import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studieey/Screens/DashBoard.dart';

class AutheticationService {
  final FirebaseAuth _firebaseAuth;

  AutheticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String?> signIn({
    required String email,
    required String password,
    required BuildContext context,
    required bool isTeacher,
  }) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      var collection = FirebaseFirestore.instance
          .collection('users')
          .doc(result.user!.uid)
          .get();
      User? user = result.user;
      String? name = user!.displayName;
      //Map<String, dynamic> data = collection;
      print(collection);
      print("Shivam");
      print(isTeacher);

      // for (var queryDocumentSnapshot in collection) {
      //   Map<String, dynamic> data = queryDocumentSnapshot.data();
      //   var name = data['name'];
      //   var phone = data['phone'];
      //}

      // FutureBuilder(
      //   future: FirebaseFirestore.instance
      //       .collection('users')
      //       .doc(result.user!.uid)
      //       .get(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting)
      //       Navigator.push(context,
      //           MaterialPageRoute(builder: (context) => DashBoard("Loading")));
      //     else {
      //       if (snapshot.hasData) {
      //         print(snapshot.data);
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) => DashBoard("Loading")));
      //       }
      //     }
      //   },
      // );
      Navigator.of(context)
          .pushNamed(DashBoard.routeName, arguments: isTeacher);

      return "Signed IN";
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
      return e.message;
    }
  }

  Future<void> updateUserName(String name) async {
    User? user = FirebaseAuth.instance.currentUser;
    await user!.updateDisplayName(name);
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
    required bool isTeacher,
  }) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(result.user!.uid)
          .set({
        'username': name,
        'email': email,
      });

      User? user = result.user;

      await user!.updateDisplayName(name);
      print(user.displayName);
      print(user.email);
      print(ModalRoute.of(context)!.settings.arguments);

      Navigator.of(context)
          .pushNamed(DashBoard.routeName, arguments: isTeacher);
      return "Signed Up";
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
      return e.message;
    }
  }
}
