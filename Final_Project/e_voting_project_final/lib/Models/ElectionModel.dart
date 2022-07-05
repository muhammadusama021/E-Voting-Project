import 'package:cloud_firestore/cloud_firestore.dart';

class ElectionModel{

  String name;
  String Status;
  String Start_time;
  String End_time;
  String uid;
  ElectionModel({this.name,this.Status,this.Start_time,this.End_time,this.uid});

  //data from server
  factory ElectionModel.fromMap(map)
  {
    return ElectionModel(

      name: map['name'],
      Status: map['Status'],
      Start_time: map['Start_time'],
      End_time: map['End_time'],
        uid: map['uid']
    );
  }
// sending data to server
  Map<String, dynamic> toMap()
  {
    return
      {
        'name': name,
        'Status': Status,
        'Start_time': Start_time,
        'End_time': End_time,
        'uid':uid,
      };
  }
}

class CandidateModel{
  String C_id;
  String C_name;
  String C_email;
  String C_phoneNo;
  String regNo;
  String depart;
  CandidateModel({this.C_id,this.C_name,this.C_email,this.C_phoneNo,this.regNo,this.depart});

  //data from server
  factory CandidateModel.fromMap(map)
  {
    return CandidateModel(
      C_id: map['uid'],
      C_name: map['name'],
      C_email: map['email'],
      C_phoneNo: map['phoneNo'],
        regNo: map['regNo'],
        depart: map['depart']

    );
  }

// sending data to server
  Map<String, dynamic> toMap()
  {
    return
      {
        'uid': C_id,
        'name': C_name,
        'email': C_email,
        'phoneNo':C_phoneNo,
        'regNo': regNo,
        'depart': depart,


      };
  }
}