import 'package:custom_timer/custom_timer.dart';
import 'package:e_voting_project_final/services/electionInfo.dart';
import 'package:e_voting_project_final/services/functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:ars_progress_dialog/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:e_voting_project_final/Models/ElectionModel.dart';
import 'package:e_voting_project_final/Pages/resources.dart';
import 'package:e_voting_project_final/ui/widgets/responsive_ui.dart';
import 'package:web3dart/web3dart.dart';
import 'package:e_voting_project_final/constants/constants.dart';
import 'package:web_socket_channel/io.dart';

import '../customDialog.dart';
import 'Candidate_Form.dart';

class AddCandidates extends StatefulWidget {

  @override
  _Candidate_Form createState() => _Candidate_Form();

}
class _Candidate_Form extends State<AddCandidates>  with SingleTickerProviderStateMixin{
  Client httpClient;
  Web3Client ethClient;

  final String _rpcUrl = "http://192.168.100.23:7545";
  final String _wsUrl = "ws://192.168.100.23:7545/";
  static const String routeName = '/categories';
  Color colorGreen=Color(0xff03c8a8);
  Color colorGrey=Colors.grey;
  final _formKey = GlobalKey<FormState>();
  final Map<String, IconData> depart_data = Map.fromIterables(
      ['Computer Science', 'Electrical Engineering', 'Business & Management','Mathematics'],
      [Icons.apartment, Icons.apartment, Icons.apartment,Icons.apartment]);


  final icons = [Icons.arrow_right_alt, Icons.arrow_right_alt, Icons.arrow_right_alt];
  TabController _controller;
  int _selectedIndex = 0;

  List<Widget> list = [
    Tab(child: Text('Candidates',style: TextStyle(color: Colors.white,fontSize: 16))),
    Tab(child: Text('Panels',style: TextStyle(color: Colors.white,fontSize: 16))),
  ];

  @override
  void initState() {

    // TODO: implement initState
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient);
    print("Client:==>"+ethClient.toString());
    _fetch();
    super.initState();







    // Create TabController for getting the index of current tab
    _controller = TabController(length: list.length, vsync: this);

    _controller.addListener(() {

      setState(() {
        _selectedIndex = _controller.index;

      });

    });
  }


  final format = DateFormat("dd-MM-yyyy HH:mm");
  final electionTypeController=new TextEditingController();
  final startTime=new TextEditingController();
  final endTime=new TextEditingController();
