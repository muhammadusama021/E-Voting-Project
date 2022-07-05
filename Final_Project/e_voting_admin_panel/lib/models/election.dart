import 'package:cloud_firestore/cloud_firestore.dart';

class ElectionModel{

  String name;
  String Status;
  String Start_time;
  String End_time;
  String uid;
  ElectionModel({this.name,this.Status,this.Start_time,this.End_time,this.uid});

  Map<String, dynamic> toJson() =>{
    'name': name,
    'Status': Status,
    'Start_time': Start_time,
    'End_time': End_time,
    'uid': uid,
  };


  static ElectionModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ElectionModel(
        name: snapshot['name'],
        Status: snapshot['Status'],
        Start_time: snapshot['Start_time'],
        uid: snapshot['uid'],
    );
  }

}