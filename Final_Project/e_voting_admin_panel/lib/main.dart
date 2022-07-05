import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:e_voting_admin_panel/admin/admin_dashboard_page.dart';
import 'package:e_voting_admin_panel/auth/login_page.dart';

import 'auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDhO_qOmqzrCSqm6G0DptYQYDuZey8bjt4",
        authDomain: "myflutterauth-e56ae.firebaseapp.com",
        appId: "1:332799740321:web:85301d70730389f3db63e0",
        messagingSenderId: "332799740321",
        projectId: "myflutterauth-e56ae",
        storageBucket: "myflutterauth-e56ae.appspot.com",

        ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Voting Admin Panel',
      home: LoginPage(),
    );
  }
}
