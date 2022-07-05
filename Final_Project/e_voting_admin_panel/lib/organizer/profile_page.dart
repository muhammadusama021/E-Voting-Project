import 'dart:typed_data';

import 'package:e_voting_admin_panel/auth/login_page.dart';
import 'package:e_voting_admin_panel/resources/auth_methods.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

import '../resources/local_app_methods.dart';
import '../utils/colors.dart';
import '../utils/global_varaibles.dart';

class ProfilePage extends StatefulWidget {
  final String message;
  const ProfilePage({Key key, this.message}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  PageController pageController;

  Color contactInfo;
  Color completedTask;
  Color suggestedTask;
  int _page = 0;
  var data;
  bool _uploaded = true;
  bool _isLoading = false;
  bool _firstPage = true;
  bool _lastPage = false;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    setState(() {
      contactInfo = darkpurplish;
      completedTask = secondaryColor;
      suggestedTask = secondaryColor;
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      _page = page;
      if (_page == 0) {
        _firstPage = true;
        _lastPage = false;
      }
      if (_page > 0 && _page < 2) {
        _firstPage = false;
        _lastPage = false;
      }
      if (_page == 2) {
        _firstPage = false;
        _lastPage = true;
      }
    });
    if (page == 0) {
      setState(() {
        contactInfo = darkpurplish;
        completedTask = secondaryColor;
        suggestedTask = secondaryColor;
      });
    }
    if (page == 1) {
      setState(() {
        contactInfo = secondaryColor;
        completedTask = secondaryColor;
        suggestedTask = darkpurplish;
      });
    }
    if (page == 2) {
      setState(() {
        contactInfo = secondaryColor;
        completedTask = blueColor;
        suggestedTask = secondaryColor;
      });
    }
  }

  Future<String> updateDocuments() async {
    try {
      Map<String, String> psyData = await LocalAppMethods().getPsyData();
      psyData["isVerified"] = "pending";
      //AuthMethods().updatePsychiatrist(psyData);
      print("mubaraka");
      LocalAppMethods().savePsyData({});
      return "success";
    } catch (err) {
      return "fail";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            AuthMethods().signOutPsy().then((value) {
              if (value) {
                AuthMethods().signOutPsy();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false);
              }
            });
          },
          child: Container(
            width: 105,
            padding: EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            color: blueColor,
            child: Row(
              children: [
                Icon(
                  Icons.logout,
                  size: 15,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "logout".toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.titilliumWeb(
                      fontSize: 15, color: primaryColor),
                ),
              ],
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: purplish,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.55,
          height: MediaQuery.of(context).size.height * 0.80,
          decoration: BoxDecoration(
            color: primaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.3),
                spreadRadius: 10,
                blurRadius: 6,
              ),
            ],
          ),
          child: _uploaded && widget.message == "not-verified"
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Complete the following Steps to get Selected as a Psychiatrist"
                            .toUpperCase(),
                        style: GoogleFonts.titilliumWeb(
                            fontSize: 22, color: darkpurplish),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              navigationTapped(0);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Contact Details",
                                    style: GoogleFonts.titilliumWeb(
                                        fontSize: 16, color: contactInfo),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 1,
                                    color: contactInfo,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          InkWell(
                            onTap: () {
                              navigationTapped(1);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Educational Background",
                                    style: GoogleFonts.titilliumWeb(
                                        fontSize: 16, color: suggestedTask),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 1,
                                    color: suggestedTask,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          InkWell(
                            onTap: () {
                              navigationTapped(2);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Upload Documents",
                                    style: GoogleFonts.titilliumWeb(
                                        fontSize: 16, color: completedTask),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 1,
                                    color: completedTask,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: PageView(
                          children: profileItems,
                          physics: const NeverScrollableScrollPhysics(),
                          controller: pageController,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _firstPage
                              ? Container(
                                  width: 94,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 11, vertical: 7),
                                  color: secondaryColor,
                                  child: Text(
                                    "Back".toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.titilliumWeb(
                                        fontSize: 15, color: primaryColor),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    navigationTapped(_page - 1);
                                  },
                                  child: Container(
                                    width: 94,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 11, vertical: 7),
                                    color: purplish,
                                    child: Text(
                                      "Back".toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.titilliumWeb(
                                          fontSize: 15, color: primaryColor),
                                    ),
                                  ),
                                ),
                          SizedBox(
                            width: 15,
                          ),
                          _lastPage
                              ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    updateDocuments().then((value) {
                                      if (value == "success") {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfilePage(
                                                        message: "pending")),
                                            (route) => false);
                                      } else {
                                        //show error message
                                      }
                                    });

                                    setState(() {
                                      _isLoading = true;
                                    });
                                  },
                                  child: Container(
                                    width: 94,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 11, vertical: 7),
                                    color: purplish,
                                    child: _isLoading
                                        ? Center(
                                            child: SizedBox(
                                                width: 22,
                                                height: 22,
                                                child:
                                                    CircularProgressIndicator(
                                                  backgroundColor: primaryColor,
                                                )),
                                          )
                                        : Text(
                                            "Done".toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.titilliumWeb(
                                                fontSize: 15,
                                                color: primaryColor),
                                          ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    navigationTapped(_page + 1);
                                  },
                                  child: Container(
                                    width: 94,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 11, vertical: 7),
                                    color: purplish,
                                    child: Text(
                                      "Next".toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.titilliumWeb(
                                          fontSize: 15, color: primaryColor),
                                    ),
                                  ),
                                ),
                        ],
                      )
                    ],
                  ),
                )
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Your request has been sent Successfully. You will informed Once it is Approved."
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.titilliumWeb(
                            fontSize: 22, color: darkpurplish),
                      ),
                      Text(
                        "For any issues or queries contact",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.titilliumWeb(
                            fontSize: 16, color: greyBlack),
                      ),
                      Text(
                        "zeeshan922837@gmail.com",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.titilliumWeb(
                            fontSize: 15,
                            color: darkpurplish,
                            fontStyle: FontStyle.italic),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          AuthMethods().signOutPsy().then((value) {
                            if (value) {
                              AuthMethods().signOutPsy();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                  (route) => false);
                            }
                          });
                        },
                        child: Container(
                          width: 105,
                          padding:
                              EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                          color: purplish,
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout,
                                size: 15,
                                color: primaryColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "logout".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.titilliumWeb(
                                    fontSize: 15, color: primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
