import 'package:cloud_firestore/cloud_firestore.dart';

class Admin {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String secretKey;

  const Admin({
    this.email,
    this.username,
    this.secretKey,
    this.photoUrl,
    this.uid,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "secretKey": secretKey,
      };

  static Admin fromSnap(DocumentSnapshot snap) {

    var snapshot = snap.data() as Map<String, dynamic>;


    return Admin(
        username: snapshot["username"],
        uid: snapshot["uid"],
        email: snapshot["email"],
        photoUrl: snapshot["photoUrl"],
        secretKey: snapshot["secretKey"],
    );
  }
}
