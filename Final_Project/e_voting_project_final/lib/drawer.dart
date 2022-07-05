import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_voting_project_final/Pages/about.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:rounded_letter/rounded_letter.dart';


Widget createDrawer(BuildContext context) {
  final _auth = FirebaseAuth.instance;
  final database =Firestore.instance;
  String name;
  String email;
 _fetch() async
  {
      final FirebaseUser firebaseUser = await _auth.currentUser();
      if(firebaseUser != null)
        {
          await database.collection("Users").document(firebaseUser.uid).get().then((value)
          {
              name=value.data['name'];
              email=value.data['email'];
          }).catchError((e)
              {
                print(e);
              });
        }
  }
  navigateToPage(BuildContext context, String page) {
    Navigator.of(context).pushNamedAndRemoveUntil(page, (Route<dynamic> route) => false);
  }
  return ClipRRect(

      borderRadius: BorderRadius.vertical(

          top: Radius.circular(10.0), bottom: Radius.circular(10.0)),
      child: Drawer(
          child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
          FutureBuilder(
            future: _fetch(),
            builder: (context, snapshot)
            {
              if(snapshot.connectionState != ConnectionState.done)
                {
                  final userName ="$name".toUpperCase();
                  return new UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xff03c8a8),
                    ),

                    accountName: new Text("Loading data...",
                      style: TextStyle(
                          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                    accountEmail: new Text("Loading data..."),
                    currentAccountPicture: new CircleAvatar(
                      backgroundColor: Colors.white,
                      child: RoundedLetter.withGreenCircle('M', 65, 32),
                    ),
                  );
                }
              final userName ="$name".toUpperCase();
              return new UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xff03c8a8),
                ),

                accountName: new Text("$userName",
                  style: TextStyle(
                      color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                accountEmail: new Text("$email",style: TextStyle(color: Colors.white),),
                currentAccountPicture: new CircleAvatar(
                  backgroundColor: Colors.white,
                  child: RoundedLetter.withGreenCircle(userName[0], 65, 32),
                ),
              );

            },
          ),
          new ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.of(context).pop();
              }),

          Divider(thickness: 2,),
          ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                print("Pressed");
                navigateToPage(context, 'about');

                AboutPage();

              }),

         /* ListTile(
              leading: Icon(Icons.help),
              title: Text('Help & FAQs'),
              onTap: () {

              }),*/
          Divider(thickness: 2,),

          /*ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                showAlertDialog(context);

              }),*/

        ],
      )));
  return Drawer();
}
