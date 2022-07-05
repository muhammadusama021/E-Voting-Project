import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
final _auth = FirebaseAuth.instance;
final database =Firestore.instance;
String name;
String email;
String phoneNo;
String RegNo;
class Fetch
{
 void _fetch() async
  {
    final FirebaseUser firebaseUser = await _auth.currentUser();
    if(firebaseUser != null)
    {
      await database.collection("Users").document(firebaseUser.uid).get().then((value)
      {
        name=value.data['name'];
        email=value.data['email'];
        phoneNo=value.data['phoneNo'];
        RegNo=value.data['regNo'];
      }).catchError((e)
      {
        print(e);
      });
    }
  }
}

