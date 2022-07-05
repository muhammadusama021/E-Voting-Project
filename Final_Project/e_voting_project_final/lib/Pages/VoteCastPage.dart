import 'package:ars_progress_dialog/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:e_voting_project_final/Pages/savePdf.dart';
import 'package:e_voting_project_final/services/contract_linking.dart';
import 'package:e_voting_project_final/widgets/small_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:e_voting_project_final/Pages/resources.dart';
import 'package:intl/intl.dart';
import 'package:rounded_letter/rounded_letter.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class VoteCastPage extends StatefulWidget {
  final String private;
  final String public;
  final Map Data;
  static const String routeName = '/votecast';

  const VoteCastPage({Key key, this.private, this.public, this.Data})
      : super(key: key);

  @override
  _ExpansionTileCardDemoState createState() => _ExpansionTileCardDemoState();
}

class _ExpansionTileCardDemoState extends State<VoteCastPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int _selectedIndex = 0;

  List<Widget> list = [
    Tab(
        child: Text('Cast your Vote Now!',
            style: TextStyle(color: Colors.white, fontSize: 16))),
  ];

  @override
  void initState() {
    _fetch();
    _fetch_panel();
    // TODO: implement initState
    _refreshData();

    super.initState();

    // Create TabController for getting the index of current tab
    _controller = TabController(length: list.length, vsync: this);

    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
    });
  }

  bool _expanded = false;

  Color colorGreen = Color(0xff03c8a8);
  Color colorGrey = Colors.grey;
  double textSize = 16;

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  );
  final roundShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10)),
  );

  //final image = [Image.asset('assets/images/mypic.jpg'),Image.asset('assets/images/APPICON56.png'),
  //Image.asset('assets/images/mypic.jpg'), Image.asset('assets/images/APPICON1.png')];

  final database = Firestore.instance;
  String name;
  String candidate_name;

  String candidate_email;
  String candidate_phoneNo;
  String candidate_RegNo;
  String candidate_depart;
  var Type_identifier = new Map();
  var C_identifier = new Map();
  var candidates_list = [];
  var candidates_data = [];
  var Candidate_identifier = new Map();

  String P_name;
  String P_id;
  String P_candidate_name;
  var Panel_identifier = new Map();
  var panel_list = [];
  var panel_data = [];
  var candidate_keys = [];
  var panel_keys = [];
  var mylist = [];
  String status;
  String start_time;
  String end_time;
  String p_status;
  var TimeList = [];

  DateTime S_time;
  DateTime E_time;
  var _list = [];
  var P_candidate_identifier = new Map();

  Future<void> _fetch() async {
    QuerySnapshot _myDoc =
        await Firestore.instance.collection('ElectionData').getDocuments();
    List<DocumentSnapshot> _myDocCount = _myDoc.documents;
    for (var item in _myDocCount) {
      await database
          .collection("ElectionData")
          .document(item.documentID)
          .get()
          .then((value) {
        name = value.data['name'];
        status = value.data['Status'];

        start_time = value.data['Start_time'];
        S_time = new DateFormat("dd-MM-yyyy HH:mm").parse(start_time);

        end_time = value.data['End_time'];
        E_time = new DateFormat("dd-MM-yyyy HH:mm").parse(end_time);

        final difference = E_time.difference(DateTime.now()).inSeconds;
        final starting_diff = S_time.difference(DateTime.now()).inSeconds;
        TimeList.add(name);
        TimeList.add(starting_diff);
        TimeList.add(difference);
        candidate_keys.add(item.documentID);
        candidate_keys.add(name);
        candidate_keys.add(status);
        candidate_keys.add(difference);

        Type_identifier[item.documentID] = name;
      }).catchError((e) {
        print(e);
      });

      QuerySnapshot _mycandidateDoc = await Firestore.instance
          .collection('ElectionData')
          .document(item.documentID)
          .collection('Candidates')
          .getDocuments();
      List<DocumentSnapshot> _candidateCount = _mycandidateDoc.documents;
      for (var item2 in _candidateCount) {
        await database
            .collection("ElectionData")
            .document(item.documentID)
            .collection('Candidates')
            .document(item2.documentID)
            .get()
            .then((value) {
          candidate_name = value.data['name'];
          candidates_data.add(candidate_name);
          candidate_email = value.data['email'];
          candidates_data.add(candidate_email);
          candidate_phoneNo = value.data['phoneNo'];
          candidates_data.add(candidate_phoneNo);
          candidate_RegNo = value.data['regNo'];
          candidates_data.add(candidate_RegNo);
          candidate_depart = value.data['depart'];
          candidates_data.add(candidate_depart);
          candidate_name = candidate_name.replaceFirst(
              candidate_name[0], candidate_name[0].toUpperCase());
          candidates_list.add(candidate_name);
          candidates_list.add(item2.documentID);

          candidates_list = [];
          candidate_name = candidate_name + "/" + item2.documentID;
          mylist.add(candidate_name);

          C_identifier[item2.documentID] = candidate_name;
          candidates_data = [];
        }).catchError((e) {
          print(e);
        });
      }
      Candidate_identifier[candidate_keys] = mylist;
      C_identifier = {};
      mylist = [];
      candidate_keys = [];
    }
    //print(Candidate_identifier);
  }

  Future<void> _fetch_panel() async {
    QuerySnapshot _myDoc =
        await Firestore.instance.collection('PanelData').getDocuments();
    List<DocumentSnapshot> _myPanelCount = _myDoc.documents;
    for (var item in _myPanelCount) {
      await database
          .collection("PanelData")
          .document(item.documentID)
          .get()
          .then((value) {
        P_name = value.data['name'];

        Panel_identifier[item.documentID] = P_name;
        status = value.data['Status'];
        start_time = value.data['Start_time'];
        S_time = new DateFormat("dd-MM-yyyy HH:mm").parse(start_time);
        end_time = value.data['End_time'];
        E_time = new DateFormat("dd-MM-yyyy HH:mm").parse(end_time);
        final difference2 = E_time.difference(DateTime.now()).inSeconds;
        panel_keys.add(item.documentID);
        panel_keys.add(P_name);
        panel_keys.add(status);
        panel_keys.add(difference2);
      }).catchError((e) {
        print(e);
      });

      QuerySnapshot _myPanel_candidateDoc = await Firestore.instance
          .collection('PanelData')
          .document(item.documentID)
          .collection('Candidates')
          .getDocuments();
      List<DocumentSnapshot> _candidate_Count = _myPanel_candidateDoc.documents;
      for (var item2 in _candidate_Count) {
        await database
            .collection("PanelData")
            .document(item.documentID)
            .collection('Candidates')
            .document(item2.documentID)
            .get()
            .then((value) {
          P_candidate_name = value.data['name'];
          panel_data.add(candidate_name);

          P_candidate_name = P_candidate_name.replaceFirst(
              P_candidate_name[0], P_candidate_name[0].toUpperCase());
          panel_list.add(P_candidate_name);

          Panel_identifier[item2.documentID] = panel_data;
          panel_data = [];
        }).catchError((e) {
          print(e);
        });
      }
      P_candidate_identifier[panel_keys] = panel_list;
      panel_keys = [];

      panel_list = [];
    }
    //print(P_candidate_identifier);
  }

  @override
  @override
  Widget build(BuildContext context) {
    var contractLink = Provider.of<ContractLinking>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'VoteCast',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kmainColor,
        bottom: TabBar(
          indicatorWeight: 8,
          indicatorColor: Colors.white,
          controller: _controller,
          tabs: list,
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  contractLink.initialSetup();
                },
                child: Icon(
                  Icons.refresh,
                ),
              )),
        ],
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          FutureBuilder(
            future: _fetch(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Container(
                  /*width: _width/1-20,
                              height: _height/1.4-20,*/
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return new RefreshIndicator(
                child: Center(
                  child: contractLink.isLoading
                      ? CircularProgressIndicator()
                      : Container(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 5),
                            children: [
                              if (TimeList.isEmpty) ...{
                                Card(
                                    elevation: 5,
                                    child: Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Center(
                                        child: Text(
                                            "Curently! No Election Opened"),
                                      ),
                                    )),
                              } else ...{
                                CustomTimer(
                                  from: Duration(seconds: TimeList[1]),
                                  to: Duration(seconds: 0),
                                  onBuildAction: CustomTimerAction.auto_start,
                                  builder:
                                      (CustomTimerRemainingTime remaining) {
                                    if (int.parse("${remaining.seconds}") >=
                                        1) {
                                      return Card(
                                        elevation: 5,
                                        child: Padding(padding: EdgeInsets.all(15),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                if (int.parse(
                                                        "${remaining.days}") >=
                                                    1) ...[
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "Voting for " +
                                                            TimeList[0] +
                                                            " Start in :",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: colorGreen),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {},
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "${remaining.days} days ${remaining.hours} hours",
                                                        style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: colorGrey,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ] else if (int.parse(
                                                            "${remaining.hours}") >
                                                        1 &&
                                                    int.parse(
                                                            "${remaining.hours}") <=
                                                        24) ...[
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "Voting for " +
                                                            TimeList[0] +
                                                            " Start in :",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: colorGreen),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {},
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "${remaining.hours}:${remaining.minutes} minutes",
                                                        style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: colorGrey,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ] else if (int.parse(
                                                        "${remaining.minutes}") <
                                                    60) ...[
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "Voting for " +
                                                            TimeList[0] +
                                                            " Start in :",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: colorGreen),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {},
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "${remaining.minutes} min ${remaining.seconds} sec",
                                                        style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ]
                                              ],
                                            ),
                                            //   child:Text("${remaining.days} : ${remaining.hours}:${remaining.minutes}:${remaining.seconds} Remaining to Start Election"),
                                          ),
                                        ),
                                      );
                                    } else {
                                      if (contractLink
                                              .candidateVoteData.entries !=
                                          null) {
                                        for (var p in contractLink.candidateVoteData.entries) {
                                          return Column(
                                            children: [
                                              Card(
                                                elevation: 5,
                                                child: ExpansionTileCard(
                                                    title: Text(
                                                      "Voting for " + TimeList[0],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    subtitle: Column(
                                                      children: [

                                                            Row(
                                                              children: [
                                                                if (TimeList[2] > 0) ...[
                                                                  Expanded(
                                                                    child: Center(
                                                                      child:
                                                                      CustomTimer(
                                                                        from: Duration(seconds: TimeList[2]),
                                                                        to: Duration(seconds: 0),
                                                                        onBuildAction: CustomTimerAction.auto_start,
                                                                        builder: (CustomTimerRemainingTime remaining) {
                                                                          if (int.parse("${remaining.seconds}") >=1)
                                                                          {
                                                                            return
                                                                              Row(
                                                                                children: [
                                                                                  if (int.parse("${remaining.days}") >=
                                                                                      1) ...[
                                                                                    Expanded(
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Text(
                                                                                          "Election Ends in :",
                                                                                          style: TextStyle(
                                                                                              fontSize: 12,
                                                                                              color: colorGreen),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    InkWell(
                                                                                      onTap: () {},
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Text(
                                                                                          "${remaining.days} days ${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                                                                                          style: TextStyle(
                                                                                              fontSize: 12,
                                                                                              color: colorGrey,
                                                                                              fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ]
                                                                                  else if (int.parse(
                                                                                      "${remaining.hours}") >
                                                                                      1 &&
                                                                                      int.parse("${remaining.hours}") <=
                                                                                          24) ...[
                                                                                    Expanded(
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Text(
                                                                                          "Election Ends in :",
                                                                                          style: TextStyle(
                                                                                              fontSize: 12,
                                                                                              color: colorGreen),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    InkWell(
                                                                                      onTap: () {},
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Text(
                                                                                          "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                                                                                          style: TextStyle(
                                                                                              fontSize: 12,
                                                                                              color: colorGrey,
                                                                                              fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ] else if (int.parse(
                                                                                      "${remaining.minutes}") <
                                                                                      60) ...[
                                                                                    Expanded(
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Text(
                                                                                          "Election Ends in :",
                                                                                          style: TextStyle(
                                                                                              fontSize: 12,
                                                                                              color: colorGreen),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    InkWell(
                                                                                      onTap: () {},
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Text(
                                                                                          "${remaining.minutes} min ${remaining.seconds} sec",
                                                                                          style: TextStyle(
                                                                                              fontSize: 12,
                                                                                              color: Colors.red,
                                                                                              fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ]
                                                                                ],
                                                                              );
                                                                          }
                                                                          else
                                                                          {
                                                                            return
                                                                              Row(
                                                                                children: [
                                                                                  if (int.parse("${remaining.days}") >=
                                                                                      1) ...[
                                                                                    Expanded(
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Text(
                                                                                          "Election Ends in :",
                                                                                          style: TextStyle(
                                                                                              fontSize: 12,
                                                                                              color: colorGreen),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    InkWell(
                                                                                      onTap: () {},
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Text(
                                                                                          "${remaining.days} days ${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                                                                                          style: TextStyle(
                                                                                              fontSize: 12,
                                                                                              color: colorGrey,
                                                                                              fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ]
                                                                                  else if (int.parse(
                                                                                      "${remaining.hours}") >
                                                                                      1 &&
                                                                                      int.parse("${remaining.hours}") <=
                                                                                          24) ...[
                                                                                    Expanded(
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Text(
                                                                                          "Election Ends in :",
                                                                                          style: TextStyle(
                                                                                              fontSize: 12,
                                                                                              color: colorGreen),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    InkWell(
                                                                                      onTap: () {},
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Text(
                                                                                          "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                                                                                          style: TextStyle(
                                                                                              fontSize: 12,
                                                                                              color: colorGrey,
                                                                                              fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ] else if (int.parse(
                                                                                      "${remaining.minutes}") <
                                                                                      60) ...[
                                                                                    Expanded(
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Text(
                                                                                          "Election Ends in :",
                                                                                          style: TextStyle(
                                                                                              fontSize: 12,
                                                                                              color: colorGreen),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    InkWell(
                                                                                      onTap: () {},
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Text(
                                                                                          "${remaining.minutes} min ${remaining.seconds} sec",
                                                                                          style: TextStyle(
                                                                                              fontSize: 12,
                                                                                              color: Colors.red,
                                                                                              fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ]
                                                                                ],
                                                                              );
                                                                          }

                                                                        },
                                                                        onFinish: () {
                                                                          return Text("Kindly Update Time");
                                                                        },
                                                                      ),
                                                                    ),
                                                                  )
                                                                ] else ...[
                                                                  Expanded(
                                                                    child: Center(
                                                                      child: Row(
                                                                        children: [
                                                                          Expanded(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(5),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    "Election Time is Over",
                                                                                    style: TextStyle(
                                                                                        fontSize: 14, color: colorGreen),
                                                                                  ),
                                                                                ),
                                                                              )),

                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                ]
                                                              ],
                                                            ),
                                                            Row(
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                                  child: Text(
                                                                    "Election Status:  ",
                                                                    style: TextStyle(
                                                                        fontSize: 14,
                                                                        color:
                                                                        colorGreen),
                                                                  ),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () {},
                                                                child: Padding(
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                                  child: Text(
                                                                    contractLink
                                                                        .state,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        12,
                                                                        color:
                                                                        colorGrey,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),



                                                      ],
                                                    ),
                                                    leading: CircleAvatar(
                                                        child: RoundedLetter
                                                            .withRedCircle(
                                                                p.key[0]
                                                                    .toString(),
                                                                40,
                                                                20)),
                                                    children: [
                                                      for (var item in p.value) ...{
                                                        Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                50,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 30),
                                                            child: InkWell(
                                                              onTap: () {
                                                                //_openPopup(context, list, "", "");
                                                              },
                                                              child: Card(
                                                                elevation: 10,
                                                                child: ListTile(
                                                                  trailing:
                                                                      Container(
                                                                    child:
                                                                        ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                          primary:
                                                                              kmainColor),
                                                                      onPressed:
                                                                          () {
                                                                        if (contractLink.state !=
                                                                            "CONCLUDED") {
                                                                          showDialog(
                                                                            context:
                                                                                context,
                                                                            barrierDismissible:
                                                                                false, // user must tap button!
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return
                                                                                AlertDialog(
                                                                                title: Text('Confirmation!'),
                                                                                content: SingleChildScrollView(
                                                                                  child: Column(
                                                                                    children: <Widget>[
                                                                                      Small_Text(
                                                                                        text: 'Are you sure you want to vote Mr. ' + item.toString().split("/")[1],
                                                                                        size: 14,
                                                                                        color: kmainColor,
                                                                                      ),
                                                                                      SizedBox(height: 10),
                                                                                      Small_Text(
                                                                                        text: 'After Click on Confirm Button You Cant Change Your Vote.',
                                                                                        size: 12,
                                                                                        color: Colors.grey,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                actions: <Widget>[
                                                                                  Padding(
                                                                                    padding: EdgeInsets.only(left: 20, right: 20),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        ElevatedButton(
                                                                                          child: Small_Text(
                                                                                            text: 'Cancel',
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                          style: ButtonStyle(
                                                                                            backgroundColor: MaterialStateProperty.all(Colors.red),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(width: 50),
                                                                                        ElevatedButton(
                                                                                          style: ButtonStyle(
                                                                                            backgroundColor: MaterialStateProperty.all(kmainColor),
                                                                                          ),
                                                                                          child: Small_Text(
                                                                                            text: 'Confirm',
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                          onPressed: () async {

                                                                                            bool voted=await contractLink.Vote(item.toString().split("/")[0].toString(), widget.public.toString());
                                                                                            print(voted);
                                                                                            bool add=await contractLink.getvoterProfile(widget.public.toString());
                                                                                            print("Add+>====>");
                                                                                            print(add);
                                                                                            if(voted && add){
                                                                                              //Create a new PDF document with conformance A1B.
                                                                                              PdfDocument document =
                                                                                              PdfDocument();
//Add page to the PDF.
                                                                                              final PdfPage page = document.pages.add();
//Get page client size.
                                                                                              final Size pageSize = page.getClientSize();
                                                                                              //Draw rectangle.
                                                                                              page.graphics.drawRectangle(
                                                                                                  bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
                                                                                                  pen: PdfPen(PdfColor(142, 170, 219, 255)));
//Read font file.
                                                                                              // List<int> fontData = await _readData('Roboto-Regular.ttf');
                                                                                              //Create a PDF true type font.
                                                                                              PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
                                                                                              PdfFont headerFont = PdfStandardFont(PdfFontFamily.helvetica, 30);
                                                                                              PdfFont footerFont = PdfStandardFont(PdfFontFamily.helvetica, 18);
                                                                                              PdfFont winFont = PdfStandardFont(PdfFontFamily.helvetica, 15);
                                                                                              PdfLayoutResult _drawHeader(PdfPage page, Size pageSize, PdfGrid grid,
                                                                                                  PdfFont contentFont, PdfFont headerFont, PdfFont footerFont) {
                                                                                                //Draw rectangle.
                                                                                                page.graphics.drawRectangle(
                                                                                                    brush: PdfSolidBrush(PdfColor(3, 200, 168, 255)),
                                                                                                    bounds: Rect.fromLTWH(0, 0, pageSize.width, 90));
                                                                                                //Draw string.
                                                                                                page.graphics.drawString('Thanks for Your Vote..', headerFont,
                                                                                                    brush: PdfBrushes.white,
                                                                                                    bounds: Rect.fromLTWH(25, 0, pageSize.width, 90),
                                                                                                    format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

                                                                                                final format = DateFormat("dd-MM-yyyy HH:mm");

                                                                                                final String invoiceNumber = 'Election ID: 2058557939\r\n\r\nDate: ' +
                                                                                                    format.format(DateTime.now());
                                                                                                final Size contentSize = contentFont.measureString(invoiceNumber);
                                                                                                String elcName=contractLink.electionName;
                                                                                                String totalcand=contractLink.candidateCount;
                                                                                                String totalvoter=contractLink.VoterCount;
                                                                                                String winName=contractLink.winnerName;
                                                                                                //String totalvoter=contractLink.VoterCount;
                                                                                                String address =
                                                                                                    'Election Name: Voting for $elcName\r\n\r\nTotal Candidates: $totalcand, \r\n\r\n';
                                                                                                PdfTextElement(text: invoiceNumber, font: contentFont).draw(
                                                                                                    page: page,
                                                                                                    bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
                                                                                                        contentSize.width + 30, pageSize.height - 120));



                                                                                                return PdfTextElement(text: address, font: contentFont).draw(
                                                                                                    page: page,
                                                                                                    bounds: Rect.fromLTWH(30, 120,
                                                                                                        pageSize.width - (contentSize.width + 30), pageSize.height - 120));
                                                                                              }

                                                                                              //Create PDF grid and return.
                                                                                              PdfGrid _getGrid(PdfFont contentFont) {
                                                                                                //Create a PDF grid.
                                                                                                final PdfGrid grid = PdfGrid();
                                                                                                //Specify the column count to the grid.
                                                                                                grid.columns.add(count: 5);
                                                                                                //Create the header row of the grid.
                                                                                                final PdfGridRow headerRow = grid.headers.add(1)[0];
                                                                                                //Set style.
                                                                                                headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(3, 200, 168));
                                                                                                headerRow.style.textBrush = PdfBrushes.white;
                                                                                                headerRow.cells[0].value = 'Voter Id';
                                                                                                headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
                                                                                                headerRow.cells[1].value = 'Voter Name';
                                                                                                headerRow.cells[1].stringFormat.alignment = PdfTextAlignment.center;
                                                                                                headerRow.cells[2].value = 'Reg No';
                                                                                                headerRow.cells[2].stringFormat.alignment = PdfTextAlignment.center;
                                                                                                headerRow.cells[3].value = 'Vote to';
                                                                                                headerRow.cells[3].stringFormat.alignment = PdfTextAlignment.center;
                                                                                                headerRow.cells[4].value = ' Date';
                                                                                                headerRow.cells[4].stringFormat.alignment = PdfTextAlignment.center;
                                                                                                final format = DateFormat("dd-MM-yyyy HH:mm");
                                                                                                for(var i in contractLink.SingleVoterRec.entries)
                                                                                                {
                                                                                                  for(var j in i.value)
                                                                                                  {
                                                                                                    _addProducts('V-00'+j.toString().split("/")[0], j.toString().split("/")[1], j.toString().split("/")[2],j.toString().split("/")[3],''+format.format(DateTime.now()), grid);
                                                                                                  }

                                                                                                }

                                                                                                final PdfPen whitePen = PdfPen(PdfColor.empty, width: 0.5);
                                                                                                PdfBorders borders = PdfBorders();
                                                                                                borders.all = PdfPen(PdfColor(142, 179, 219), width: 0.5);
                                                                                                ;
                                                                                                grid.rows.applyStyle(PdfGridCellStyle(borders: borders));
                                                                                                grid.columns[1].width = 130;
                                                                                                for (int i = 0; i < headerRow.cells.count; i++) {
                                                                                                  headerRow.cells[i].style.cellPadding =
                                                                                                      PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
                                                                                                  headerRow.cells[i].style.borders.all = whitePen;
                                                                                                }
                                                                                                for (int i = 0; i < grid.rows.count; i++) {
                                                                                                  final PdfGridRow row = grid.rows[i];
                                                                                                  if (i % 2 == 0) {
                                                                                                    row.style.backgroundBrush = PdfSolidBrush(PdfColor(217, 226, 243));
                                                                                                  }
                                                                                                  for (int j = 0; j < row.cells.count; j++) {
                                                                                                    final PdfGridCell cell = row.cells[j];
                                                                                                    cell.stringFormat.alignment = PdfTextAlignment.center;

                                                                                                    cell.style.cellPadding =
                                                                                                        PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
                                                                                                  }
                                                                                                }
                                                                                                //Set font
                                                                                                grid.style.font = contentFont;
                                                                                                return grid;
                                                                                              }

                                                                                              //Create and row for the grid.

                                                                                              final PdfGrid grid = _getGrid(contentFont);

                                                                                              //Draw the header section by creating text element.
                                                                                              final PdfLayoutResult result =
                                                                                              _drawHeader(page, pageSize, grid, contentFont, headerFont, footerFont);
                                                                                              //Draw grid.
                                                                                              _drawGrid(page, grid,result, contentFont);
                                                                                              //Add invoice footer.
                                                                                              _drawFooter(page, pageSize, contentFont);
                                                                                              //Save and dispose the document.
                                                                                              final List<int> bytes = document.save();
                                                                                              document.dispose();


                                                                                              saveAndLaunchFile(bytes, 'VoteRecord.pdf');
                                                                                            }
                                                                                            Navigator.of(context).pop();


                                                                                          },
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              );
                                                                            },
                                                                          );
                                                                        } else {
                                                                          _showMyDialog(
                                                                              "");
                                                                        }
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        "Vote",
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                          textStyle:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w900,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  title: Text(
                                                                    item
                                                                        .toString()
                                                                        .split(
                                                                            "/")[1],
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  subtitle: Text(item
                                                                      .toString()
                                                                      .split(
                                                                          "/")[2]),
                                                                  leading: CircleAvatar(
                                                                      child: RoundedLetter.withRedCircle(
                                                                          item.toString().split("/")[1]
                                                                              [
                                                                              0],
                                                                          40,
                                                                          20)),
                                                                ),
                                                              ),
                                                            )),
                                                      }
                                                    ]),
                                              ),
                                              Divider(
                                                thickness: 2,
                                                color: Colors.black87,
                                              )
                                            ],
                                          );
                                        }
                                      }

                                      return Text(TimeList[0].toString());
                                    }
                                  },
                                ),
                              },
                            ],
                          ),
                        ),
                ),
                onRefresh: _refreshData,
              );
            },
          ),
        ],
      ),
    );
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 5));
  }

  Future<void> _showMyDialog(String cName) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Small_Text(
                  text: 'Hey, You Cant Vote Right Know!. ',
                  size: 14,
                  color: kmainColor,
                ),
                SizedBox(height: 10),
                Small_Text(
                  text: 'Because the Election is Ended.',
                  size: 12,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kmainColor),
                  ),
                  child: Small_Text(
                    text: "OK",
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }

  showAlertDialog2(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 100,
      title: Text("Alert!!!"),
      content: Text("Currently Not Availiable!"),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  void _drawGrid(
      PdfPage page, PdfGrid grid,PdfLayoutResult result, PdfFont contentFont) {
    Rect totalPriceCellBounds;
    Rect quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };


    page.graphics.drawString('Voter Details:', contentFont,
        bounds: Rect.fromLTWH(
            14,
            result.bounds.bottom + 20,
            500,
            100));

    //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 35, 0, 0));
    //Draw grand total.
    /*page.graphics.drawString('Grand Total', contentFont,
        bounds: Rect.fromLTWH(
            quantityCellBounds.left,
            result.bounds.bottom + 10,
            quantityCellBounds.width,
            quantityCellBounds.height));
    page.graphics.drawString("Hy", contentFont,
        bounds: Rect.fromLTWH(
            totalPriceCellBounds.left,
            result.bounds.bottom + 10,
            totalPriceCellBounds.width,
            totalPriceCellBounds.height));*/
  }

  void _drawFooter(PdfPage page, Size pageSize, PdfFont contentFont) {
    final PdfPen linePen =
    PdfPen(PdfColor(142, 170, 219, 255), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    //Draw line.
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
        Offset(pageSize.width, pageSize.height - 100));
    const String footerContent =
        'Comsats University Islamabad .\r\n\r\nMain Kamra road, Attock,\r\n\r\nAny Questions? e_voting@cuiatk.edu.pk';
    //Added 30 as a margin for the layout.
    page.graphics.drawString(footerContent, contentFont,
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
  }
  void _addProducts(String voterId, String voterName, String regNo,
      String departName, String voteTo, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = voterId;
    row.cells[1].value = voterName;
    row.cells[2].value = regNo;
    row.cells[3].value = departName;
    row.cells[4].value = voteTo;
  }
}
