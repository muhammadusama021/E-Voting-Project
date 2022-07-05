import 'package:e_voting_admin_panel/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../utils/colors.dart';
import '../../widgets/button_widget.dart';
import '../admin_settings.dart';

class SideMenuAdmin extends StatefulWidget {
  final PageController pageController;
  const SideMenuAdmin({
    Key key,
    this.pageController,
  }) : super(key: key);

  @override
  State<SideMenuAdmin> createState() => _SideMenuAdminState();
}

class _SideMenuAdminState extends State<SideMenuAdmin> {
  void logOut() async {
    try {
      await FirebaseAuth.instance.signOut().then(
            (value) => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false),
      );
    } catch (err) {
      print(err);
    }
  }

  void adminSettings() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AdminSettings()),
            (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.20,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [purplish, blueColor]),
      ),
      child: Column(
        children: [
          SizedBox(height: 35,),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.20,
            height: 120,
            child: CircleAvatar(
              radius: 68,
              backgroundImage:
              ExactAssetImage("assets/vote2.png"),
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonWidget(
              onTap: () {
                widget.pageController.jumpToPage(0);
              },
              text: "Home",
              bgColor: purplish,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonWidget(
              onTap: () {
                widget.pageController.jumpToPage(1);
              },
              text: "Voters",
              bgColor: purplish,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonWidget(
              onTap: () {
                widget.pageController.jumpToPage(2);
              },
              text: "Organizers",
              bgColor: purplish,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonWidget(
              onTap: () {
                widget.pageController.jumpToPage(3);
              },
              text: "Elections",
              bgColor: purplish,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonWidget(
              onTap: () {
                displayApprovalDialog(context);
              },
              text: "Log Out",
              bgColor: purplish,
            ),
          ),
        ],
      ),
    );
  }
  displayApprovalDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54.withOpacity(0.5),
      /*transitionDuration: Duration(milliseconds: 500),*/
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
            // padding: EdgeInsets.all(20),
            child: Center(
              child: Stack(clipBehavior: Clip.none, children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.height * 0.20,
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 15),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DefaultTextStyle(
                        style: GoogleFonts.titilliumWeb(
                            fontSize: 19,
                            fontWeight: FontWeight.w400,
                            color: greyBlack),
                        child: Text(
                          'Are you sure you want to Logout?',
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              logOut();
                            },
                            child: Text(
                              "YES",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty
                                  .all(purplish),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "NO",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty
                                  .all(purplish),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -12,
                  right: -12,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      radius: 16.0,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.close, color: Colors.red),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
//
// class SideMenuAdmin extends StatefulWidget {
//
//   const SideMenuAdmin(
//       {Key? key, required this.pageController, required this.items})
//       : super(key: key);
//
//   @override
//   _SideMenuAdminState createState() => _SideMenuAdminState();
// }
//
// class _SideMenuAdminState extends State<SideMenuAdmin> {
//   navigateToHome() {
//     Navigator.of(context)
//         .push(MaterialPageRoute(builder: (context) => const DashBoardPage()));
//   }
//
//   navigateToUsers() {
//     Navigator.of(context)
//         .push(MaterialPageRoute(builder: (context) => const DisplayAllUsers()));
//   }
//
//   navigateToPsychiatrist() {
//     Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => const DisplayAllPsychiatrists()));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.20,
//       height: MediaQuery.of(context).size.height,
//       color: purplish,
//       child: Column(
//         children: [
//           Container(
//             alignment: Alignment.center,
//             width: MediaQuery.of(context).size.width * 0.20,
//             height: 160,
//             child: CircleAvatar(
//               radius: 44,
//               child: Image.asset(
//                 "assets/stressed.png",
//                 height: 60,
//                 width: 60,
//               ),
//               backgroundColor: primaryColor,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ButtonWidget(
//               onTap: () {
//                 widget.pageController.jumpToPage(0);
//               },
//               text: "Home",
//               bgColor: darkBlue,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ButtonWidget(
//               onTap: navigateToUsers,
//               text: "Users",
//               bgColor: darkBlue,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ButtonWidget(
//               onTap: () {
//                 widget.pageController.jumpToPage(1);
//               },
//               text: "Psychiatrist",
//               bgColor: darkBlue,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ButtonWidget(
//               onTap: () {
//                 print("Sign Out");
//               },
//               text: "Sign Out",
//               bgColor: darkBlue,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