/*
  DateTime startTime;
  DateTime endTime;*/

  final updateElectionTypeController=new TextEditingController();
  final updatePanelTypeController=new TextEditingController();
  final fullNameController=new TextEditingController();
  final RegisterationNoController=new TextEditingController();
  final emailController=new TextEditingController();
  final phoneNoController=new TextEditingController();
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  String errorMessage='';

  String deprt_selectedType;
  IconData deprt_selectedIcon;

  final roundShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(15),
        bottomLeft: Radius.circular(15),
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15)),
  );
  final _auth = FirebaseAuth.instance;
  final database =Firestore.instance;
  String name;
  String p_name;
  String status;
  String start_time;
  String end_time;
  String p_status;

  DateTime S_time;
  DateTime E_time;
  var _list = [];
  var p_list = [];

  var identifier = new Map();
  var P_identifier = new Map();


  _fetch() async
  {
    QuerySnapshot _myDoc = await Firestore.instance.collection('ElectionData').getDocuments();
    List<DocumentSnapshot> _myDocCount = _myDoc.documents;
    for (var item in _myDocCount)
      {
        await database.collection("ElectionData").document(item.documentID).get().then((value)
        {
          name=value.data['name'];
          _list.add(name);
          status=value.data['Status'];
          _list.add(status);
          start_time=value.data['Start_time'];
          S_time = new DateFormat("dd-MM-yyyy HH:mm").parse(start_time);
          _list.add(S_time);
          end_time=value.data['End_time'];
          E_time = new DateFormat("dd-MM-yyyy HH:mm").parse(end_time);
          _list.add(E_time);
          final difference = E_time.difference(DateTime.now()).inSeconds;

          _list.add(difference);
          identifier[item.documentID] = _list;



        }).catchError((e)
        {
          print(e);
        });
        _list=[];
      }


  }
  _fetch_Panel() async
  {
    QuerySnapshot _myDoc = await Firestore.instance.collection('PanelData').getDocuments();
    List<DocumentSnapshot> _myDocCount = _myDoc.documents;
    for (var item in _myDocCount)
    {
      await database.collection("PanelData").document(item.documentID).get().then((value)
      {
        p_name=value.data['name'];
        p_list.add(p_name);
        p_status=value.data['Status'];
        p_list.add(p_status);
        start_time=value.data['Start_time'];
        S_time = new DateFormat("dd-MM-yyyy HH:mm").parse(start_time);
        p_list.add(S_time);
        end_time=value.data['End_time'];
        E_time = new DateFormat("dd-MM-yyyy HH:mm").parse(end_time);
        p_list.add(E_time);
        final difference = E_time.difference(DateTime.now()).inSeconds;

        p_list.add(difference);
        P_identifier[item.documentID] = p_list;

      }).catchError((e)
      {
        print(e);
      });
      p_list=[];

    }


  }
  @override



  @override
  Widget build(BuildContext context) {
    /*ProgressDialog _progressDialog = ProgressDialog();*/
    ArsProgressDialog progressDialog2 = ArsProgressDialog(

        context,
        dismissable: false,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Container(

        child: Scaffold(
          backgroundColor: Colors.white,
            appBar: AppBar(

              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Color(0xff03c8a8),
              title: Text('Add Candidate/Panel',style: TextStyle(color: Colors.white),),
              bottom:TabBar(
                indicatorWeight: 8,

                indicatorColor: Colors.white,
                /*indicator: BoxDecoration(

                    borderRadius: BorderRadius.circular(10), // Creates border
                    color: colorGrey.withOpacity(0.7)),*/

                controller: _controller,
                tabs: list,
              ),
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.notifications,
                      ),
                    )),

              ],
            ),
            body:
            TabBarView(
              controller: _controller,
              children: [
                RefreshIndicator(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 20),
                        child: Row(
                          children: <Widget>[
                            FutureBuilder(
                                future: _fetch(),
                                builder: (context, snapshot)
                                {
                                  if(snapshot.connectionState != ConnectionState.done)
                                  {
                                    /*_progressDialog.showProgressDialog(context
                                ,textToBeDisplayed: 'loading...'
                                ,dismissAfter: Duration(seconds: 4)
                            );*/
                                    return
                                      Container(
                                        width: _width/1-20,
                                        height: _height/1.4-20,
                                        child:Center(
                                          child: CircularProgressIndicator(),
                                        ),

                                      );
                                  }
                                  else
                                  {

                                    return new Expanded(
                                      // 60%
                                      child: Container(
                                        child: Column(

                                          children: [
                                            _addElectionType(context),
                                            SizedBox(height: 20),
                                            Container(
                                              height: 3,
                                              color: Colors.black12,
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text("Elections Details/Types",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(fontSize: 16,color: Color(0xff03c8a8)),),

                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Container(
                                              height: 3,
                                              color: Colors.black12,
                                            ),

                                            SizedBox(height: 20),

                                            for (var item in identifier.entries)...[
                                              Row(
                                                children: [

                                                  if(item.value[1]=="ON")...[
                                                    Expanded(child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("Status",
                                                        style: TextStyle(fontSize: 18,color: colorGreen),
                                                      ),
                                                    ),),
                                                    Container(

                                                      child: SlidingSwitch(
                                                        value: true,
                                                        width: 150,
                                                        onChanged: (bool value) {
                                                          print(value);
                                                        },
                                                        height : 40,
                                                        animationDuration : const Duration(milliseconds: 400),
                                                        onTap:(){
                                                          updateStatus("OFF", item.key);
                                                        },

                                                        textOff: "OFF",
                                                        textOn : item.value[1],
                                                        colorOn : colorGreen,
                                                        colorOff : const Color(0xff6682c0),
                                                        background : const Color(0xffe4e5eb),
                                                        buttonColor : const Color(0xfff7f5f7),
                                                        inactiveColor : const Color(0xff636f7b),
                                                      ),


                                                    ),
                                                  ]
                                                  else if(item.value[1]=="OFF")...[
                                                    Expanded(child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("Status",
                                                        style: TextStyle(fontSize: 18,color: colorGreen),
                                                      ),
                                                    ),),

                                                    Container(

                                                      child: SlidingSwitch(
                                                        value: false,
                                                        width: 150,
                                                        onChanged: (bool value) {

                                                          print(value);
                                                        },
                                                        height : 40,
                                                        animationDuration : const Duration(milliseconds: 400),
                                                        onTap:(){
                                                          updateStatus("ON", item.key);
                                                           },
                                                        
                                                        textOff: item.value[1],
                                                        textOn : "ON",
                                                        colorOn : colorGreen,
                                                        colorOff : const Color(0xff6682c0),
                                                        background : const Color(0xffe4e5eb),
                                                        buttonColor : const Color(0xfff7f5f7),
                                                        inactiveColor : const Color(0xff636f7b),
                                                      ),


                                                    ),
                                ]

                                                ],
                                              ),
                                              SizedBox(height: 20),
                                              Material(
                                                color:Colors.grey,
                                                elevation: 10,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),

                                                child: Row(
                                                  children: [

                                                    Expanded(
                                                      child: Container(

                                                        child: Padding(
                                                          padding: const EdgeInsets.all(15),
                                                          child: Text("Voting for "+item.value[0],
                                                            style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: (){
                                                        _openPopup2(context, "Election Data", "edit", item.value[0],item.key);
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Icon(Icons.edit,color: Colors.white,),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: (){
                                                        _openPopup2(context, "Election Data", "delete", item.value[0],item.key);
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Icon(Icons.delete,color: Colors.white,),
                                                      ),
                                                    ),


                                                  ],
                                                ),
                                              ),


                                              SizedBox(height: 20),
                                              Row(
                                                children: [
                                                  if(item.value[4]>0)...[
                                                    Expanded(child:Center(
                                                      child: CustomTimer(
                                                        from: Duration(seconds: item.value[4]),
                                                        to: Duration(seconds: 0),
                                                        onBuildAction: CustomTimerAction.auto_start,
                                                        builder: (CustomTimerRemainingTime remaining) {
                                                          return Row(
                                                            children: [
                                                              if(int.parse("${remaining.days}") >= 1)...[
                                                                Expanded(child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Text("Remaining Time:  ",
                                                                    style: TextStyle(fontSize:18,color: colorGreen),
                                                                  ),
                                                                ),),


                                                                InkWell(
                                                                  onTap: (){
                                                                    _openPopup3(context, "Election Time", item.value[0], item.key);
                                                                  },
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Text(
                                                                      "${remaining.days} days ${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                                                                      style: TextStyle(fontSize: 18.0,color: colorGrey,fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),




                                                              ]
                                                              else if(int.parse("${remaining.hours}") > 1 && int.parse("${remaining.hours}") <= 24)...[
                                                                Expanded(child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Text("Remaining Time:  ",
                                                                    style: TextStyle(fontSize:18,color: colorGreen),
                                                                  ),
                                                                ),),

                                                                InkWell(
                                                                  onTap: (){
                                                                    _openPopup3(context, "Election Time", item.value[0], item.key);
                                                                  },
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Text(
                                                                      "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                                                                      style: TextStyle(fontSize: 18.0,color: colorGrey,fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),


                                                              ]
                                                              else if(int.parse("${remaining.minutes}") < 60)...[
                                                                  Expanded(child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Text("Remaining Time:  ",
                                                                      style: TextStyle(fontSize:18,color: colorGreen),
                                                                    ),
                                                                  ),),

                                                                  InkWell(
                                                                    onTap: (){
                                                                      _openPopup3(context, "Election Time", item.value[0], item.key);
                                                                    },
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Text(
                                                                        "${remaining.minutes} min ${remaining.seconds} sec",
                                                                        style: TextStyle(fontSize: 18.0,color: Colors.red,fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ),


                                                                ]
                                                            ],
                                                          );

                                                        },
                                                        onFinish: (){return Text("Kindly Update Time");},
                                                      ),

                                                    ),)

                                                  ]
                                                  else...[
                                                    Expanded(child: Center(
                                                      child: Row(
                                                        children: [

                                                          Expanded(child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text("Remaining Time:  ",
                                                              style: TextStyle(fontSize:18,color: colorGreen),
                                                            ),
                                                          )),


                                                          InkWell(
                                                            onTap: (){
                                                              _openPopup3(context, "Election Time", item.value[0], item.key);
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(
                                                                "Time End",
                                                                style: TextStyle(fontSize: 18.0,color: colorGrey,fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),


                                                    ),)

                                                  ]



                                                ],
                                              ),


                                              SizedBox(height: 10),
                                              Row(
                                                children: [

                                                  Expanded(
                                                    child: _addCandidates(context,item.value[0],item.key),
                                                  ),


                                                ],
                                              ),
                                              /* SizedBox(height: 20),
                                        _addPanels(context,item.value,item.key),
                                        SizedBox(height: 20),
                                        _addCandidates(context,item.value,item.key),*/
                                              SizedBox(height: 20),
                                              Container(

                                                height: 3,
                                                color: Colors.black54,

                                              ),
                                              SizedBox(height: 20),


                                            ],



                                          ],
                                        ),
                                      ),
                                    );
                                  }



                                }

                            ),



                          ],
                        ),

                      ),
                    ),
                  ),
                  onRefresh: _refreshData,
                ),
                RefreshIndicator(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Container(

                        margin: EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 20),
                        child: Row(

                          children: <Widget>[
                            FutureBuilder(
                                future: _fetch_Panel(),
                                builder: (context, snapshot)
                                {
                                  if(snapshot.connectionState != ConnectionState.done)
                                  {

                                    return
                                      Container(
                                        width: _width/1-20,
                                        height: _height/1.4-20,
                                        child:Center(
                                          child: CircularProgressIndicator(),
                                        ),

                                      );
                                  }
                                  else
                                  {

                                    return new Expanded(
                                      // 60%
                                      child: Container(
                                        child: Column(

                                          children: [
                                            _addPanelType(context),
                                            SizedBox(height: 20),
                                            Container(
                                              height: 3,
                                              color: Colors.black12,
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text("Panels Details/Types",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(fontSize: 16,color: Color(0xff03c8a8)),),

                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Container(
                                              height: 3,
                                              color: Colors.black12,
                                            ),

                                            SizedBox(height: 20),

                                            for (var item in P_identifier.entries)...[
                                              Row(
                                                children: [
                                                  if(item.value[1]=="ON")...[
                                                    Expanded(child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("Status",
                                                        style: TextStyle(fontSize: 18,color: colorGreen),
                                                      ),
                                                    ),),

                                                    Container(

                                                      child: SlidingSwitch(
                                                        value: true,
                                                        width: 150,
                                                        onChanged: (bool value) {
                                                          print(value);
                                                        },
                                                        height : 40,
                                                        animationDuration : const Duration(milliseconds: 400),
                                                        onTap:(){
                                                          updatePanelStatus("OFF", item.key);

                                                        },

                                                        textOff: "OFF",
                                                        textOn : item.value[1],
                                                        colorOn : colorGreen,
                                                        colorOff : const Color(0xff6682c0),
                                                        background : const Color(0xffe4e5eb),
                                                        buttonColor : const Color(0xfff7f5f7),
                                                        inactiveColor : const Color(0xff636f7b),
                                                      ),


                                                    ),
                                                  ]
                                                  else if(item.value[1]=="OFF")...[
                                                    Expanded(child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("Status",
                                                        style: TextStyle(fontSize: 18,color: colorGreen),
                                                      ),
                                                    ),),

                                                    Container(

                                                      child: SlidingSwitch(
                                                        value: false,
                                                        width: 150,
                                                        onChanged: (bool value) {

                                                          print(value);
                                                        },
                                                        height : 40,
                                                        animationDuration : const Duration(milliseconds: 400),
                                                        onTap:(){
                                                          updatePanelStatus("ON", item.key);

                                                        },

                                                        textOff: item.value[1],
                                                        textOn : "ON",
                                                        colorOn : colorGreen,
                                                        colorOff : const Color(0xff6682c0),
                                                        background : const Color(0xffe4e5eb),
                                                        buttonColor : const Color(0xfff7f5f7),
                                                        inactiveColor : const Color(0xff636f7b),
                                                      ),


                                                    ),
                                                  ]

                                                ],
                                              ),

                                              SizedBox(height: 20),
                                              Material(
                                                color:Colors.grey,
                                                elevation: 10,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),

                                                child: Row(
                                                  children: [

                                                    Expanded(
                                                      child: Container(

                                                        child: Padding(
                                                          padding: const EdgeInsets.all(15),
                                                          child: Text("Voting for "+item.value[0],
                                                            style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: (){
                                                        _openPopup2(context, "Panel Data", "edit", item.value[0],item.key);
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Icon(Icons.edit,color: Colors.white,),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: (){
                                                        _openPopup2(context, "Panel Data", "delete", item.value[0],item.key);
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Icon(Icons.delete,color: Colors.white,),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ),



                                              SizedBox(height: 20),
                                              Row(
                                                children: [
                                                  if(item.value[4]>0)...[
                                                    Expanded(child: Center(
                                                      child: CustomTimer(
                                                        from: Duration(seconds: item.value[4]),
                                                        to: Duration(seconds: 0),
                                                        onBuildAction: CustomTimerAction.auto_start,
                                                        builder: (CustomTimerRemainingTime remaining) {
                                                          return Row(
                                                            children: [
                                                              if(int.parse("${remaining.days}") >= 1)...[
                                                                Expanded(child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Text("Remaining Time:  ",
                                                                    style: TextStyle(fontSize:18,color: colorGreen),
                                                                  ),
                                                                ),),

                                                                InkWell(
                                                                  onTap: (){
                                                                    _openPopup3(context, "Panel Time", item.value[0], item.key);
                                                                  },
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Text(
                                                                      "${remaining.days} days ${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                                                                      style: TextStyle(fontSize: 18.0,color: colorGrey,fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),

                                                              ]
                                                              else if(int.parse("${remaining.hours}") > 1 && int.parse("${remaining.hours}") <= 24)...[
                                                                Expanded(child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Text("Remaining Time:  ",
                                                                    style: TextStyle(fontSize:18,color: colorGreen),
                                                                  ),
                                                                ),),

                                                                InkWell(
                                                                  onTap: (){
                                                                    _openPopup3(context, "Panel Time", item.value[0], item.key);
                                                                  },
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Text(
                                                                      "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                                                                      style: TextStyle(fontSize: 18.0,color: colorGrey,fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),


                                                              ]
                                                              else if(int.parse("${remaining.minutes}") < 60)...[
                                                                  Expanded(child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Text("Remaining Time:  ",
                                                                      style: TextStyle(fontSize:18,color: colorGreen),
                                                                    ),
                                                                  ),),
                                                                  InkWell(
                                                                    onTap: (){
                                                                      _openPopup3(context, "Panel Time", item.value[0], item.key);
                                                                    },
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Text(
                                                                        "${remaining.minutes} min ${remaining.seconds} sec",
                                                                        style: TextStyle(fontSize: 18.0,color: Colors.red,fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ),


                                                                ]
                                                            ],
                                                          );

                                                        },
                                                        onFinish: (){return Text("Kindly Update Time");},
                                                      ),

                                                    ),)

                                                  ]
                                                  else...[
                                                    Expanded(child:Center(
                                                      child: Row(
                                                        children: [
                                                          Expanded(child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text("Remaining Time:  ",
                                                              style: TextStyle(fontSize:18,color: colorGreen),
                                                            ),
                                                          ),),

                                                          InkWell(
                                                            onTap: (){
                                                              _openPopup3(context, "Panel Time", item.value[0], item.key);
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(
                                                                "Time End",
                                                                style: TextStyle(fontSize: 18.0,color: colorGrey,fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),),


                                                  ]
                                                ],
                                              ),



                                              SizedBox(height: 10),
                                              Row(
                                                children: [

                                                  SizedBox(width: 2),
                                                  Expanded(
                                                    child: _addpanelCandidates(context,item.value[0],item.key),
                                                  ),


                                                ],
                                              ),
                                              /* SizedBox(height: 20),
                                        _addPanels(context,item.value,item.key),
                                        SizedBox(height: 20),
                                        _addCandidates(context,item.value,item.key),*/
                                              SizedBox(height: 20),
                                              Container(

                                                height: 3,
                                                color: Colors.black54,

                                              ),
                                              SizedBox(height: 20),


                                            ],



                                          ],
                                        ),
                                      ),
                                    );
                                  }



                                }

                            ),



                          ],
                        ),

                      ),
                    ),
                  ),
                  onRefresh: _refreshData,
                ),
              ],
            ),



        ));
  }
  Future _refreshData() async {

    await Future.delayed(Duration(seconds: 5));
    setState(() {});
  }
  Widget _addElectionType(context)
  {
    return
      // ignore: deprecated_member_use
      RaisedButton(
          onPressed: () {
            _openPopup(context,"Add Election Type","","");
          },
          color: Color(0xff03c8a8),
          shape: roundShape,
          elevation: 10,

          padding: EdgeInsets.symmetric(vertical: 12),

          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15,0),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Add Election Type',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.add,
                  color: Colors.white,
                )
              ],
            ),
          ));

  }
  Widget _addPanelType(context)
  {
    return
      // ignore: deprecated_member_use
      RaisedButton(
          onPressed: () {
            _openPopup(context,"Add Panel Name","","");
          },
          color: Color(0xff03c8a8),
          shape: roundShape,
          elevation: 10,

          padding: EdgeInsets.symmetric(vertical: 12),

          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15,0),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Add Panel Type',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.add,
                  color: Colors.white,
                )
              ],
            ),
          ));

  }
  Widget _addPanels(context,type,id)
  {
    return
        // ignore: deprecated_member_use
      RaisedButton(
          onPressed: () {
            _openPopup(context,"Add Panels","$type","$id");
          },
          color: Color(0xff03c8a8),
          shape: roundShape,
          elevation: 10,

          padding: EdgeInsets.symmetric(vertical: 12),

          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15,0),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Add Panels',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.add,
                  color: Colors.white,
                )
              ],
            ),
          ));

  }
  Widget _addCandidates(context,type,id)
  {
    return
      // ignore: deprecated_member_use
      RaisedButton(
          onPressed: () {_openPopup(context,"Add Candidates","$type","$id");
            /*Navigator.push(
                context, MaterialPageRoute(builder: (context) => Candidate_Form()));*/
          },
          color: Color(0xff03c8a8),
          shape: roundShape,
          elevation: 10,

          padding: EdgeInsets.symmetric(vertical: 12),

          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15,0),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Add Candidates',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.add,
                  color: Colors.white,
                )
              ],
            ),
          ));

  }
  Widget _addpanelCandidates(context,type,id)
  {
    return
      // ignore: deprecated_member_use
      RaisedButton(
          onPressed: () {_openPopup(context,"Add Panel Candidates","$type","$id");
            /*Navigator.push(
                context, MaterialPageRoute(builder: (context) => Candidate_Form()));*/
          },
          color: Color(0xff03c8a8),
          shape: roundShape,
          elevation: 10,

          padding: EdgeInsets.symmetric(vertical: 12),

          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15,0),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Add Candidates',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.add,
                  color: Colors.white,
                )
              ],
            ),
          ));

  }

  _openPopup(context,text,type,id) {
    final _controller = TextEditingController();
    final electionTypeController=new TextEditingController();
    final panelTypeController=new TextEditingController();
    final fullNameField =TextFormField(
        controller: fullNameController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regExp = new RegExp(r'^.{3,}$');
          if(value.isEmpty)
          {
            return ("Name is Required");
          }
          if(!regExp.hasMatch(value)){
            return ("Enter Valid Name (Min. 3 Characters)");}
          return null;
        },
        onSaved: (value){fullNameController.text=value;},
        textInputAction: TextInputAction.next,
        cursorColor: Color(0xff03c8a8),
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.account_circle,color: Color(0xff03c8a8), size: 20),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: 'Enter Candidate Name',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30)
            )
        )
    );
    final RegNoField =TextFormField(
        autofocus: false,
        controller: RegisterationNoController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regExp = new RegExp(r'^.{10,}$');
          if(value.isEmpty)
          {
            return ("RegNo is Required");
          }
          if(!regExp.hasMatch(value)){
            return ("Enter Valid RegNo (Min. 10 Characters)");}
          return null;
        },
        onSaved: (value){RegisterationNoController.text=value;},
        textInputAction: TextInputAction.next,
        cursorColor: Color(0xff03c8a8),
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.app_registration,color: Color(0xff03c8a8), size: 20),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: 'Enter Registration No',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30)
            )
        )
    );
    final emailField =TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {

          if(value.isEmpty)
          {
            return ("Email Address is Required");
          }
          if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
            return ("Enter Valid Email Address...");}
          return null;
        },
        onSaved: (value){emailController.text=value;},
        textInputAction: TextInputAction.next,
        cursorColor: Color(0xff03c8a8),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email,color: Color(0xff03c8a8), size: 20),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Enter Email Address',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30)
          ),
          focusedBorder: OutlineInputBorder(

            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xff03c8a8), width: 2.0),
          ),

        )
    );
    final phoneNoField =TextFormField(
        autofocus: false,
        controller: phoneNoController,

        keyboardType: TextInputType.visiblePassword,
        validator: (value) {
          RegExp regExp = new RegExp(r'^.{11,}$');
          if(value.isEmpty)
          {
            return ("PhoneNo is Required");
          }
          if(!regExp.hasMatch(value)){
            return ("Enter Valid Mobile No (Min. 11 Characters)");}
          return null;
        },
        onSaved: (value){phoneNoController.text=value;},
        textInputAction: TextInputAction.next,
        cursorColor: Color(0xff03c8a8),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone,color: Color(0xff03c8a8), size: 20),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Enter Mobile No',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30)
          ),
          focusedBorder: OutlineInputBorder(

            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xff03c8a8), width: 2.0),
          ),
        )
    );
    setState(() {
      fullNameController.text='';
      emailController.text='';
      phoneNoController.text='';
      RegisterationNoController.text='';


    });

    Alert(
        style: AlertStyle(),
        context: context,
        title: "",
        onWillPopActive: true,
        closeIcon: Icon(Icons.close,color: Color(0xff03c8a8)),
        content: Column(
          children: <Widget>[
            if(text=="Add Panels")...[
              Material(
                color: Colors.grey,
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: Container(

                  alignment: Alignment.centerLeft,
                  child:Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        "$text".toUpperCase(),
                        style: TextStyle(
                            letterSpacing: 1.5,
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              TextField(

                decoration: InputDecoration(
                  icon: Icon(Icons.supervised_user_circle,color: Color(0xff03c8a8)),
                  labelText: 'No. of candidates',
                ),
              ),
            ]
            else if(text=="Add Candidates")...[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[

                    Container(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Material(
                              color: Colors.grey,
                              elevation: 5,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(

                                alignment: Alignment.centerLeft,
                                child:Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Center(
                                    child: Text(
                                      "$text".toUpperCase(),
                                      style: TextStyle(
                                          letterSpacing: 1.5,

                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 20),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Column(
                                  children: [
                                    fullNameField,
                                    SizedBox(height: 20),
                                    emailField,
                                    SizedBox(height: 20),
                                    phoneNoField,
                                    SizedBox(height: 20),
                                    if(type!='CR of Class')...[
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child:Text(
                                          "Select your Department".toUpperCase(),
                                          style: TextStyle(
                                              letterSpacing: 1,
                                              color: Color(0xff03c8a8),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DropdownButtonHideUnderline(

                                        child: DropdownButton<String>(
                                            style: TextStyle(
                                                color: Color(0xff03c8a8)
                                            ),

                                            items: depart_data.keys.map((String val) {
                                              return DropdownMenuItem<String>(
                                                value: val,
                                                child: Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                                                      child: Icon(depart_data[val],color: Color(0xff03c8a8),),
                                                    ),
                                                    Text(val),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                            hint: Row(

                                              children: <Widget>[

                                                Padding(

                                                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                                                  child:
                                                  Icon(deprt_selectedIcon ?? depart_data.values.toList()[0],color: Color(0xff03c8a8),),
                                                ),

                                                Text(

                                                  deprt_selectedType ?? "Select your Department ",
                                                  style: TextStyle(
                                                      color: Color(0xff03c8a8),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ],
                                            ),

                                            onChanged: (String val) {
                                              setState(() {
                                                deprt_selectedType = val;
                                                deprt_selectedIcon = depart_data[val];
                                              });
                                            }),
                                      ),
                                      SizedBox(height: 20),
                                    ]else...[
                                      RegNoField,
                                      SizedBox(height: 20),
                                    ],


                                    SizedBox(height: 20),

                                  ],
                                ),
                              ),
                            ),


                          ],
                        ),
                      ),
                    ), //signInTextRow(),
                  ],
                ),
              ),
            ]
            else if(text=="Add Panel Candidates")...[
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[

                      Container(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Material(
                                color: Colors.grey,
                                elevation: 5,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(

                                  alignment: Alignment.centerLeft,
                                  child:Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Center(
                                      child: Text(
                                        "$text".toUpperCase(),
                                        style: TextStyle(
                                            letterSpacing: 1.5,

                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 20),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Column(
                                    children: [
                                      fullNameField,



                                      SizedBox(height: 20),

                                    ],
                                  ),
                                ),
                              ),


                            ],
                          ),
                        ),
                      ), //signInTextRow(),
                    ],
                  ),
                ),
              ]
            else if(text=="Add Election Type")...[
                Material(
                  color: Colors.grey,
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(

                    alignment: Alignment.centerLeft,
                    child:Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          "$text".toUpperCase(),
                          style: TextStyle(
                              letterSpacing: 1.5,

                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("e.g President of Sport Week",style: TextStyle(fontSize: 14,color: Colors.black12),),
                ),
                TextFormField(
                    controller: electionTypeController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.local_activity,color: Color(0xff03c8a8)),
                      labelText: 'Enter Election Type',
                    ),
                    onSaved: (value){electionTypeController.text=value;}
                ),
                  SizedBox(height: 10,),
                  DateTimeField(
                    controller: startTime,
                    onSaved: (value){startTime.text=value as String;},
                    decoration: InputDecoration(
                      icon: Icon(Icons.timer,color: Color(0xff03c8a8)),
                      labelText: 'Pick Start Voting Date/Time',
                    ),

                    format: format,
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          builder: (BuildContext context, Widget child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: Color(0xff03c8a8),
                                accentColor: Color(0xff03c8a8),
                                colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                                buttonTheme: ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary
                                ),
                              ),
                              child: child,
                            );
                          },
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final time = await showTimePicker(
                          builder: (BuildContext context, Widget child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: Color(0xff03c8a8),
                                accentColor: Color(0xff03c8a8),
                                colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                                buttonTheme: ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary
                                ),
                              ),
                              child: child,
                            );
                          },
                          context: context,
                          initialTime:
                          TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                        );
                        return DateTimeField.combine(date, time);
                      } else {
                        return currentValue;
                      }
                    },
                  ),
                  SizedBox(height: 10,),
                  DateTimeField(
                    controller: endTime,
                    onSaved: (value){endTime.text=value as String;},
                    decoration: InputDecoration(
                      icon: Icon(Icons.more_time,color: Color(0xff03c8a8)),
                      labelText: 'Pick end voting Date/Time',
                    ),

                    format: format,
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          builder: (BuildContext context, Widget child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: Color(0xff03c8a8),
                                accentColor: Color(0xff03c8a8),
                                colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                                buttonTheme: ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary
                                ),
                              ),
                              child: child,
                            );
                          },
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final time = await showTimePicker(
                          builder: (BuildContext context, Widget child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: Color(0xff03c8a8),
                                accentColor: Color(0xff03c8a8),
                                colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                                buttonTheme: ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary
                                ),
                              ),
                              child: child,
                            );
                          },
                          context: context,
                          initialTime:
                          TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                        );
                        return DateTimeField.combine(date, time);
                      } else {
                        return currentValue;
                      }
                    },
                  ),
              ]
            else if (text=="Add Panel Name")...[
                  Material(
                    color: Colors.grey,
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(

                      alignment: Alignment.centerLeft,
                      child:Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            "$text".toUpperCase(),
                            style: TextStyle(
                                letterSpacing: 1.5,

                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text("e.g Shaheen Group Panel",style: TextStyle(fontSize: 16,color: Colors.black12),),
                  ),
                  TextFormField(
                      controller: panelTypeController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.local_activity,color: Color(0xff03c8a8)),
                        labelText: 'Enter Panel Name',
                      ),
                      onSaved: (value){panelTypeController.text=value;}
                  ),
                    SizedBox(height: 10,),
                    DateTimeField(
                      controller: startTime,
                      onSaved: (value){startTime.text=value as String;},
                      decoration: InputDecoration(
                        icon: Icon(Icons.timer,color: Color(0xff03c8a8)),
                        labelText: 'Pick Start Voting Date/Time',
                      ),

                      format: format,
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  primaryColor: Color(0xff03c8a8),
                                  accentColor: Color(0xff03c8a8),
                                  colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                                  buttonTheme: ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary
                                  ),
                                ),
                                child: child,
                              );
                            },
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  primaryColor: Color(0xff03c8a8),
                                  accentColor: Color(0xff03c8a8),
                                  colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                                  buttonTheme: ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary
                                  ),
                                ),
                                child: child,
                              );
                            },
                            context: context,
                            initialTime:
                            TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                    ),
                    SizedBox(height: 10,),
                    DateTimeField(
                      controller: endTime,
                      onSaved: (value){endTime.text=value as String;},
                      decoration: InputDecoration(
                        icon: Icon(Icons.more_time,color: Color(0xff03c8a8)),
                        labelText: 'Pick end voting Date/Time',
                      ),

                      format: format,
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  primaryColor: Color(0xff03c8a8),
                                  accentColor: Color(0xff03c8a8),
                                  colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                                  buttonTheme: ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary
                                  ),
                                ),
                                child: child,
                              );
                            },
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  primaryColor: Color(0xff03c8a8),
                                  accentColor: Color(0xff03c8a8),
                                  colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                                  buttonTheme: ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary
                                  ),
                                ),
                                child: child,
                              );
                            },
                            context: context,
                            initialTime:
                            TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                    ),

              ]

          ],
        ),
        buttons: [
          if(text=="Add Panels")...[
            DialogButton(
              color: Color(0xff03c8a8),
              onPressed: () {
                /*postPanelDetailsToFirestore(electionTypeController.text);
                Fluttertoast.showToast(msg: "Successfully Save");*/
                Navigator.of(context).pop();
              },


              child: Text(
                "ADD PANEL",
                style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
              ),
            )
          ]
          else if(text=="Add Candidates")...[
            DialogButton(
              color: Color(0xff03c8a8),
              onPressed: () {
                postCandidateDetailsToFirestore(context,electionTypeController.text,id);
                },
              child: Text(
                "ADD CANDIDATE",

                style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
              ),
            )
          ]
          else if(text=="Add Election Type")...[
              DialogButton(
                color: Color(0xff03c8a8),
                onPressed: () async {

                  postDetailsToFirestore(electionTypeController.text,startTime.text,endTime.text);
                  Fluttertoast.showToast(msg: "Successfully Save");
                  Navigator.of(context).pop();
                },


                child: Text(
                  "SAVE",
                  style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
                ),
              )
            ]
            else if(text=="Add Panel Name")...[
                DialogButton(
                  color: Color(0xff03c8a8),
                  onPressed: () {
                    postPanelDetailsToFirestore(panelTypeController.text,startTime.text,endTime.text);
                    Fluttertoast.showToast(msg: "Successfully Save");
                    Navigator.of(context).pop();
                  },


                  child: Text(
                    "SAVE PANEL",
                    style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
                  ),
                )
              ]
              else if(text=="Add Panel Candidates")...[
                  DialogButton(
                    color: Color(0xff03c8a8),
                    onPressed: () {
                      postPanelCandidateDetailsToFirestore(context,panelTypeController.text,id);
                      Fluttertoast.showToast(msg: "Successfully Save");
                      Navigator.of(context).pop();
                    },


                    child: Text(
                      "ADD INTO PANEL",
                      style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
                    ),
                  )
                ]

        ]).show();
  }
  _openPopup2(context,text,type,val,id) {


    Alert(
        style: AlertStyle(),
        context: context,
        title: "",
        onWillPopActive: true,
        closeIcon: Icon(Icons.close,color: Color(0xff03c8a8)),
        content: Column(
          children: <Widget>[
            if(type=="edit")...[
              if(text=="Election Data")...[
                TextFormField(
                    controller: TextEditingController(text:'$val'),
                    decoration: InputDecoration(
                      icon: Icon(Icons.local_activity,color: Color(0xff03c8a8)),
                      labelText: 'Enter Election Type',
                      hintText: "$val",
                    ),
                    onChanged: (value){
                      if(updateElectionTypeController=='')
                        {
                          updateElectionTypeController.text=val;
                        }
                      else{
                        updateElectionTypeController.text=value;
                      }


                    }
                ),
                SizedBox(height: 10,),
                DateTimeField(
                  controller: startTime,
                  onSaved: (value){startTime.text=value as String;},
                  decoration: InputDecoration(
                    icon: Icon(Icons.timer,color: Color(0xff03c8a8)),
                    labelText: 'Pick Start Voting Date/Time',
                  ),

                  format: format,
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Color(0xff03c8a8),
                              accentColor: Color(0xff03c8a8),
                              colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary
                              ),
                            ),
                            child: child,
                          );
                        },
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                    if (date != null) {
                      final time = await showTimePicker(
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Color(0xff03c8a8),
                              accentColor: Color(0xff03c8a8),
                              colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary
                              ),
                            ),
                            child: child,
                          );
                        },
                        context: context,
                        initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  },
                ),
                SizedBox(height: 10,),
                DateTimeField(
                  controller: endTime,
                  onSaved: (value){endTime.text=value as String;},
                  decoration: InputDecoration(
                    icon: Icon(Icons.more_time,color: Color(0xff03c8a8)),
                    labelText: 'Pick end voting Date/Time',
                  ),

                  format: format,
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Color(0xff03c8a8),
                              accentColor: Color(0xff03c8a8),
                              colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary
                              ),
                            ),
                            child: child,
                          );
                        },
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                    if (date != null) {
                      final time = await showTimePicker(
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Color(0xff03c8a8),
                              accentColor: Color(0xff03c8a8),
                              colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary
                              ),
                            ),
                            child: child,
                          );
                        },
                        context: context,
                        initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  },
                ),
              ]
              else if(text=="Panel Data")...[
                TextFormField(
                    controller: TextEditingController(text:'$val'),


                    decoration: InputDecoration(
                      icon: Icon(Icons.local_activity,color: Color(0xff03c8a8)),
                      labelText: 'Enter Election Type',
                      hintText: "$val",
                    ),
                    onChanged: (value){
                      if(updateElectionTypeController=='')
                      {
                        updateElectionTypeController.text=val;
                      }
                      else{
                        updateElectionTypeController.text=value;
                      }

                    }
                ),
                SizedBox(height: 10,),
                DateTimeField(
                  controller: startTime,
                  onSaved: (value){startTime.text=value as String;},
                  decoration: InputDecoration(
                    icon: Icon(Icons.timer,color: Color(0xff03c8a8)),
                    labelText: 'Pick Start Voting Date/Time',
                  ),

                  format: format,
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Color(0xff03c8a8),
                              accentColor: Color(0xff03c8a8),
                              colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary
                              ),
                            ),
                            child: child,
                          );
                        },
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                    if (date != null) {
                      final time = await showTimePicker(
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Color(0xff03c8a8),
                              accentColor: Color(0xff03c8a8),
                              colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary
                              ),
                            ),
                            child: child,
                          );
                        },
                        context: context,
                        initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  },
                ),
                SizedBox(height: 10,),
                DateTimeField(
                  controller: endTime,
                  onSaved: (value){endTime.text=value as String;},
                  decoration: InputDecoration(
                    icon: Icon(Icons.more_time,color: Color(0xff03c8a8)),
                    labelText: 'Pick end voting Date/Time',
                  ),

                  format: format,
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Color(0xff03c8a8),
                              accentColor: Color(0xff03c8a8),
                              colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary
                              ),
                            ),
                            child: child,
                          );
                        },
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                    if (date != null) {
                      final time = await showTimePicker(
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Color(0xff03c8a8),
                              accentColor: Color(0xff03c8a8),
                              colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary
                              ),
                            ),
                            child: child,
                          );
                        },
                        context: context,
                        initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  },
                ),
              ]
            ]
            else if(type=="delete")...[
              if(text=="Election Data")...[
                Column(
                 children: [
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text("Are you sure you want to delete!",style: TextStyle(fontSize: 15),),
                   ),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text("Voting for $val",style: TextStyle(color: kmainColor,fontSize: 14)),),


                 ],
                ),

              ]
              else if(text=="Panel Data")...[
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Are you sure you want to delete!",style: TextStyle(fontSize: 15),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Voting for $val",style: TextStyle(color: kmainColor,fontSize: 14)),),


                  ],
                ),
              ]
            ]







          ],
        ),
        buttons: [
          if(type=="edit")...[
            DialogButton(
              color: Color(0xff03c8a8),
              onPressed: () {
                editElectionRecord(id, text,updateElectionTypeController.text,startTime.text,endTime.text);
                Fluttertoast.showToast(msg: "Record UPDATED!");
                Navigator.of(context).pop();
              },


              child: Text(
                "UPDATE",
                style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
              ),
            ),
            ]
            else if(type=="delete")...[
              DialogButton(
              color: Color(0xff03c8a8),
              onPressed: () {
                deleteElectionRecord(id,text);
                Fluttertoast.showToast(msg: "Record Deleted!");
                Navigator.of(context).pop();
              },


              child: Text(
                "YES",
                style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),
              ),
            ),
              DialogButton(
              color: Color(0xff03c8a8),
              onPressed: () {

                Navigator.of(context).pop();
              },
              child: Text(
                "NO",
                style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),
              ),
            )
    ]


        ]).show();
  }
  _openPopup3(context,text,val,id) {


    Alert(
        style: AlertStyle(),
        context: context,
        title: "",
        onWillPopActive: true,
        closeIcon: Icon(Icons.close,color: Color(0xff03c8a8)),
        content: Column(
          children: <Widget>[

              if(text=="Election Time")...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Update the voting time of $val"),
                ),
                DateTimeField(
                  controller: startTime,
                  onSaved: (value){startTime.text=value as String;},
                  decoration: InputDecoration(
                    icon: Icon(Icons.timer,color: Color(0xff03c8a8)),
                    labelText: 'Pick Start Voting Date/Time',
                  ),

                  format: format,
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Color(0xff03c8a8),
                              accentColor: Color(0xff03c8a8),
                              colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary
                              ),
                            ),
                            child: child,
                          );
                        },
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                    if (date != null) {
                      final time = await showTimePicker(
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Color(0xff03c8a8),
                              accentColor: Color(0xff03c8a8),
                              colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary
                              ),
                            ),
                            child: child,
                          );
                        },
                        context: context,
                        initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  },
                ),
                SizedBox(height: 10,),
                DateTimeField(
                  controller: endTime,
                  onSaved: (value){endTime.text=value as String;},
                  decoration: InputDecoration(
                    icon: Icon(Icons.more_time,color: Color(0xff03c8a8)),
                    labelText: 'Pick end voting Date/Time',
                  ),

                  format: format,
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Color(0xff03c8a8),
                              accentColor: Color(0xff03c8a8),
                              colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary
                              ),
                            ),
                            child: child,
                          );
                        },
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                    if (date != null) {
                      final time = await showTimePicker(
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Color(0xff03c8a8),
                              accentColor: Color(0xff03c8a8),
                              colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary
                              ),
                            ),
                            child: child,
                          );
                        },
                        context: context,
                        initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  },
                ),
              ]
              else if(text=="Panel Time")...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Update the voting time of $val"),
                ),
                DateTimeField(
                  controller: startTime,
                  onSaved: (value){startTime.text=value as String;},
                  decoration: InputDecoration(
                    icon: Icon(Icons.timer,color: Color(0xff03c8a8)),
                    labelText: 'Pick Start Voting Date/Time',
                  ),

                  format: format,
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Color(0xff03c8a8),
                              accentColor: Color(0xff03c8a8),
                              colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary
                              ),
                            ),
                            child: child,
                          );
                        },
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                    if (date != null) {
                      final time = await showTimePicker(
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Color(0xff03c8a8),
                              accentColor: Color(0xff03c8a8),
                              colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary
                              ),
                            ),
                            child: child,
                          );
                        },
                        context: context,
                        initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  },
                ),
                SizedBox(height: 10,),
                DateTimeField(
                  controller: endTime,
                  onSaved: (value){endTime.text=value as String;},
                  decoration: InputDecoration(
                    icon: Icon(Icons.more_time,color: Color(0xff03c8a8)),
                    labelText: 'Pick end voting Date/Time',
                  ),

                  format: format,
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Color(0xff03c8a8),
                              accentColor: Color(0xff03c8a8),
                              colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary
                              ),
                            ),
                            child: child,
                          );
                        },
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                    if (date != null) {
                      final time = await showTimePicker(
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Color(0xff03c8a8),
                              accentColor: Color(0xff03c8a8),
                              colorScheme: ColorScheme.light(primary: const Color(0xff03c8a8)),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary
                              ),
                            ),
                            child: child,
                          );
                        },
                        context: context,
                        initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  },
                ),
              ]

          ],
        ),
        buttons: [

            DialogButton(
              color: Color(0xff03c8a8),
              onPressed: () {
                updateElectionTime(text, id,startTime.text,endTime.text);
                Fluttertoast.showToast(msg: "Record UPDATED!");
                Navigator.of(context).pop();
              },


              child: Text(
                "UPDATE TIME",
                style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
              ),
            ),



        ]).show();
  }
  postDetailsToFirestore(String Type,String s_time,String e_time) async {
    try{
      Firestore firebaseFirestore = Firestore.instance;
      ElectionModel electionModel = ElectionModel();
      electionModel.name = Type;
      electionModel.Status="OFF";

      electionModel.Start_time=s_time ;
      electionModel.End_time=e_time;
      await firebaseFirestore.collection("ElectionData").document()
          .setData(electionModel.toMap());

    }catch(e){
      Fluttertoast.showToast(msg: e);
      print(e);

    }





  }


  postCandidateDetailsToFirestore(context,String name,id) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(

        context,
        dismissable: false,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));
    if (_formKey.currentState.validate())
      {
        progressDialog.show();
        try{
          Firestore firebaseFirestore = Firestore.instance;
          CandidateModel candidateModel = CandidateModel();
          // writing all the values
          candidateModel.C_name = fullNameController.text;
          candidateModel.C_email = emailController.text;
          candidateModel.C_phoneNo = phoneNoController.text;
          if(RegisterationNoController.text!=null)
          {
            candidateModel.regNo=RegisterationNoController.text;
          }
          else
          {
            candidateModel.depart=deprt_selectedType;
          }

          QuerySnapshot _myDoc = await Firestore.instance.collection('ElectionData').getDocuments();
          List<DocumentSnapshot> _myDocCount = _myDoc.documents;
          for (var item in _myDocCount)
          {
            if(item.documentID==id)
            {
              await firebaseFirestore.collection("ElectionData").document(id)
                  .collection("Candidates").document()
                  .setData(candidateModel.toMap());
              progressDialog.dismiss();
              Fluttertoast.showToast(msg: "Successfully Add Candidate");
              Navigator.of(context).pop();

            }
          }


        }catch(e){
          Fluttertoast.showToast(msg: e);
          print(e);

        }
      }






  }
  postPanelCandidateDetailsToFirestore(context,String name,id) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(

        context,
        dismissable: false,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));
    if (_formKey.currentState.validate())
    {
      progressDialog.show();
      try{
        Firestore firebaseFirestore = Firestore.instance;
        ElectionModel candidateModel = ElectionModel();
        // writing all the values
        candidateModel.name = fullNameController.text;


        QuerySnapshot _myDoc = await Firestore.instance.collection('PanelData').getDocuments();
        List<DocumentSnapshot> _myDocCount = _myDoc.documents;
        for (var item in _myDocCount)
        {
          if(item.documentID==id)
          {
            await firebaseFirestore.collection("PanelData").document(id)
                .collection("Candidates").document()
                .setData(candidateModel.toMap());
            progressDialog.dismiss();
            Fluttertoast.showToast(msg: "Successfully Add Candidate");
            Navigator.of(context).pop();

          }
        }


      }catch(e){
        Fluttertoast.showToast(msg: e);
        print(e);

      }
    }






  }

  postPanelDetailsToFirestore(String Type,String s_time,String e_time) async {
    try{
      if(!Type.isEmpty && !s_time.isEmpty && !e_time.isEmpty)
        {
          Firestore firebaseFirestore = Firestore.instance;
          ElectionModel panelModel = ElectionModel();
          panelModel.name = Type;
          panelModel.Status = "OFF";
          panelModel.Start_time=s_time ;
          panelModel.End_time=e_time;

          await firebaseFirestore.collection("PanelData").document()
              .setData(panelModel.toMap());
        }
      else
        {
          Fluttertoast.showToast(msg: "Kindly provides all the details");
        }


    }catch(e){
      Fluttertoast.showToast(msg: e);
      print(e);

    }





  }
  deleteElectionRecord(id,text) async{
    Firestore firebaseFirestore = Firestore.instance;
    if(text=="Election Data")
      {
        print("Delete");
        var collection = await firebaseFirestore.collection("ElectionData");
        collection
            .document(id) // <-- Doc ID to be deleted.
            .delete();
      }
    else if(text=="Panel Data")
    {
      var collection = await firebaseFirestore.collection("PanelData");
      collection
          .document(id) // <-- Doc ID to be deleted.
          .delete();
    }
  }

  editElectionRecord(id,text,value,String start,String end) async{
    Firestore firebaseFirestore = Firestore.instance;
    if(!value.toString().isEmpty && !start.isEmpty && !end.isEmpty)
      {
        if(text=="Election Data")
        {

          var collection = await firebaseFirestore.collection("ElectionData");
          collection
              .document(id) // <-- Doc ID to be deleted.
              .updateData({
            "name":value,
            "Start_time":start,
            "End_time":end

          });

        }
        else if(text=="Panel Data")
        {
          var collection = await firebaseFirestore.collection("PanelData");
          collection
              .document(id) // <-- Doc ID to be deleted.
              .updateData({
            "name":value,
            "Start_time":start,
            "End_time":end

          });
        }
      }


  }
  updateStatus(String val,id) async {
    try{
      Firestore firebaseFirestore = Firestore.instance;

      var collection = await firebaseFirestore.collection("ElectionData");
      collection
          .document(id) // <-- Doc ID to be deleted.
          .updateData({
        "Status":val

      });

    }catch(e){
      Fluttertoast.showToast(msg: e);
      print(e);

    }
  }
  updatePanelStatus(String val,id) async {
    try{
      Firestore firebaseFirestore = Firestore.instance;

      var collection = await firebaseFirestore.collection("PanelData");
      collection
          .document(id) // <-- Doc ID to be deleted.
          .updateData({
        "Status":val

      });

    }catch(e){
      Fluttertoast.showToast(msg: e);
      print(e);

    }
  }
  updateElectionTime(String val,id,String start,String end) async {
    try{
      Firestore firebaseFirestore = Firestore.instance;
      if(val=="Election Time"){
        var collection = await firebaseFirestore.collection("ElectionData");
        collection
            .document(id) // <-- Doc ID to be deleted.
            .updateData({
          "Start_time":start,
          "End_time":end

        });
      }
      else if(val=="Panel Time"){
        var collection = await firebaseFirestore.collection("PanelData");
        collection
            .document(id) // <-- Doc ID to be deleted.
            .updateData({
          "Start_time":start,
          "End_time":end

        });
      }



    }catch(e){
      Fluttertoast.showToast(msg: e);
      print(e);

    }
  }

}


