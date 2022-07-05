import 'package:e_voting_project_final/services/contract_linking.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform, exit;
import 'package:ars_progress_dialog/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:e_voting_project_final/Pages/resultPage.dart';
import 'package:e_voting_project_final/ui/signin.dart';
import 'package:e_voting_project_final/utils/dimensions.dart';
import 'package:e_voting_project_final/widgets/big_text.dart';
import 'package:e_voting_project_final/widgets/icon_with_text_widget.dart';
import 'package:e_voting_project_final/widgets/small_text.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import '../AddElection.dart';
import '../drawer.dart';

import 'VoteCastPage.dart';
import 'resources.dart';

import 'candidatePage.dart';
import 'userProfilePage.dart';

import 'routes.dart';

class TransactionView extends StatefulWidget {
  static const String routeName = '/Dashboard';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<TransactionView> {
  @override

  String deployedName;
  String amount;
  final database = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  String name;
  String email;
  String phoneNo;
  String RegNo;
  String Status;
  String addres;
  String public;
  String private;
  static List<Users> _users = [];
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

  DateTime S_time;
  DateTime E_time;

  _fetch() async {
    final FirebaseUser firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      await database
          .collection("Users")
          .document(firebaseUser.uid)
          .get()
          .then((value) {
        name = value.data['name'];
        name = name[0].toUpperCase()+name.substring(1);
        addres = value.data['nodeID'];
        email = value.data['email'];
        phoneNo = value.data['phoneNo'];
        RegNo = value.data['regNo'];
        Status = value.data['Status'];
        RegNo = RegNo.toUpperCase();
      }).catchError((e) {
        print(e);
      });
      await database
          .collection("Blockchain")
          .document(addres)
          .get()
          .then((value) {
        public = value.data['address'];
        private = value.data['private'];
      });
      //getCredentials();
 }}

  String name1;
  String blockID;
  String status1;
  String pub_address;
  var dropDown = new Map();
String reg;
  _fetchAdress() async
  {
    QuerySnapshot _myDoc = await Firestore.instance.collection('Users').getDocuments();
    List<DocumentSnapshot> _myDocCount = _myDoc.documents;
    for (var item in _myDocCount)
    {
      await database.collection("Users").document(item.documentID).get().then((value)
      {
        status1=value.data['Status'];
        if(status1!="ORGANIZER")
        {
          name1=value.data['name'];
          reg=value.data['regNo'];
          name1=name1[0].toUpperCase()+name1.substring(1)+"/"+reg;

          blockID=value.data['nodeID'];
          print("Block ID:"+blockID);
          database
              .collection("Blockchain")
              .document(blockID)
              .get()
              .then((value) {
            pub_address = value.data['address'];
            _users.add(Users(id:pub_address.trim().toString(),name: name1));
            dropDown['$pub_address']=name1;
              });

        }

      }).catchError((e)
      {
        print(e);
      });

    }

    print(dropDown);

  }

  @override
  void initState() {
    // TODO: implement initState
    _fetchAdress();
    _fetch();

    super.initState();
  }
  /*Future<void> getCredentials() async {
    _credentials = await _client.credentialsFromPrivateKey(private);
    EthereumAddress address = await _credentials.extractAddress();
    print("Done==>"+address.toString());
    EtherAmount eth = await _client.getBalance(address);
    print(address);
    print(eth.getInEther);
    amount = eth.getInEther.toString();
    return amount;

  }*/


