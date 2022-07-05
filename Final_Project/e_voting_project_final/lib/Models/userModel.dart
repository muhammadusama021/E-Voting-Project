class UserModel{
  String uid;
  String name;
  String email;
  String phoneNo;
  String password;
  UserModel({this.uid,this.name,this.email,this.phoneNo});

  //data from server
factory UserModel.fromMap(map)
{
  return UserModel(
    uid: map['uid'],
    name: map['name'],
    email: map['email'],
    phoneNo: map['phoneNo'],


  );
}

// sending data to server
Map<String, dynamic> toMap()
{
  return
      {
        'uid': uid,
        'name': name,
        'email': email,
        'phoneNo':phoneNo,

      };
}
}
class completeVoterProfile{
  String Status;
  String uid;
  String nodeID;
  String name;
  String email;
  String phoneNo;
  String regNo;
  String depart;
  String CNIC;
  String permanentAddress;
  String postalAddress;
  completeVoterProfile({this.uid,this.nodeID,this.name,this.email,this.phoneNo,this.Status,this.regNo,this.depart,this.permanentAddress,this.postalAddress});

  //data from server
  factory completeVoterProfile.fromMap(map)
  {
    return completeVoterProfile(
      uid: map['uid'],
      nodeID: map['nodeID'],
      name: map['name'],
      email: map['email'],
      phoneNo: map['phoneNo'],
      Status: map['Status'],
      regNo: map['regNo'],
      depart: map['depart'],
      permanentAddress: map['permanentAddress'],
      postalAddress: map['postalAddress'],


    );
  }
// sending data to server
  Map<String, dynamic> toMap()
  {
    return
      {
        'uid': uid,
        'nodeID':nodeID,
        'name': name,
        'email': email,
        'phoneNo':phoneNo,
        'Status': Status,
        'regNo': regNo,
        'depart': depart,
        'permanentAddress':permanentAddress,
        'postalAddress':postalAddress,

      };
  }


}
class completeOrganizerProfile{
  String uid;
  String nodeID;
  String name;
  String email;
  String phoneNo;
  String Status;
  String organization;
  String CNIC;
  String permanentAddress;
  String postalAddress;
  completeOrganizerProfile({this.uid,this.nodeID,this.name,this.email,this.phoneNo,this.Status,this.CNIC,this.organization,this.permanentAddress,this.postalAddress});

  factory completeOrganizerProfile.fromMap(map)
  {
    return completeOrganizerProfile(
      uid: map['uid'],
      nodeID: map['nodeID'],
      name: map['name'],
      email: map['email'],
      phoneNo: map['phoneNo'],
      Status: map['Status'],
      CNIC: map['CNIC'],
      organization: map['organization'],
      permanentAddress: map['permanentAddress'],
      postalAddress: map['postalAddress'],


    );
  }
// sending data to server
  Map<String, dynamic> toMap()
  {
    return
      {
        'uid': uid,
        'nodeID': nodeID,
        'name': name,
        'email': email,
        'phoneNo':phoneNo,
        'Status': Status,
        'CNIC': CNIC,
        'organization': organization,
        'permanentAddress':permanentAddress,
        'postalAddress':postalAddress,

      };
  }


}