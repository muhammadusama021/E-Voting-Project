import 'package:e_voting_admin_panel/election/displayAllElections.dart';
import 'package:e_voting_admin_panel/organizer/display_all_organizers.dart';

import 'package:e_voting_admin_panel/organizer/widgets/contact-details.dart';
import 'package:e_voting_admin_panel/organizer/widgets/document-upload.dart';
import 'package:e_voting_admin_panel/organizer/widgets/educational-details.dart';
import 'package:flutter/material.dart';
import 'package:e_voting_admin_panel/admin/admin_homepage.dart';
import 'package:e_voting_admin_panel/admin/admin_settings.dart';


import 'package:e_voting_admin_panel/users/display_all_users_page.dart';



const dashboardItemsAdmin = [
  AdminHomePage(),
  DisplayAllUsers(),
  DisplayAllOrganizers(),
  DisplayAllElections(),
  Text("Notifications"),
  AdminSettings()
];

const dashboardItemsPsy = [

  Text("Task"),
  Text("Notifications"),
  Text("Settings")
];

const profileItems = [
  ContactDetails(),
  EducationalDetails(),

];

displayDialog(BuildContext context, String message) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black54.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 500),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: animation,
          child: child,
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(20),
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  message,
                  style: TextStyle(color: Colors.red, fontSize: 20.0),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "DISMISS",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
