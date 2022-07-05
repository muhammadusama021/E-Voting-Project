import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_voting_admin_panel/widgets/text_input_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../resources/firestore_methods.dart';
import '../utils/colors.dart';

class DisplayAllUsers extends StatefulWidget {
  const DisplayAllUsers({Key key}) : super(key: key);

  @override
  _DisplayAllUsersState createState() => _DisplayAllUsersState();
}

class _DisplayAllUsersState extends State<DisplayAllUsers> {
  bool _isLoading = true;
  TextEditingController banMessage = TextEditingController();
  FocusNode banFocus = FocusNode();

  displaySingleUserDialog(
      BuildContext context, Map<String, dynamic> singleUser) {
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
            // padding: EdgeInsets.all(20),
            child: Center(
              child: Stack(clipBehavior: Clip.none, children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.30,

                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 15),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 7,
                        ),
                        DefaultTextStyle(
                          style: GoogleFonts.titilliumWeb(
                              fontSize: 19,
                              fontWeight: FontWeight.w400,
                              color: greyBlack),
                          child: Text("Name: "+
                            singleUser["name"],
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        DefaultTextStyle(
                          style: GoogleFonts.titilliumWeb(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: greyBlack),
                          child: Text("Email: "+
                            singleUser["email"],
                          ),
                        ),

                        SizedBox(
                          height: 7,
                        ),
                        DefaultTextStyle(
                          style: GoogleFonts.titilliumWeb(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: greyBlack),
                          child: Text("Phone No: "+
                            singleUser["phoneNo"],
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        DefaultTextStyle(
                          style: GoogleFonts.titilliumWeb(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: greyBlack),
                          child: Text("Postal Address: "+
                            singleUser["postalAddress"],
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        DefaultTextStyle(
                          style: GoogleFonts.titilliumWeb(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: greyBlack),
                          child: Text("Parmanent Address: "+
                            singleUser["permanentAddress"],
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "OK",
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

  showDeleteAlert(BuildContext context, String uid) {
    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete the User'),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
          child: Column(
            children: [
              Text('Are you sure you want to Delete this User from App?'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              FireStoreMethods().deleteUsers(uid);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    banMessage.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').where('Status',isEqualTo: "VOTER").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
            margin: EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width * 0.76,
            height: MediaQuery.of(context).size.height * 0.78,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: purplish,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: IconButton(
                        icon: Icon(Icons.refresh, color: primaryColor),
                        onPressed: () {
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  decoration: BoxDecoration(
                    color: purplish,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4,
                          spreadRadius: 4)
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        width: MediaQuery.of(context).size.width * 0.04,
                        child: Text(
                          "ID",
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 18, fontWeight: FontWeight.w600,color: Colors.white),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.18,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "Name",
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 18, fontWeight: FontWeight.w600,color: Colors.white),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.20,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "Email",
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 18, fontWeight: FontWeight.w600,color: Colors.white),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.10,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "Status",
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 18, fontWeight: FontWeight.w600,color: Colors.white),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.08,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "Delete",
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 18, fontWeight: FontWeight.w600,color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.07,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "Details",
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 18, fontWeight: FontWeight.w600,color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, position) {
                        return Container(
                          margin: EdgeInsets.all(8),
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 4,
                                  spreadRadius: 4)
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                width: MediaQuery.of(context).size.width * 0.04,
                                child: Text(
                                  (position + 1).toString(),
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.18,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  snapshot.data.docs[position].data()["name"],
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.20,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  snapshot.data.docs[position].data()["email"],
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.10,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  snapshot.data.docs[position].data()["Status"],
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.08,
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                child: IconButton(
                                  icon: Icon(Icons.report_off),
                                  onPressed: () {
                                    showDeleteAlert(
                                        context,
                                        snapshot.data.docs[position]
                                            .data()["uid"]);
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                width: MediaQuery.of(context).size.width * 0.07,
                                child: IconButton(
                                  icon: Icon(Icons.more_horiz),
                                  onPressed: () {
                                    displaySingleUserDialog(context,
                                        snapshot.data.docs[position].data());
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
          );
        });
  }
}
