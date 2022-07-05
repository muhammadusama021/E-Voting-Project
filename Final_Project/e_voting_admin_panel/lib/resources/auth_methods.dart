import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_voting_admin_panel/models/users.dart' as userModel;
import 'package:e_voting_admin_panel/models/admin.dart' as adminModel;


class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //details of single user
  Future<userModel.User> getUserDetails(String uid) async {
    DocumentSnapshot snap = await _firestore.collection("Users").doc(uid).get();

    return userModel.User.fromSnap(snap);
  }


  //details of current logged in psychiatrist
  Future<Map<String, dynamic>> getCurrentPsyDetails() async {
    User currentUser = _auth.currentUser;
    DocumentSnapshot snap =
        await _firestore.collection("Organizers").doc(currentUser.uid).get();
    var psyData = snap.data() as Map<String, dynamic>;
    return psyData;
  }

  //details of single admin
  Future<adminModel.Admin> getAdminDetails(String uid) async {
    DocumentSnapshot snap =
        await _firestore.collection("admins").doc(uid).get();

    return adminModel.Admin.fromSnap(snap);
  }

  //details of current logged in admin
  Future<adminModel.Admin> getCurrentAdminDetails() async {
    User currentUser = _auth.currentUser;
    DocumentSnapshot snap =
        await _firestore.collection("admins").doc(currentUser.uid).get();
    return adminModel.Admin.fromSnap(snap);
  }

  //sign up admin
  Future<String> signupAdmin({
    String email,
    String password,
    String username,
    String secretKey,
    Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty
          ) {
        //register user in firebase auth
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);



        //save user data in firebase fire store
        adminModel.Admin admin = adminModel.Admin(
          username: username,
          uid: cred.user.uid,
          email: email,

        );

        await _firestore
            .collection("admins")
            .doc(cred.user.uid)
            .set(admin.toJson());
        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'This email is badly formatted.';
      } else if (err.code == 'weak-password') {
        res = 'password should be at least 6 digits long';
      } else if (err.code == 'email-already-in-use') {
        res =
            'The email address is already used. Please try new email or login.';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //login user
  Future<String> loginAdmin(
      {String email,
      String password,
     }) async {
    String res = "Email or password key cannot be empty";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential cred = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        DocumentSnapshot snap =
            await _firestore.collection("admins").doc(cred.user.uid).get();
        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'This email is badly formatted.';
      } else if (err.code == 'user-not-found') {
        res = 'No such user exist. Click on signup to create new account.';
      } else if (err.code == 'wrong-password') {
        res = 'The password is invalid Please try again.';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }



  //login user



  Future<bool> signOutPsy() async {
    try {
      await _auth.signOut();
      return true;
    } catch (err) {
      return false;
    }
  }


  Future<String> deleteUser(String uid) async {
    String result = "Some error occur";
    try {
      _firestore.collection("Users").doc(uid).delete();
      //delete user image from store
      result = "success";
    } catch (err) {
      print(err);
    }
    return result;
  }

}