  static const String routeName = '/transaction';
  final roundShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(15),
        bottomLeft: Radius.circular(15),
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15)),
  );

  Widget _Slider() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff03c8a8),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(Dimensions.radius30),
            bottomRight: Radius.circular(Dimensions.radius30)),
      ),
      padding: EdgeInsets.symmetric(vertical: Dimensions.height20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

              return new Column(children: [
                Container(
                  child: Card(
                    elevation: 10,
                    shape: roundShape,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions.marginLeft20,
                                  top: Dimensions.marginTop10,
                                  bottom: Dimensions.marginBottom2),
                              child: Big_Text(
                                text: "Online-Voting Portal",
                                letterspacing: 1.5,
                                color: kmainColor,
                                size: 14,
                              )),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: Dimensions.width30,
                                top: 0,
                                bottom: Dimensions.marginBottom2),
                            child: Small_Text(
                              text: "$name",
                              latterSpacing: 1,
                              size: 12,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: Dimensions.width30),
                            child: Small_Text(
                              text: "$phoneNo",
                              latterSpacing: 1,
                              size: 12,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: Dimensions.width30),
                            child: Small_Text(
                              text: "$Status",
                              latterSpacing: 1,
                              size: 12,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: Dimensions.width30),
                            child: Text(
                              "Public hash: $public",
                              overflow: TextOverflow.fade,
                              style: TextStyle(fontSize: 11),
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ]),
                      width: Dimensions.SliderContainerWidth,
                      height: Dimensions.SliderContainerHeight,
                    ),
                  ),
                ),
              ]);
            },
          ),
        ],
      ),
    );
  }




  Widget _Voter_cards(context) {
    //var contractLink = Provider.of<ContractLinking>(context);
    //ContractLinking cl=ContractLinking();
    //cl.getCredentials(private);
    return Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.symmetric(vertical: Dimensions.marginTop5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconWithText(
                        icon: Icons.how_to_vote,
                        round: roundShape,
                        text: "Vote Cast",
                        link: VoteCastPage(public: public,)),
                    IconWithText(
                        icon: Icons.supervised_user_circle,
                        round: roundShape,
                        text: "Candidates",
                        link: CandidatePage()),
                  ],
                ),
                Row(
                  children: [
                    IconWithText(
                        icon: Icons.receipt_sharp,
                        round: roundShape,
                        text: "Result",
                        link: ResultPage(status: Status,)),
                    IconWithText(
                        icon: Icons.recent_actors_outlined,
                        round: roundShape,
                        text: "Profile",
                        link: ProfilePage()),
                  ],
                ),
              ],
            ),
          ],
        ),
      );


  }

  Widget _Organizer_cards(context) {
    var contractLink = Provider.of<ContractLinking>(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.marginTop5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconWithText(
                        icon: Icons.how_to_vote,
                        round: roundShape,
                        text: "Vote Cast",
                        link: VoteCastPage(public: public,)),
                    IconWithText(
                        icon: Icons.supervised_user_circle,
                        round: roundShape,
                        text: "Candidates",
                        link: CandidatePage()),
                  ],
                ),
                Row(
                  children: [
                    IconWithText(
                        icon: Icons.receipt_sharp,
                        round: roundShape,
                        text: "Result",
                        link: ResultPage(status: Status,)),
                    IconWithText(
                        icon: Icons.recent_actors_outlined,
                        round: roundShape,
                        text: "Profile",
                        link: ProfilePage()),
                  ],
                ),
                Row(
                  children: [
                    IconWithText(
                        icon: Icons.add_to_photos_rounded,
                        round: roundShape,
                        text: "Add Panels",
                        link: AddElection(private : private,public :public,Data: dropDown,user: _users,)),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget not_Verified(context) {

    return AlertDialog(
        title: Text('Alert!'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Small_Text(
                text: 'Hy, $name , Your request is pending for Approval.',
                size: 14,
                color: kmainColor,
              ),
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Small_Text(
                      text: 'For Further Queries Please Contact!',
                      size: 12,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 20),
                    Small_Text(
                      text: 'muhammadusama008233@gmail.com.',
                      size: 11,
                      color: Colors.blue,
                    ),
                  ],
                )

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
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kmainColor),
                  ),
                  child: Small_Text(
                    text: 'LogOut',
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await _auth.signOut().then((value) => Navigator.of(context)
                        .pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => SignInPage()),
                            (route) => false));
                    Navigator.of(context).pop();


                  },
                ),
              ],
            ),
          )
        ],
      );

  }
  @override
  Widget build(BuildContext context) {
    Future<Widget> logout() async {
      await _auth.signOut().then((value) => Navigator.of(context)
          .pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => SignInPage()),
              (route) => false));
    }

    showAlertDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = TextButton(
        child: Text("CANCEL"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      Widget continueButton = TextButton(
        child: Text("YES"),
        onPressed: () {
          logout();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        elevation: 100,
        title: Text("Alert!!!"),
        content: Text("Are you sure, you want to LogOut!"),
        actions: [
          cancelButton,
          continueButton,
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

    void onBackPressed() {
      showAlertDialog(context);
    }

    showAlertDialog2(BuildContext context) {
      // set up the buttons
      Widget cancelButton = TextButton(
        child: Text("CANCEL"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      Widget continueButton = TextButton(
        child: Text("YES"),
        onPressed: () {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        elevation: 100,
        title: Text("Alert!!!"),
        content: Text("Are you sure, you want to Exit!"),
        actions: [
          cancelButton,
          continueButton,
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

    void onBackPressed2() {
      showAlertDialog2(context);
    }

    return WillPopScope(
      onWillPop: () async {
        onBackPressed2(); // Action to perform on back pressed
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          //colors: [Color(0xff03c8a8),Color(0xff89d8d3
          backgroundColor: Color(0xff03c8a8),
          title: const Text(
            'Dashboard',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            /*Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.notifications,
                  ),
                )),*/
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    showAlertDialog(context);
                  },
                  child: Icon(
                    Icons.logout,
                    //size: 26.0,
                  ),
                )),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xffd7e1ec), Color(0xffffffff)])),
            child: Column(
              children: <Widget>[
                _Slider(),
                SizedBox(
                  height: Dimensions.height10,
                ),
                FutureBuilder(
                    future: _fetch(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Container(
                          margin: EdgeInsets.only(
                              left: Dimensions.margin30,
                              right: Dimensions.margin30),
                          width: Dimensions.screenWidth / 1 - 20,
                          height: Dimensions.screenHeight / 1.5,
                          child: Center(
                              child: Card(
                            // ignore: missing_return
                            shape: roundShape,
                            color: Colors.white,

                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: CircularProgressIndicator(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: Dimensions.width30),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Big_Text(
                                        text: "Loading ...",
                                        color: kmainColor,
                                      ))
                                ],
                              ),
                            ),
                          )),
                        );
                      } else if ('$Status' == 'VOTER') {
                        return _Voter_cards(context);
                      } else if ('$Status' == 'ORGANIZER') {
                        return _Organizer_cards(context);
                      }
                      else if('$Status' == 'not-verified')
                        {
                          return not_Verified(context);
                        }
                    }),
              ],
            ),
          ),
        ),

        //bottomNavigationBar: BottomNavigation(),
        drawer: createDrawer(context),
      ),
    );
  }
}
class Users {
  String id;
  String name;

  Users({
    this.id,
    this.name,
  });

  @override
  String getID(){
    return id;
  }
  String getName(){
    return name;
  }
}
