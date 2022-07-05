import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:uuid/uuid.dart';


class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;





  //delete admins, users, psychiatrist, videos, tasks
  Future<String> deleteAdmins(String uid) async {
    String result = "Some error occur";
    try {
      _firestore.collection("admins").doc(uid).delete();
      result = "success";
    } catch (err) {
      print(err);
    }
    return result;
  }

  Future<String> deleteUsers(String uid) async {
    String result = "Some error occur";
    try {
      _firestore.collection("Users").doc(uid).delete();
      result = "Successfully User Deleted";
      Fluttertoast.showToast(msg: result,backgroundColor: Colors.green,textColor: Colors.white);

    } catch (err) {
      Fluttertoast.showToast(msg: err,backgroundColor: Colors.red,textColor: Colors.white);
      print(err);
    }
    return result;
  }


  Future<String> deleteElection(String uid) async {
    String result = "Some error occur";
    try {
      _firestore.collection("ElectionData").doc(uid).delete();
      result = "Successfully Election Deleted";
      Fluttertoast.showToast(msg: result,backgroundColor: Colors.green,textColor: Colors.white);

    } catch (err) {
      Fluttertoast.showToast(msg: err,backgroundColor: Colors.red,textColor: Colors.white);
      print(err);
    }

    return result;
  }


  Future<String> deleteTask(String uid) async {
    String result = "Some error occur";
    try {
      _firestore.collection("tasks").doc(uid).delete();
      //delete user image from store
      result = "success";
    } catch (err) {
      print(err);
    }
    return result;
  }

  Future<String> deletePsy(String uid) async {
    String result = "Some error occur";
    try {
      _firestore.collection("Organizers").doc(uid).delete();
      //delete user image from store
      result = "success";
    } catch (err) {
      print(err);
    }
    return result;
  }

  getAdminDashBoardData() async {

    Map<String, dynamic> dashBoardData = Map<String, dynamic>();
    List psy = [];
    var voterDocs = await _firestore.collection("Users").where('Status', isEqualTo: "VOTER").get();
    var sizeUser = voterDocs.size;
    var psyDocs = await _firestore.collection("Users").where('Status', isEqualTo: "ORGANIZER").get();
    var sizePsy = psyDocs.size;
    var elcDocs = await _firestore.collection("ElectionData").get();
    var elcPsy = elcDocs.size;
    dashBoardData["userCount"] = sizeUser;
    dashBoardData["psyCount"] = sizePsy;
    dashBoardData["elcCount"] = elcPsy;
    QuerySnapshot snap = await _firestore.collection("Users")
        .where("Status", isEqualTo: "not-verified")
        .get();
    for (var elements in snap.docs) {
      psy.add(elements.data());
    }
    dashBoardData["psyList"] = psy;
    return dashBoardData;

  }

  getPsyDashBoardData() async {
    Map<String, dynamic> dashBoardData = Map<String, dynamic>();
    User currentUser = FirebaseAuth.instance.currentUser;
    List user = [];
    // var userDocs = await _firestore.collection("users").get();
    // var sizeUser = userDocs.size;
    // var psyDocs = await _firestore.collection("psychiatrists").get();
    // var sizePsy = psyDocs.size;
    // dashBoardData["userCount"] = sizeUser;
    // dashBoardData["psyCount"] = sizePsy;
    QuerySnapshot snap = await _firestore
        .collection("Users")
        .where("Organizers", arrayContains: currentUser.uid)
        .get();
    for (var elements in snap.docs) {
      user.add(elements.data());
    }
    dashBoardData["userList"] = user;
    return dashBoardData;

    // _firestore
    //     .collection("tasks")
    //     .where("label", isEqualTo: label)
    //     .snapshots()
    //     .listen((event) {
    //   for (var element in event.docs) {
    //     print("hi");
    //   }
    // });
    //return tk;
  }

  Future<String> approveOrganizer(uid) async {
    await _firestore
        .collection("Users")
        .doc(uid)
        .update({"Status": "ORGANIZER"});
    return "success";
  }
}
