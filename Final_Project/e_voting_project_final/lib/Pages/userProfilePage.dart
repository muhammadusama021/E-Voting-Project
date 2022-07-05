import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rounded_letter/rounded_letter.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'resources.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  final titles = [
    "1. How do I register for e-Voting facility?",
    "2. Is there any charge for using e-Voting system?",
    "3. Will proxy be able to cast vote in e-Voting system?",
    "4. Once I cast my vote on e-Voting System, can I modify my vote before the closing of e-Voting cycle?"
  ];
  final subTitles = [
    "Simple go to Registration Page, and provide details The "
        "registration details like User Name, Email, PhoneNo, "
        "password after that we will sent a verification link on "
        "your email address to verify, simply click on that link to "
        "verify your account after that your account is Successfully Register, "
        "than you are able to login. ",
    "No. Currently, This portal does not levy any charge on the Organizer or Voters "
        "for using the e-Voting system.",
    "E-Voting system brings flexibility, convenience and ease of operation "
        "for the shareholder to cast vote through internet. "
        "Thus, eliminating the need to appoint a proxy.",
    "No. Vote once casted will be considered final and cannot be modified."
  ];
  final roundShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(

        topLeft: Radius.circular(20),
        topRight: Radius.circular(20)),
  );
  final bioController = new TextEditingController();
  final nameController = new TextEditingController();
  final phoneNoController = new TextEditingController();
  final RegisterationNoController = new TextEditingController();
  final permanentAddressController = new TextEditingController();
  final PresentAddressController = new TextEditingController();
  final departmentNameController = new TextEditingController();
  final CnicController = new TextEditingController();
  final organizationController = new TextEditingController();
  final _auth = FirebaseAuth.instance;
  final database = Firestore.instance;
  String name;
  String email;
  String phoneNo;
  String RegNo;
  String depart;
  String cnic;
  String status = '';
  String orgName = '';
  String pAddress;
  String presentAddress;

  _fetch() async {
    final FirebaseUser firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      await database
          .collection("Users")
          .document(firebaseUser.uid)
          .get()
          .then((value) {
        status = value.data['Status'];
        name = value.data['name'];
        orgName = value.data['organization'];
        name = name.toUpperCase();
        email = value.data['email'];
        phoneNo = value.data['phoneNo'];
        depart = value.data['depart'];
        pAddress = value.data['permanentAddress'];
        presentAddress = value.data['postalAddress'];
        RegNo = value.data['regNo'];
        cnic = value.data['CNIC'];
        RegNo = RegNo.toUpperCase();
      }).catchError((e) {
        print(e);
      });
    }
  }

  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  SharedPreferences prefs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    createOpenBox();
  }
  void createOpenBox()async{
    prefs = await SharedPreferences.getInstance();
    getdata();

    //getdata();  // when user re-visit app, we will get data saved in local database
    //how to get data from hive db check it in below steps
  }
  void _onRememberMeChanged(String text) => setState(() {
      prefs.setString('bio', text);



  });
  String mybio = 'Write Bio Here';
  void getdata() async{

    if(prefs.getString('bio')!=null){
      if(prefs.getString('bio')=='')
        {
          mybio = 'Write Bio Here';
        }
      else{
        mybio = prefs.getString('bio');
      }

      setState(() {
      });
    }


  }


  Widget _card() {
    return new FutureBuilder(
        future: _fetch(),
        builder: (context, snapshot) {
          String username = '$name'.toUpperCase();
          if (snapshot.connectionState != ConnectionState.done) {
            return new Center(
              child: CircularProgressIndicator(),
            );
          } else if (status == "VOTER") {
            return new Container(
                color: kmainColor,
                height: 80,
                child: Card(
                  child: ListTile(
                    title: Text(
                      "$username",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),

                    ),
                    subtitle: Text(
                      "$status",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    leading: CircleAvatar(
                        child: RoundedLetter.withRedCircle(
                            username[0] + username[1], 40, 20)),
                  ),
                ));
          } else if (status == "ORGANIZER") {
            return new Container(
                color: kmainColor,
                height: 80,
                child: Card(
                  child: ListTile(
                    title: Text(
                      "$username",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),

                    ),
                    subtitle: Text(
                      "$status",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                    ),
                    leading: CircleAvatar(
                        child: RoundedLetter.withRedCircle(
                            username[0] + username[1], 40, 20)),
                  ),
                ));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: kmainColor,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: new Container(
        child: new ListView(
          children: <Widget>[
            _card(),
            Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Account",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: kmainColor),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      FutureBuilder(
                          future: _fetch(),
                          builder: (context, snapshot) {
                            /*if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return new Column(
                                children: [
                                  InkWell(
                                    onTap: () {_openPopup3(context, "");},
                                    child: ListTile(
                                      title: Text(
                                        "$mybio",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      subtitle: Text(
                                        "Bio",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  ExpansionTileCard(
                                    title: Text(
                                      "Personal Informtion",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    subtitle: Text(
                                      "edit",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    children: [
                                      Container(
                                        color: Color(0xffFFFFFF),
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 25.0),
                                          child: new Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 25.0),
                                                  child: new Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    children: <Widget>[
                                                      new Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        mainAxisSize:
                                                        MainAxisSize.min,
                                                        children: <Widget>[
                                                          new Text(
                                                            'Personal Information',
                                                            style: TextStyle(
                                                                fontSize: 18.0,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      new Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                        mainAxisSize:
                                                        MainAxisSize.min,
                                                        children: <Widget>[
                                                          _status
                                                              ? _getEditIcon()
                                                              : new Container(),
                                                        ],
                                                      )
                                                    ],
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 25.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    children: <Widget>[
                                                      new Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        mainAxisSize:
                                                        MainAxisSize.min,
                                                        children: <Widget>[
                                                          new Text(
                                                            'Name',
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 2.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    children: <Widget>[
                                                      new Flexible(
                                                        child: new TextField(
                                                          controller:
                                                          TextEditingController(
                                                              text: '$name'),
                                                          decoration: const InputDecoration(
                                                    hintText: '$name'
                                                  ),
                                                          enabled: !_status,
                                                          autofocus: !_status,
                                                          onChanged: (value){
                                                            if(nameController.text==null)
                                                            {
                                                              nameController.text=name;
                                                            }
                                                            else{
                                                              nameController.text=value;
                                                            }

                                                            },
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 25.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    children: <Widget>[
                                                      new Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        mainAxisSize:
                                                        MainAxisSize.min,
                                                        children: <Widget>[
                                                          new Text(
                                                            'Email ID',
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 2.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    children: <Widget>[
                                                      new Flexible(
                                                        child: new TextField(

                                                          controller:
                                                          TextEditingController(
                                                              text: '$email'),
                                                          decoration: const InputDecoration(
                                                      hintText: "Enter Email ID"),
                                                          enabled: false,

                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 25.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    children: <Widget>[
                                                      new Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        mainAxisSize:
                                                        MainAxisSize.min,
                                                        children: <Widget>[
                                                          new Text(
                                                            'Mobile',
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 2.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    children: <Widget>[
                                                      new Flexible(
                                                        child: new TextField(
                                                          controller:
                                                          TextEditingController(
                                                              text:
                                                              '$phoneNo'),
                                                          *//*decoration: const
                                                          InputDecoration(
                                                      hintText: "Enter Mobile Number"),*//*
                                                          enabled: !_status,
                                                          onChanged: (value){
                                                            if(phoneNoController.text==null)
                                                            {
                                                              phoneNoController.text=phoneNo;
                                                            }
                                                            else{
                                                              phoneNoController.text=value;
                                                            }

                                                            },
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 25.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Container(
                                                          child: new Text(
                                                            'Department Name',
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ),
                                                        flex: 2,
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: new Text(
                                                            'Present Address',
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ),
                                                        flex: 2,
                                                      ),
                                                    ],
                                                  )),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 2.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                          EdgeInsets.only(
                                                              right: 10.0),
                                                          child: new TextField(
                                                            controller:
                                                            TextEditingController(
                                                                text:
                                                                '$depart'),
                                                            *//*decoration: const InputDecoration(
                                                        hintText: "Enter Department Name"),*//*
                                                            enabled: !_status,
                                                            onChanged: (value){departmentNameController.text=value;},

                                                          ),
                                                        ),
                                                        flex: 2,
                                                      ),
                                                      Flexible(
                                                        child: new TextField(
                                                          controller:
                                                          TextEditingController(
                                                              text:
                                                              '$presentAddress'),
                                                          *//*decoration: const InputDecoration(
                                                      hintText: "Enter State"),*//*
                                                          enabled: !_status,
                                                          onChanged: (value){PresentAddressController.text=value;},
                                                        ),
                                                        flex: 2,
                                                      ),
                                                    ],
                                                  )),
                                              !_status
                                                  ? _getActionButtons()
                                                  : new Container(),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              );
                            }*/
                            return new Column(
                              children: [
                                InkWell(
                                  onTap: () {_openPopup3(context, "");},
                                  child: ListTile(
                                    title: Text(
                                      "$mybio",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    subtitle: Text(
                                      "Bio",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                ExpansionTileCard(
                                  title: Text(
                                    "Personal Informtion",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  subtitle: Text(
                                    "edit",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  children: [
                                    Container(
                                      color: Color(0xffFFFFFF),
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 25.0),
                                        child: new Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 25.0,
                                                    right: 25.0,
                                                    top: 25.0),
                                                child: new Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: <Widget>[
                                                    new Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        new Text(
                                                          'Personal Information',
                                                          style: TextStyle(
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                    new Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        _status
                                                            ? _getEditIcon()
                                                            : new Container(),
                                                      ],
                                                    )
                                                  ],
                                                )),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 25.0,
                                                    right: 25.0,
                                                    top: 25.0),
                                                child: new Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: <Widget>[
                                                    new Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        new Text(
                                                          'Name',
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 25.0,
                                                    right: 25.0,
                                                    top: 2.0),
                                                child: new Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: <Widget>[
                                                    new Flexible(
                                                      child: new TextFormField(
                                                        controller:
                                                            TextEditingController(
                                                                text: '$name'),
                                                        /*decoration: const InputDecoration(
                                                    hintText: '$name'
                                                  ),*/
                                                        enabled: !_status,
                                                        autofocus: !_status,
                                                        onChanged: (value){

                                                          if(nameController=='')
                                                          {
                                                            nameController.text=name;
                                                          }
                                                          else{
                                                            nameController.text=value;
                                                          }

                                                          },
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 25.0,
                                                    right: 25.0,
                                                    top: 25.0),
                                                child: new Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: <Widget>[
                                                    new Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        new Text(
                                                          'Email ID',
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 25.0,
                                                    right: 25.0,
                                                    top: 2.0),
                                                child: new Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: <Widget>[
                                                    new Flexible(
                                                      child: new TextFormField(

                                                        controller:
                                                            TextEditingController(
                                                                text: '$email'),
                                                        /*decoration: const InputDecoration(
                                                      hintText: "Enter Email ID"),*/
                                                        enabled: false,

                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 25.0,
                                                    right: 25.0,
                                                    top: 25.0),
                                                child: new Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: <Widget>[
                                                    new Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        new Text(
                                                          'Mobile',
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 25.0,
                                                    right: 25.0,
                                                    top: 2.0),
                                                child: new Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: <Widget>[
                                                    new Flexible(
                                                      child: new TextFormField(
                                                        controller:
                                                            TextEditingController(
                                                                text:
                                                                    '$phoneNo'),
                                                        /*decoration: const InputDecoration(
                                                      hintText: "Enter Mobile Number"),*/
                                                        enabled: !_status,
                                                        onChanged: (value){
                                                          if(phoneNoController=='')
                                                          {
                                                            phoneNoController.text=phoneNo;
                                                          }
                                                          else{
                                                            phoneNoController.text=value;
                                                          }

                                                          },
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 25.0,
                                                    right: 25.0,
                                                    top: 25.0),
                                                child: new Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Container(
                                                        child: new Text(
                                                          'Department Name',
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      flex: 2,
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        child: new Text(
                                                          'Present Address',
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      flex: 2,
                                                    ),
                                                  ],
                                                )),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 25.0,
                                                    right: 25.0,
                                                    top: 2.0),
                                                child: new Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Flexible(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10.0),
                                                        child: new TextFormField(
                                                          controller:
                                                              TextEditingController(
                                                                  text:
                                                                      '$depart'),
                                                          /*decoration: const InputDecoration(
                                                        hintText: "Enter Department Name"),*/
                                                          enabled: !_status,
                                                          onChanged: (value){
                                                            if(departmentNameController=='')
                                                            {
                                                              departmentNameController.text=depart;
                                                            }
                                                            else{
                                                              departmentNameController.text=value;
                                                            }

                                                            },

                                                        ),
                                                      ),
                                                      flex: 2,
                                                    ),
                                                    Flexible(
                                                      child: new TextFormField(
                                                        controller:
                                                            TextEditingController(
                                                                text:
                                                                    '$presentAddress'),
                                                        /*decoration: const InputDecoration(
                                                      hintText: "Enter State"),*/
                                                        enabled: !_status,

                                                        onChanged: (value){
                                                          print("Present Controller ==> $PresentAddressController");
                                                          if(PresentAddressController=='')
                                                          {
                                                            PresentAddressController.text=presentAddress;
                                                          }
                                                          else{
                                                            PresentAddressController.text=value;
                                                          }
                                                          },
                                                      ),
                                                      flex: 2,
                                                    ),
                                                  ],
                                                )),
                                            !_status
                                                ? _getActionButtons()
                                                : new Container(),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            );
                          }),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                /*Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Settings",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: kmainColor),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: ListTile(
                          title: Text(
                            "Notification and Sounds",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          leading: Icon(Icons.notifications_active),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: ListTile(
                          title: Text(
                            "Privacy and Security",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          leading: Icon(Icons.lock),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: ListTile(
                          title: Text(
                            "Data and Storage",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          leading: Icon(Icons.update_sharp),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: ListTile(
                          title: Text(
                            "Devices",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          leading: Icon(Icons.devices),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: ListTile(
                          title: Text(
                            "Language",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          leading: Icon(Icons.language),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                ),*/
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Help",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: kmainColor),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            shape: roundShape,
                            context: context,
                            builder: (BuildContext context) {
                              return SingleChildScrollView(
                                child: Container(
                                  decoration: BoxDecoration(

                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),


                                  child: Column(

                                    children: <Widget>[

                                      Center(child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: kmainColor,
                                              borderRadius: BorderRadius.all(Radius.circular(20))
                                          ),
                                          height: 5,
                                          width: MediaQuery.of(context).size.width/2-100,
                                        ),
                                      ),),
                                      Text("FAQ",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(color:kmainColor,fontSize: 28,fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          _New(),


                                          /*Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                              color: Colors.black,
                                                              borderRadius: BorderRadius.all(Radius.circular(20))
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text("How to cast Vote...",
                                                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )*/




                                        ],
                                      ),


                                    ],
                                  ),

                                ),
                              );




                              });


                        },
                        child: ListTile(
                          title: Text(
                            "Portal FAQ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          leading: Icon(Icons.contact_support_outlined),
                        ),
                      ),
                      /*InkWell(
                        onTap: () {},
                        child: ListTile(
                          title: Text(
                            "Privacy Policy",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          leading: Icon(Icons.privacy_tip),
                        ),
                      ),*/
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Update"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  updateProfile();
                  Fluttertoast.showToast(msg: "Successfully Updated Record");
                  setState(() {

                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: kmainColor,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
  _openPopup3(context,text) {


    Alert(
        style: AlertStyle(),
        context: context,
        title: "BIO DATA",
        onWillPopActive: true,
        closeIcon: Icon(Icons.close,color: Color(0xff03c8a8)),
        content: Column(
          children: <Widget>[
            TextFormField(
                controller: bioController,
                decoration: InputDecoration(
                  icon: Icon(Icons.contact_support_outlined,color: Color(0xff03c8a8)),
                  labelText: 'Enter bio',
                ),
                onSaved: (value){bioController.text=value;}
            ),


          ],
        ),
        buttons: [

          DialogButton(
            color: Color(0xff03c8a8),
            onPressed: () {
              _onRememberMeChanged(bioController.text);
              getdata();
              Fluttertoast.showToast(msg: "Bio SAVED!");
              Navigator.of(context).pop();
            },

            child: Text(
              "SAVE",
              style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
            ),
          ),



        ]).show();
  }
  Widget _New() {
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
          itemCount: titles.length,
          itemBuilder: (context, index) {
            return
              Card(
                color: Colors.grey[200],
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: ListTile(
                    title: Text(
                      titles[index],
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(color:kmainColor,fontWeight: FontWeight.bold),
                      ),

                      textAlign: TextAlign.justify,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(subTitles[index],
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(),
                        ),

                        textAlign: TextAlign.justify,),
                    ),

                  ),
                ));
          }),
    );
  }

  Widget _expensionPanel() {
    return Column(children: [
      Container(
        margin: EdgeInsets.all(5),
        color: Colors.green,
        child: ExpansionPanelList(
          animationDuration: Duration(milliseconds: 200),
          children: [
            ExpansionPanel(
              headerBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    "How we Cast vote!",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Candidates',
                      style: TextStyle(color: Colors.black45)),

                );
              },

              isExpanded: _expanded,
              body: _New(),
              canTapOnHeader: true,
            ),
          ],
          dividerColor: Colors.grey,
          expansionCallback: (panelIndex, isExpanded) {
            _expanded = !_expanded;
            setState(() {

            });



          },
        ),
      ),
    ]);
  }

  updateProfile() async
  {
    String U_name = nameController.text;
    String mobileNo = phoneNoController.text;
    print("\nHy I am a Software Engineer\n $U_name");
    String departmentName = departmentNameController.text;
    String present_address = PresentAddressController.text;
    if(!U_name.isEmpty && !mobileNo.isEmpty && !departmentName.isEmpty && !present_address.isEmpty)
      {
        try {
          final FirebaseUser user = await _auth.currentUser();
          Firestore firebaseFirestore = Firestore.instance;
          final uid = user.uid;
          var collection = await firebaseFirestore.collection("Users");
          collection
              .document(uid) // <-- Doc ID to be deleted.
              .updateData({

            "name": U_name,
            "phoneNo": mobileNo,
            "depart": departmentName,
            "postalAddress": present_address
          });
        } catch (e) {
          Fluttertoast.showToast(msg: e);
          print(e);
        }
      }


  }
}