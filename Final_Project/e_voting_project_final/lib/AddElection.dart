import 'package:e_voting_project_final/services/contract_linking.dart';
import 'package:e_voting_project_final/ui/widgets/responsive_ui.dart';
import 'package:e_voting_project_final/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:ars_progress_dialog/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Models/ElectionModel.dart';
import 'Pages/GetData.dart';
import 'Pages/resources.dart';
import 'Pages/transactionview.dart';

class AddElection extends StatefulWidget {
  final Map Data;
  final String private;
  final String public;
  final List user;

  const AddElection({Key key, this.private, this.public, this.Data, this.user})
      : super(key: key);

  @override
  _Candidate_Form createState() => _Candidate_Form();
}

class _Candidate_Form extends State<AddElection>
    with SingleTickerProviderStateMixin {
  static List<Users> _users = [];
  static const String routeName = '/categories';
  final _formKey = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  String selectedSalutation;
  Color colorGreen = Color(0xff03c8a8);
  Color colorGrey = Colors.grey;
  final _formKey2 = GlobalKey<FormState>();
  final Map<String, IconData> depart_data = Map.fromIterables([
    'Computer Science',
    'Electrical Engineering',
    'Business & Management',
    'Mathematics'
  ], [
    Icons.apartment,
    Icons.apartment,
    Icons.apartment,
    Icons.apartment
  ]);

  final icons = [
    Icons.arrow_right_alt,
    Icons.arrow_right_alt,
    Icons.arrow_right_alt
  ];
  TabController _controller;
  int _selectedIndex = 0;

  List<Widget> list = [
    Tab(
        child: Text('Elections',
            style: TextStyle(color: Colors.white, fontSize: 16))),
  ];

  @override
  void initState() {
    // TODO: implement initState
    _getAddress();
    print(widget.Data);
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
  final electionTypeController = new TextEditingController();
  final startTime = new TextEditingController();
  final endTime = new TextEditingController();
  List<Users> _seletedCandidates = [];
  List<Users> _seletedVoters = [];
/*
  DateTime startTime;
  DateTime endTime;*/
  final candidateNameController = new TextEditingController();
  final candidateProposal = new TextEditingController();
  final updateElectionTypeController = new TextEditingController();
  final updatePanelTypeController = new TextEditingController();
  final fullNameController = new TextEditingController();
  final RegisterationNoController = new TextEditingController();
  final emailController = new TextEditingController();
  final phoneNoController = new TextEditingController();
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  String errorMessage = '';

  String deprt_selectedType;
  String selectedValue;
  IconData deprt_selectedIcon;

  final roundShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(15),
        bottomLeft: Radius.circular(15),
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15)),
  );
  final _auth = FirebaseAuth.instance;
  final database = Firestore.instance;
  String name;
  String p_name;
  String status;
  String start_time;
  String end_time;
  String p_status;
  String state;

  DateTime S_time;
  DateTime E_time;
  String pub_address;
  String candidate_name;

  String candidate_email;
  String candidate_phoneNo;
  String candidate_RegNo;
  String candidate_depart;
  var pub_addList = [];
  var mylist = [];
  var candidates_data = [];
  var candidate_keys = [];
  var C_identifier = new Map();
  var candidates_list = [];
  var _list = [];
  var p_list = [];
  var Candidate_identifier = new Map();
  var identifier = new Map();
  var P_identifier = new Map();
  var Type_identifier = new Map();

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
        candidate_keys.add(item.documentID);
        candidate_keys.add(name);
        candidate_keys.add(status);
        candidate_keys.add(difference);
        final starting_diff = S_time.difference(DateTime.now()).inSeconds;
        candidate_keys.add(starting_diff);
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
    print(Candidate_identifier);
  }

  _getAddress() async {
    QuerySnapshot _myDoc =
        await Firestore.instance.collection('Blockchain').getDocuments();
    List<DocumentSnapshot> _myDocCount = _myDoc.documents;
    for (var item in _myDocCount) {
      await database
          .collection("Blockchain")
          .document(item.documentID)
          .get()
          .then((value) {
        pub_address = value.data['address'].toString();
        pub_addList.add(pub_address);
      }).catchError((e) {
        print(e);
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    var contractLink = Provider.of<ContractLinking>(context);

    final _items = widget.user
        .map((user) => MultiSelectItem<Users>(user, user.name))
        .toList();

    /*ProgressDialog _progressDialog = ProgressDialog();*/
    ArsProgressDialog progressDialog2 = ArsProgressDialog(context,
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
        title: Text(
          'Add Elections',
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
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
          RefreshIndicator(
            child: SingleChildScrollView(
              child: Container(
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      // 60%
                      child: Container(
                        child: Column(
                          children: [
                            // ignore: deprecated_member_use
                            RaisedButton(
                                onPressed: () {
                                  Alert(
                                      style: AlertStyle(),
                                      context: context,
                                      title: "",
                                      onWillPopActive: true,
                                      closeIcon: Icon(Icons.close,
                                          color: Color(0xff03c8a8)),
                                      content: Column(
                                        children: <Widget>[
                                          Material(
                                            color: Colors.grey,
                                            elevation: 5,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Center(
                                                  child: Text(
                                                    "ADD ELECTION"
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        letterSpacing: 1.5,
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "e.g President of Sport Week",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black12),
                                            ),
                                          ),
                                          Form(
                                            autovalidateMode:
                                                AutovalidateMode.always,
                                            key: _formKey2,
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                    controller:
                                                        electionTypeController,
                                                    decoration: InputDecoration(
                                                      icon: Icon(
                                                          Icons.local_activity,
                                                          color: Color(
                                                              0xff03c8a8)),
                                                      labelText:
                                                          'Enter Election Type',
                                                    ),
                                                    validator: (value) {
                                                      RegExp regExp =
                                                          new RegExp(
                                                              r'^.{5,}$');
                                                      if (value.isEmpty) {
                                                        return ("Election Name is Required");
                                                      }
                                                      if (!regExp
                                                          .hasMatch(value)) {
                                                        return ("Enter Valid Name (Min. 3 Characters)");
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      electionTypeController
                                                          .text = value;
                                                    }),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                DateTimeField(
                                                  controller: startTime,
                                                  onSaved: (value) {
                                                    startTime.text =
                                                        value as String;
                                                  },
                                                  decoration: InputDecoration(
                                                    icon: Icon(Icons.timer,
                                                        color:
                                                            Color(0xff03c8a8)),
                                                    labelText:
                                                        'Pick Start Voting Date/Time',
                                                  ),
                                                  format: format,
                                                  validator: (value) {
                                                    if (value == null) {
                                                      return 'Please enter a Date and Time';
                                                    }
                                                    return null;
                                                  },
                                                  onShowPicker: (context,
                                                      currentValue) async {
                                                    final date =
                                                        await showDatePicker(
                                                            builder:
                                                                (BuildContext
                                                                        context,
                                                                    Widget
                                                                        child) {
                                                              return Theme(
                                                                data: ThemeData
                                                                        .light()
                                                                    .copyWith(
                                                                  primaryColor:
                                                                      Color(
                                                                          0xff03c8a8),
                                                                  accentColor:
                                                                      Color(
                                                                          0xff03c8a8),
                                                                  colorScheme:
                                                                      ColorScheme.light(
                                                                          primary:
                                                                              const Color(0xff03c8a8)),
                                                                  buttonTheme: ButtonThemeData(
                                                                      textTheme:
                                                                          ButtonTextTheme
                                                                              .primary),
                                                                ),
                                                                child: child,
                                                              );
                                                            },
                                                            context: context,
                                                            firstDate:
                                                                DateTime(1900),
                                                            initialDate:
                                                                currentValue ??
                                                                    DateTime
                                                                        .now(),
                                                            lastDate:
                                                                DateTime(2100));
                                                    if (date != null) {
                                                      final time =
                                                          await showTimePicker(
                                                        builder: (BuildContext
                                                                context,
                                                            Widget child) {
                                                          return Theme(
                                                            data: ThemeData
                                                                    .light()
                                                                .copyWith(
                                                              primaryColor: Color(
                                                                  0xff03c8a8),
                                                              accentColor: Color(
                                                                  0xff03c8a8),
                                                              colorScheme:
                                                                  ColorScheme.light(
                                                                      primary:
                                                                          const Color(
                                                                              0xff03c8a8)),
                                                              buttonTheme:
                                                                  ButtonThemeData(
                                                                      textTheme:
                                                                          ButtonTextTheme
                                                                              .primary),
                                                            ),
                                                            child: child,
                                                          );
                                                        },
                                                        context: context,
                                                        initialTime: TimeOfDay
                                                            .fromDateTime(
                                                                currentValue ??
                                                                    DateTime
                                                                        .now()),
                                                      );
                                                      return DateTimeField
                                                          .combine(date, time);
                                                    } else {
                                                      return currentValue;
                                                    }
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                DateTimeField(
                                                  controller: endTime,
                                                  onSaved: (value) {
                                                    endTime.text =
                                                        value as String;
                                                  },
                                                  decoration: InputDecoration(
                                                    icon: Icon(Icons.more_time,
                                                        color:
                                                            Color(0xff03c8a8)),
                                                    labelText:
                                                        'Pick end voting Date/Time',
                                                  ),
                                                  format: format,
                                                  validator: (value) {
                                                    if (value == null) {
                                                      return 'Please enter a Date and Time';
                                                    }
                                                    return null;
                                                  },
                                                  onShowPicker: (context,
                                                      currentValue) async {
                                                    final date =
                                                        await showDatePicker(
                                                            builder:
                                                                (BuildContext
                                                                        context,
                                                                    Widget
                                                                        child) {
                                                              return Theme(
                                                                data: ThemeData
                                                                        .light()
                                                                    .copyWith(
                                                                  primaryColor:
                                                                      Color(
                                                                          0xff03c8a8),
                                                                  accentColor:
                                                                      Color(
                                                                          0xff03c8a8),
                                                                  colorScheme:
                                                                      ColorScheme.light(
                                                                          primary:
                                                                              const Color(0xff03c8a8)),
                                                                  buttonTheme: ButtonThemeData(
                                                                      textTheme:
                                                                          ButtonTextTheme
                                                                              .primary),
                                                                ),
                                                                child: child,
                                                              );
                                                            },
                                                            context: context,
                                                            firstDate:
                                                                DateTime(1900),
                                                            initialDate:
                                                                currentValue ??
                                                                    DateTime
                                                                        .now(),
                                                            lastDate:
                                                                DateTime(2100));
                                                    if (date != null) {
                                                      final time =
                                                          await showTimePicker(
                                                        builder: (BuildContext
                                                                context,
                                                            Widget child) {
                                                          return Theme(
                                                            data: ThemeData
                                                                    .light()
                                                                .copyWith(
                                                              primaryColor: Color(
                                                                  0xff03c8a8),
                                                              accentColor: Color(
                                                                  0xff03c8a8),
                                                              colorScheme:
                                                                  ColorScheme.light(
                                                                      primary:
                                                                          const Color(
                                                                              0xff03c8a8)),
                                                              buttonTheme:
                                                                  ButtonThemeData(
                                                                      textTheme:
                                                                          ButtonTextTheme
                                                                              .primary),
                                                            ),
                                                            child: child,
                                                          );
                                                        },
                                                        context: context,
                                                        initialTime: TimeOfDay
                                                            .fromDateTime(
                                                                currentValue ??
                                                                    DateTime
                                                                        .now()),
                                                      );
                                                      return DateTimeField
                                                          .combine(date, time);
                                                    } else {
                                                      return currentValue;
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      buttons: [
                                        DialogButton(
                                          color: Color(0xff03c8a8),
                                          onPressed: () {
                                            if (_formKey2.currentState
                                                .validate()) {
                                              contractLink.startElection(
                                                  electionTypeController.text,
                                                  widget.public
                                                      .trim()
                                                      .toString());
                                              postDetailsToFirestore(
                                                  electionTypeController.text,
                                                  startTime.text,
                                                  endTime.text);
                                              Fluttertoast.showToast(
                                                  msg: "Successfully Save",
                                                  backgroundColor: kmainColor,
                                                  textColor: Colors.white);
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: Text(
                                            "SAVE",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ]).show();
                                },
                                color: Color(0xff03c8a8),
                                shape: roundShape,
                                elevation: 10,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Add Election ',
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
                                )),
                            SizedBox(height: 20),
                            Container(
                              height: 3,
                              color: Colors.black12,
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  "Election Details/Types",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xff03c8a8)),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 3,
                              color: Colors.black12,
                            ),

                            SizedBox(height: 20),
                            Card(
                              color: Colors.grey[300],
                              elevation: 8.0,
                              child: contractLink.isLoading
                                  ? LinearProgressIndicator()
                                  : Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 16),
                                      child: Column(
                                        children: [
                                          if (contractLink.electionState ==
                                              "ONGOING") ...[
                                            Row(
                                              children: [
                                                Small_Text(
                                                  text: "Election Name: ",
                                                ),
                                                Small_Text(
                                                  text: "    " +
                                                      contractLink.electionName,
                                                  color: kmainColor,
                                                  latterSpacing: 0.5,
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Small_Text(
                                                  text: "Election Start Date: ",
                                                ),
                                                Small_Text(
                                                  text: "    " +
                                                      contractLink
                                                          .electionState,
                                                  color: kmainColor,
                                                  latterSpacing: 0.5,
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Alert(
                                                          style: AlertStyle(),
                                                          context: context,
                                                          title: "",
                                                          onWillPopActive: true,
                                                          closeIcon: Icon(
                                                              Icons.close,
                                                              color: Color(
                                                                  0xff03c8a8)),
                                                          content: Column(
                                                            children: <Widget>[
                                                              Material(
                                                                color:
                                                                    Colors.grey,
                                                                elevation: 5,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            10),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "ADD Candidate"
                                                                            .toUpperCase(),
                                                                        style: TextStyle(
                                                                            letterSpacing:
                                                                                1.5,
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Text(
                                                                  "e.g select candidate",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black12),
                                                                ),
                                                              ),
                                                              Form(
                                                                key: _formKey2,
                                                                autovalidateMode: AutovalidateMode.always,
                                                                child: Column(
                                                                  children: [
                                                                    DropdownButtonFormField<String>(
                                                                        value:
                                                                            selectedSalutation,
                                                                        hint:
                                                                            Text(
                                                                          'Salutation',
                                                                        ),
                                                                        onChanged: (salutation) => setState(() =>
                                                                            selectedSalutation =
                                                                                salutation),
                                                                        validator: (value) => value == null ? 'field required' : null,
                                                                        items: ['MR.','MS.','Dr.'].map<DropdownMenuItem<String>>((String value) {
                                                                          return DropdownMenuItem<String>(
                                                                            value:  value,
                                                                            child: Text(value),
                                                                          );
                                                                        }).toList(),
                                                                        decoration:
                                                                        InputDecoration(
                                                                            prefixIcon: Icon(Icons.person_pin_outlined,
                                                                                color: Color(0xff03c8a8),
                                                                                size: 20),
                                                                            contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                                                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)))),

                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    MultiSelectDialogField(

                                                                      items:
                                                                          _items,
                                                                      title: Text(
                                                                          "Users"),
                                                                      selectedColor: kmainColor,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .green
                                                                            .withOpacity(0.1),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(20)),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              kmainColor,
                                                                          width:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                      buttonIcon:
                                                                          Icon(
                                                                        Icons
                                                                            .supervised_user_circle,
                                                                        color:
                                                                            kmainColor,
                                                                      ),
                                                                      buttonText:
                                                                          Text(
                                                                        "Select Candidates",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.green[200],
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                                null ||
                                                                            value.length ==
                                                                                0) {
                                                                          return 'Please select one or more options';
                                                                        }
                                                                        return null;
                                                                      },
                                                                      onConfirm:
                                                                          (results) {
                                                                        _seletedCandidates = results;
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          buttons: [
                                                            DialogButton(
                                                              color: Color(
                                                                  0xff03c8a8),
                                                              onPressed: () {
                                                                contractLink.addCandidate(_seletedCandidates,widget.public.trim().toString());

                                                          Navigator.of(
                                                              context)
                                                              .pop();

                                                                /*postDetailsToFirestore(electionTypeController.text,startTime.text,endTime.text);
                                                                Fluttertoast.showToast(msg: "Successfully Save");
                                                                 Navigator.of(context).pop();*/
                                                              },
                                                              child: Text(
                                                                "SAVE",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            )
                                                          ]).show();
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(kmainColor),
                                                    ),
                                                    child: Center(
                                                        child: Small_Text(
                                                      text: "Add Candidate",
                                                      color: Colors.white,
                                                    ))),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Alert(
                                                          style: AlertStyle(),
                                                          context: context,
                                                          title: "",
                                                          onWillPopActive: true,
                                                          closeIcon: Icon(
                                                              Icons.close,
                                                              color: Color(
                                                                  0xff03c8a8)),
                                                          content: Column(
                                                            children: <Widget>[
                                                              Material(
                                                                color:
                                                                    Colors.grey,
                                                                elevation: 5,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            10),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "Authorized Voter"
                                                                            .toUpperCase(),
                                                                        style: TextStyle(
                                                                            letterSpacing:
                                                                                1.5,
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Text(
                                                                  "Select Voter key to Athorized for Voting",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black12),
                                                                ),
                                                              ),
                                                              MultiSelectDialogField(
                                                                items: _items,
                                                                title: Text(
                                                                    "Users"),
                                                                selectedColor:
                                                                    kmainColor,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .greenAccent
                                                                      .withOpacity(
                                                                          0.1),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10)),
                                                                  border: Border
                                                                      .all(
                                                                    color:
                                                                        kmainColor,
                                                                    width: 2,
                                                                  ),
                                                                ),
                                                                buttonIcon:
                                                                    Icon(
                                                                  Icons
                                                                      .supervised_user_circle,
                                                                  color:
                                                                      kmainColor,
                                                                ),
                                                                buttonText:
                                                                    Text(
                                                                  "Select Voter",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                            .green[
                                                                        200],
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                                onConfirm:
                                                                    (results) {
                                                                  _seletedVoters = results;
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                          buttons: [
                                                            DialogButton(
                                                              color: Color(
                                                                  0xff03c8a8),
                                                              onPressed: () {
                                                                print("Voters===> ");

                                                                    contractLink.addVoter(_seletedVoters,
                                                                        selectedValue,
                                                                        widget
                                                                            .public
                                                                            .trim()
                                                                            .toString());






                                                                Navigator.of(
                                                                        context)
                                                                    .pop();

                                                                /*postDetailsToFirestore(electionTypeController.text,startTime.text,endTime.text);
                  Fluttertoast.showToast(msg: "Successfully Save");
                  Navigator.of(context).pop();*/
                                                              },
                                                              child: Text(
                                                                "SAVE",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            )
                                                          ]).show();
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(kmainColor),
                                                    ),
                                                    child: Center(
                                                        child: Small_Text(
                                                      text:
                                                          "    Add Voters    ",
                                                      color: Colors.white,
                                                    )))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      contractLink.endElection(
                                                          widget.public
                                                              .trim()
                                                              .toString());
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors.red),
                                                    ),
                                                    child: Center(
                                                        child: Small_Text(
                                                      text:
                                                          "        End Election        ",
                                                      color: Colors.white,
                                                    ))),
                                              ],
                                            ),
                                          ] else ...[
                                            Center(
                                                child: Text(
                                                    "Currently No Election Available!")),
                                          ],
                                        ],
                                      ),
                                    ),
                            ),

                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
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

  _myData() {}

  postDetailsToFirestore(String Type, String s_time, String e_time) async {
    try {
      Firestore firebaseFirestore = Firestore.instance;
      String docId = Firestore.instance
          .collection("ElectionData")
          .document()
          .documentID;

      ElectionModel electionModel = ElectionModel();
      electionModel.name = Type;
      electionModel.Status = "OFF";
      electionModel.uid = docId;

      electionModel.Start_time = s_time;
      electionModel.End_time = e_time;
      await firebaseFirestore
          .collection("ElectionData")
          .document(docId)
          .setData(electionModel.toMap());
    } catch (e) {
      Fluttertoast.showToast(msg: e);
      print(e);
    }
  }

  postCandidateDetailsToFirestore(context, String name, id) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        dismissable: false,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));
    if (_formKey.currentState.validate()) {
      progressDialog.show();
      try {
        Firestore firebaseFirestore = Firestore.instance;
        CandidateModel candidateModel = CandidateModel();
        // writing all the values
        candidateModel.C_name = fullNameController.text;
        candidateModel.C_email = emailController.text;
        candidateModel.C_phoneNo = phoneNoController.text;
        if (RegisterationNoController.text != null) {
          candidateModel.regNo = RegisterationNoController.text;
        } else {
          candidateModel.depart = deprt_selectedType;
        }

        QuerySnapshot _myDoc =
            await Firestore.instance.collection('ElectionData').getDocuments();
        List<DocumentSnapshot> _myDocCount = _myDoc.documents;
        for (var item in _myDocCount) {
          if (item.documentID == id) {
            await firebaseFirestore
                .collection("ElectionData")
                .document(id)
                .collection("Candidates")
                .document()
                .setData(candidateModel.toMap());
            progressDialog.dismiss();
            Fluttertoast.showToast(msg: "Successfully Add Candidate");
            Navigator.of(context).pop();
          }
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e);
        print(e);
      }
    }
  }

  postPanelCandidateDetailsToFirestore(context, String name, id) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        dismissable: false,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));
    if (_formKey.currentState.validate()) {
      progressDialog.show();
      try {
        Firestore firebaseFirestore = Firestore.instance;
        ElectionModel candidateModel = ElectionModel();
        // writing all the values
        candidateModel.name = fullNameController.text;

        QuerySnapshot _myDoc =
            await Firestore.instance.collection('PanelData').getDocuments();
        List<DocumentSnapshot> _myDocCount = _myDoc.documents;
        for (var item in _myDocCount) {
          if (item.documentID == id) {
            await firebaseFirestore
                .collection("PanelData")
                .document(id)
                .collection("Candidates")
                .document()
                .setData(candidateModel.toMap());
            progressDialog.dismiss();
            Fluttertoast.showToast(msg: "Successfully Add Candidate");
            Navigator.of(context).pop();
          }
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e);
        print(e);
      }
    }
  }

  postPanelDetailsToFirestore(String Type, String s_time, String e_time) async {
    try {
      if (!Type.isEmpty && !s_time.isEmpty && !e_time.isEmpty) {
        Firestore firebaseFirestore = Firestore.instance;
        ElectionModel panelModel = ElectionModel();
        panelModel.name = Type;
        panelModel.Status = "OFF";
        panelModel.Start_time = s_time;
        panelModel.End_time = e_time;

        await firebaseFirestore
            .collection("PanelData")
            .document()
            .setData(panelModel.toMap());
      } else {
        Fluttertoast.showToast(msg: "Kindly provides all the details");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e);
      print(e);
    }
  }

  deleteElectionRecord(id, text) async {
    Firestore firebaseFirestore = Firestore.instance;
    if (text == "Election Data") {
      print("Delete");
      var collection = await firebaseFirestore.collection("ElectionData");
      collection
          .document(id) // <-- Doc ID to be deleted.
          .delete();
    } else if (text == "Panel Data") {
      var collection = await firebaseFirestore.collection("PanelData");
      collection
          .document(id) // <-- Doc ID to be deleted.
          .delete();
    }
  }

  editElectionRecord(id, text, value, String start, String end) async {
    Firestore firebaseFirestore = Firestore.instance;
    if (!value.toString().isEmpty && !start.isEmpty && !end.isEmpty) {
      if (text == "Election Data") {
        var collection = await firebaseFirestore.collection("ElectionData");
        collection.document(id) // <-- Doc ID to be deleted.
            .updateData({"name": value, "Start_time": start, "End_time": end});
      } else if (text == "Panel Data") {
        var collection = await firebaseFirestore.collection("PanelData");
        collection.document(id) // <-- Doc ID to be deleted.
            .updateData({"name": value, "Start_time": start, "End_time": end});
      }
    }
  }

  updateStatus(String val, id) async {
    try {
      Firestore firebaseFirestore = Firestore.instance;

      var collection = await firebaseFirestore.collection("ElectionData");
      collection.document(id) // <-- Doc ID to be deleted.
          .updateData({"Status": val});
    } catch (e) {
      Fluttertoast.showToast(msg: e);
      print(e);
    }
  }

  updatePanelStatus(String val, id) async {
    try {
      Firestore firebaseFirestore = Firestore.instance;

      var collection = await firebaseFirestore.collection("PanelData");
      collection.document(id) // <-- Doc ID to be deleted.
          .updateData({"Status": val});
    } catch (e) {
      Fluttertoast.showToast(msg: e);
      print(e);
    }
  }

  updateElectionTime(String val, id, String start, String end) async {
    try {
      Firestore firebaseFirestore = Firestore.instance;
      if (val == "Election Time") {
        var collection = await firebaseFirestore.collection("ElectionData");
        collection.document(id) // <-- Doc ID to be deleted.
            .updateData({"Start_time": start, "End_time": end});
      } else if (val == "Panel Time") {
        var collection = await firebaseFirestore.collection("PanelData");
        collection.document(id) // <-- Doc ID to be deleted.
            .updateData({"Start_time": start, "End_time": end});
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e);
      print(e);
    }
  }
}
