import 'package:e_voting_admin_panel/resources/firestore_methods.dart';
import 'package:e_voting_admin_panel/utils/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:table_calendar/table_calendar.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage>
    with TickerProviderStateMixin {
  // Example holidays
  final Map<DateTime, List> _holidays = {
    DateTime(2020, 1, 1): ['New Year\'s Day'],
    DateTime(2020, 1, 6): ['Epiphany'],
    DateTime(2020, 2, 14): ['Valentine\'s Day'],
    DateTime(2020, 4, 21): ['Easter Sunday'],
    DateTime(2020, 4, 22): ['Easter Monday'],
  };
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();

    _events = {
      _selectedDay.subtract(Duration(days: 30)): [
        'Event A0',
        'Event B0',
        'Event C0'
      ],
      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
      _selectedDay.subtract(Duration(days: 20)): [
        'Event A2',
        'Event B2',
        'Event C2',
        'Event D2'
      ],
      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
      _selectedDay.subtract(Duration(days: 10)): [
        'Event A4',
        'Event B4',
        'Event C4'
      ],
      _selectedDay.subtract(Duration(days: 4)): [
        'Event A5',
        'Event B5',
        'Event C5'
      ],
      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      _selectedDay.add(Duration(days: 1)): [
        'Event A8',
        'Event B8',
        'Event C8',
        'Event D8'
      ],
      _selectedDay.add(Duration(days: 3)):
          Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
      _selectedDay.add(Duration(days: 7)): [
        'Event A10',
        'Event B10',
        'Event C10'
      ],
      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
      _selectedDay.add(Duration(days: 17)): [
        'Event A12',
        'Event B12',
        'Event C12',
        'Event D12'
      ],
      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
      _selectedDay.add(Duration(days: 26)): [
        'Event A14',
        'Event B14',
        'Event C14'
      ],
    };

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  getHomePageData() async {
    Map<String, dynamic> data =
        await FireStoreMethods().getAdminDashBoardData();
    return data;
  }

  Future<bool> approveRequest({String uid}) async {
    String result = await FireStoreMethods().approveOrganizer(uid);
    if (result == "success") {
      return true;
    } else {
      return false;
    }
  }

  displaySingleDialog(BuildContext context, Map<String, dynamic> singleUser) {
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
                  width: MediaQuery.of(context).size.width * 0.30,

                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 15),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /*CircleAvatar(
                          radius: 32,
                          backgroundImage: NetworkImage(singleUser["photoUrl"]),
                        ),*/
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
                          child: Text("CNIC No : "+
                              singleUser["CNIC"],
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
                          child: Text("Permanent Address: "+
                            singleUser["permanentAddress"],
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),

                        // DefaultTextStyle(
                        //   style: GoogleFonts.titilliumWeb(
                        //       fontSize: 19,
                        //       fontWeight: FontWeight.w400,
                        //       color: greyBlack),
                        //   child: Text(
                        //     'What do you want to do with ${singleUser["username"]} request?',
                        //   ),
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                bool result = await approveRequest(
                                    uid: singleUser["uid"]);
                                if (result) {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    getHomePageData();
                                  });
                                }
                              },
                              child: Text(
                                "Approve",
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
                                "Decline",
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

  displayApprovalDialog(BuildContext context, Map<String, dynamic> singleUser) {
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
                          'What do you want to do with ${singleUser["name"].toString().toUpperCase()} request?',
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              bool result =
                                  await approveRequest(uid: singleUser["uid"]);
                              if (result) {
                                Navigator.of(context).pop();
                                setState(() {
                                  getHomePageData();
                                });
                              }
                            },
                            child: Text(
                              "Approve",
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
                              displaySingleDialog(context, singleUser);
                            },
                            child: Text(
                              "Check Details",
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getHomePageData(),
        builder: (BuildContext context, snap) {
          if (snap.hasData) {
            Map<String, dynamic> data = snap.data as Map<String, dynamic>;
            int userCount = data["userCount"];
            int psyCount = data["psyCount"];
            int elcCount = data["elcCount"];
            List psyData = data["psyList"];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 150,
                        height: 80,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [purplish, blueColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: -15,
                              left: -10,
                              child: Icon(
                                Icons.supervisor_account_sharp,
                                size: 74,
                                color: primaryColor.withOpacity(0.2),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, left: 30),
                              child: Text(
                                "$userCount",
                                style: GoogleFonts.titilliumWeb(
                                    fontSize: 28, color: primaryColor),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 40.0, left: 30),
                              child: Text(
                                "Voters",
                                style: GoogleFonts.titilliumWeb(
                                    fontSize: 20, color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 150,
                        height: 80,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [purplish, blueColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: -10,
                              left: -5,
                              child: Icon(
                                Icons.person_pin_outlined,
                                size: 66,
                                color: primaryColor.withOpacity(0.2),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, left: 30),
                              child: Text(
                                "$psyCount",
                                style: GoogleFonts.titilliumWeb(
                                    fontSize: 28, color: primaryColor),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 40.0, left: 30),
                              child: Text(
                                "Organizers",
                                style: GoogleFonts.titilliumWeb(
                                    fontSize: 20, color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 150,
                        height: 80,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [purplish, blueColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: -10,
                              left: -5,
                              child: Icon(
                                Icons.how_to_vote,
                                size: 66,
                                color: primaryColor.withOpacity(0.2),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(top: 5.0, left: 30),
                              child: Text(
                                "$elcCount",
                                style: GoogleFonts.titilliumWeb(
                                    fontSize: 28, color: primaryColor),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(top: 40.0, left: 30),
                              child: Text(
                                "Elections",
                                style: GoogleFonts.titilliumWeb(
                                    fontSize: 20, color: primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   width: 90,
                      //   height: 40,
                      //   color: Colors.yellow,
                      //   child: Text("Diamonds: 1000"),
                      // ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 15, left: 20),
                  child: Text(
                    "Notifications",
                    style: GoogleFonts.titilliumWeb(
                        fontSize: 24, fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        width: MediaQuery.of(context).size.width * 0.40,
                        height: MediaQuery.of(context).size.height * 0.51,
                        color: Colors.grey.shade200,
                        child: ListView.builder(
                          itemCount: psyData.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  displayApprovalDialog(
                                      context, psyData[index]);
                                },
                                title: Text(
                                  psyData[index]["name"].toString().toUpperCase(),
                                  style: GoogleFonts.titilliumWeb(fontSize: 17),
                                ),
                                subtitle: Text(
                                  "request pending for Organizer approval",
                                  style: GoogleFonts.titilliumWeb(fontSize: 14),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.30,
                        color: Colors.grey.shade200,
                        child: TableCalendar(
                          calendarController: _calendarController,
                          events: _events,
                          holidays: _holidays,
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          calendarStyle: CalendarStyle(
                            selectedColor: purplish,
                            todayColor: blueColor,
                            markersColor: Colors.brown[700],
                            outsideDaysVisible: false,
                          ),
                          headerStyle: HeaderStyle(
                            formatButtonTextStyle: TextStyle()
                                .copyWith(color: Colors.white, fontSize: 15.0),
                            formatButtonDecoration: BoxDecoration(
                              color:purplish,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          onDaySelected: _onDaySelected,
                          onVisibleDaysChanged: _onVisibleDaysChanged,
                          onCalendarCreated: _onCalendarCreated,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }
}
