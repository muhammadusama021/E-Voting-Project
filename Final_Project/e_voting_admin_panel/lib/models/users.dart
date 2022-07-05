import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String Status;
  String uid;
  String name;
  String email;
  String phoneNo;
  String regNo;
  String nodeID;
  String depart;
  String CNIC;
  String permanentAddress;
  String postalAddress;

  User({this.uid,this.name,this.email,this.phoneNo,this.Status,this.regNo,this.nodeID,this.depart,this.permanentAddress,this.postalAddress
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'email': email,
    'phoneNo':phoneNo,
    'Status': Status,
    'regNo': regNo,
    'nodeID': nodeID,
    'depart': depart,
    'permanentAddress':permanentAddress,
    'postalAddress':postalAddress,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
        uid: snapshot['uid'],
        name: snapshot['name'],
        email: snapshot['email'],
        phoneNo: snapshot['phoneNo'],
        Status: snapshot['Status'],
        regNo: snapshot['regNo'],
        nodeID: snapshot['nodeID'],
        depart: snapshot['depart'],
        permanentAddress: snapshot['permanentAddress'],
        postalAddress: snapshot['postalAddress'],

    );
  }
}
