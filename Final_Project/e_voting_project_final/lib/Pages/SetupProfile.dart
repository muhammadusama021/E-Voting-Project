import 'package:ars_progress_dialog/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:e_voting_project_final/Models/userModel.dart';
import 'package:e_voting_project_final/Pages/transactionview.dart';
import 'package:e_voting_project_final/ui/signin.dart';

class StepperDemo extends StatefulWidget {
  @override
  _StepperDemoState createState() => _StepperDemoState();
}

class _StepperDemoState extends State<StepperDemo> {
  List<GlobalKey<FormState>> _formKeys = [GlobalKey<FormState>(), GlobalKey<FormState>(),GlobalKey<FormState>()];


  bool assign;
  var rec=[];
  _fetch2() async
  {
    QuerySnapshot _myDoc = await Firestore.instance.collection('Blockchain').getDocuments();
    List<DocumentSnapshot> _myDocCount = _myDoc.documents;
    for (var item in _myDocCount)
    {
      await Firestore.instance.collection("Blockchain").document(item.documentID).get().then((value)
      {
        assign=value.data['isAssigned'];
        if(assign==false)
        {
          rec.add(item.documentID);
        }

      }).catchError((e)
      {
        print(e);
      });

    }
    print(rec);


  }



  final Map<String, IconData> _data = Map.fromIterables(
      ['Computer Science', 'Electrical Engineering', 'Business & Management','Mathematics'],
      [Icons.apartment, Icons.apartment, Icons.apartment,Icons.apartment]);

  final RegisterationNoController=new TextEditingController();
  final permanentAddressController=new TextEditingController();
  final PresentAddressController=new TextEditingController();
  final departmentNameController=new TextEditingController();
  final CnicController = new TextEditingController();
  final organizationController=new TextEditingController();

  var tc = MaskedTextController(mask: '##00-###-000');
  var maskFormatter = new MaskTextInputFormatter(mask: 'aa##-aaa-####', filter: { "a": RegExp(r'[a-zA-z]'),"#":RegExp(r'[0-9]') });
  var CNICmaskFormatter = new MaskTextInputFormatter(mask: '#####-#######-#', filter: {"#":RegExp(r'[0-9]')});

  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  final _auth = FirebaseAuth.instance;
  final database =Firestore.instance;
  String name;
  String email;
  String phoneNo;
  String choice='VOTER';
  String value;
  String _selectedType;
  IconData _selectedIcon;

  get isActive => null;

  _fetch() async
  {
    final FirebaseUser firebaseUser = await _auth.currentUser();
    if(firebaseUser != null)
    {
      await database.collection("Users").document(firebaseUser.uid).get().then((value)
      {
        setState(() {
          name=value.data['name'];
          email=value.data['email'];
          phoneNo=value.data['phoneNo'];
        });


      }).catchError((e)
      {
        print(e);
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _fetch2();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff03c8a8),
        automaticallyImplyLeading: false,
        title: Text('Complete your profile',
          style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body:  Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10,bottom: 10),
              child: CustomRadioButton(
                spacing: 20,
                enableShape: true,
                elevation: 5,
                width: 140,
                radius: 20,
                absoluteZeroSpacing: true,
                padding: 10,
                unSelectedColor: Theme.of(context).canvasColor,
                buttonLables: [
                  'Voter',
                  'Organizer',
                ],
                buttonValues: [
                  "VOTER",
                  "ORGANIZER",
                ],
                defaultSelected: choice,
                buttonTextStyle: ButtonTextStyle(
                    selectedColor: Colors.white,
                    unSelectedColor: Colors.black,
                    textStyle: TextStyle(fontSize: 16)),

                radioButtonValue: (value) {
                  setState(() {
                    choice=value;
                  });
                },
                unSelectedBorderColor: Colors.white,
                selectedBorderColor: Color(0xff03c8a8),
                selectedColor: Color(0xff03c8a8),
              ),
            ),
            FutureBuilder(
                future: _fetch(),
                builder: (context, snapshot)
                {
                  if(choice=='VOTER')
                  {
                    return new Expanded(
                      child: Stepper(
                        type: StepperType.vertical,
                        physics: ScrollPhysics(),
                        currentStep: _currentStep,
                        onStepTapped: (step) => tapped(step),
                          onStepContinue:  (){
                            setState(() {
                              if (_formKeys[_currentStep].currentState.validate()) {
                                _currentStep++;
                              }
                              continued;
                            });},
                        onStepCancel: cancel,
                        steps: <Step>[
                          Step(
                            title: new Text('Account'),
                            content: Column(
                              children: <Widget>[
                                Form(
                                  key: _formKeys[0],
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        enabled: false,
                                        controller: TextEditingController(text: '$name'),
                                        decoration: InputDecoration(
                                          labelText: 'Full Name',


                                        ),
                                      ),
                                      TextFormField(
                                        enabled: false,
                                        controller: TextEditingController(text: '$email'),
                                        decoration: InputDecoration(
                                          labelText: 'Email',

                                        ),
                                      ),
                                      TextFormField(
                                        controller: RegisterationNoController,
                                        inputFormatters: [
                                          maskFormatter
                                        ],
                                        validator: (value) {
                                          RegExp regExp = new RegExp(r'^.{11,}$');
                                          if(value.isEmpty)
                                          {
                                            return ("RegNo Required");
                                          }
                                          if(!regExp.hasMatch(value)){
                                            return ("Enter Valid Registration no");}
                                          return null;
                                        },
                                        onSaved: (value){RegisterationNoController.text=maskFormatter.getMaskedText();},
                                        decoration: InputDecoration(
                                          labelText: 'Registration Number',
                                          hintText: 'e.g. fa18-bse-021',

                                        ),
                                      ),

                                      SizedBox(height: 20),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child:Text(
                                          "Select your Department",
                                          style: TextStyle(
                                              color: Color(0xff03c8a8),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DropdownButtonHideUnderline(

                                  child: DropdownButton<String>(
                                      style: TextStyle(
                                          color: Color(0xff03c8a8)
                                      ),

                                      items: _data.keys.map((String val) {
                                        return DropdownMenuItem<String>(
                                          value: val,
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                                child: Icon(_data[val],color: Color(0xff03c8a8),),
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
                                            Icon(_selectedIcon ?? _data.values.toList()[0],color: Color(0xff03c8a8),),
                                          ),

                                          Text(

                                            _selectedType ?? "Select your Department ",
                                            style: TextStyle(
                                                color: Color(0xff03c8a8),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),

                                      onChanged: (String val) {
                                        setState(() {
                                          _selectedType = val;
                                          _selectedIcon = _data[val];
                                        });
                                      }),
                                ),

                              ],
                            ),
                            isActive: _currentStep >= 0,
                            state: _currentStep >= 0 ?
                            StepState.complete : StepState.disabled,
                          ),
                          Step(
                            title: new Text('Address'),
                            content: Column(
                              children: <Widget>[
                                Form(
                                    key: _formKeys[1],
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: permanentAddressController,

                                          validator: (value) {
                                            RegExp regExp = new RegExp(r'^.{5,}$');

                                            if(!regExp.hasMatch(value)){
                                              return ("Enter Valid Address (Min. 5 Characters)");}
                                            return null;
                                          },
                                          onSaved: (value){permanentAddressController.text=value;},
                                          decoration: InputDecoration(labelText: 'Permanent Address'),
                                        ),
                                        TextFormField(
                                          controller: PresentAddressController,

                                          validator: (value) {
                                            RegExp regExp = new RegExp(r'^.{5,}$');

                                            if(!regExp.hasMatch(value)){
                                              return ("Enter Valid Address (Min. 5 Characters)");}
                                            return null;
                                          },
                                          onSaved: (value){PresentAddressController.text=value;},
                                          decoration: InputDecoration(labelText: 'Postal Address'),
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                            isActive: _currentStep >= 0,
                            state: _currentStep >= 1 ?
                            StepState.complete : StepState.disabled,
                          ),
                          Step(
                            title: new Text('Mobile Number'),
                            content: Column(
                              children: <Widget>[
                                Form(
                                    key: _formKeys[2],
                                    child:
                                    Column(children: [
                                      TextFormField(
                                        controller: TextEditingController(text: '$phoneNo'),
                                        decoration: InputDecoration(labelText: 'Mobile Number'),
                                      ),
                                    ],)),
                              ],
                            ),
                            isActive:_currentStep >= 0,
                            state: _currentStep >= 2 ?
                            StepState.complete : StepState.disabled,
                          ),
                        ],
                      ),
                    );
                  }

                  else if(choice=='ORGANIZER')
                  {
                    return Expanded(
                      child: Stepper(
                        type: StepperType.vertical,
                        physics: ScrollPhysics(),
                        currentStep: _currentStep,
                        onStepTapped: (step) => tapped(step),
                        onStepContinue:  (){
                          setState(() {
                            if (_formKeys[_currentStep].currentState.validate()) {
                              _currentStep++;
                            }
                            continued;
                          });},
                        onStepCancel: cancel,
                        steps: <Step>[
                          Step(
                            title: new Text('Account'),
                            content: Column(
                              children: <Widget>[
                                Form(
                                  key: _formKeys[0],
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        enabled: false,
                                        controller: TextEditingController(text: '$name'),
                                        decoration: InputDecoration(
                                          labelText: 'Full Name',


                                        ),
                                      ),
                                      TextFormField(
                                        enabled: false,
                                        controller: TextEditingController(text: '$email'),
                                        decoration: InputDecoration(
                                          labelText: 'Email',

                                        ),
                                      ),
                                      TextFormField(
                                        controller: CnicController,
                                        inputFormatters: [
                                          CNICmaskFormatter
                                        ],
                                        validator: (value) {
                                          RegExp regExp = new RegExp(r'^.{13,}$');
                                          if(value.isEmpty)
                                          {
                                            return ("CNIC Required");
                                          }
                                          if(!regExp.hasMatch(value)){
                                            return ("Enter Valid CNIC No (Min. 13 Characters)");}
                                          return null;
                                        },
                                        onSaved: (value){CnicController.text=CNICmaskFormatter.getMaskedText();},
                                        decoration: InputDecoration(
                                          labelText: 'CNIC No',
                                          hintText: 'e.g. 37204-2345674-1',

                                        ),
                                      ),
                                      TextFormField(
                                        controller: organizationController,

                                        validator: (value) {

                                          if(value.isEmpty)
                                          {
                                            return ("Organization Name is Required");
                                          }
                                          return null;
                                        },
                                        onSaved: (value){organizationController.text=value;},
                                        decoration: InputDecoration(
                                          labelText: 'Organization Name',
                                          hintText: 'Enter Organization name',
                                        ),
                                      ),
                                    ],
                                  ),
                                )


                              ],
                            ),
                            isActive: _currentStep >= 0,
                            state: _currentStep >= 0 ?
                            StepState.complete : StepState.disabled,
                          ),
                          Step(
                            title: new Text('Address'),
                            content: Column(
                              children: <Widget>[
                                Form(
                                  key: _formKeys[1],
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: permanentAddressController,

                                        validator: (value) {
                                          RegExp regExp = new RegExp(r'^.{5,}$');

                                          if(!regExp.hasMatch(value)){
                                            return ("Enter Valid Address (Min. 5 Characters)");}
                                          return null;
                                        },
                                        onSaved: (value){permanentAddressController.text=value;},
                                        decoration: InputDecoration(labelText: 'Permanent Address'),
                                      ),
                                      TextFormField(
                                        controller: PresentAddressController,

                                        validator: (value) {
                                          RegExp regExp = new RegExp(r'^.{5,}$');

                                          if(!regExp.hasMatch(value)){
                                            return ("Enter Valid Address (Min. 5 Characters)");}
                                          return null;
                                        },
                                        onSaved: (value){PresentAddressController.text=value;},
                                        decoration: InputDecoration(labelText: 'Postal Address'),
                                      ),
                                    ],
                                  ),
                                )


                              ],
                            ),
                            isActive: _currentStep >= 0,
                            state: _currentStep >= 1 ?
                            StepState.complete : StepState.disabled,
                          ),
                          Step(
                            title: new Text('Mobile Number'),
                            content: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: TextEditingController(text: '$phoneNo'),
                                  decoration: InputDecoration(labelText: 'Mobile Number'),
                                ),
                              ],
                            ),
                            isActive:_currentStep >= 0,
                            state: _currentStep >= 2 ?
                            StepState.complete : StepState.disabled,
                          ),
                        ],
                      ),
                    );
                  }
                }
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
                child: Text('Save Details', style: TextStyle(fontSize: 20.0),),
                color: Color(0xff03c8a8),
                textColor: Colors.white,
                onPressed: () {
                  if(choice=='VOTER')
                  {ArsProgressDialog progressDialog = ArsProgressDialog(
                      context,
                      blur: 2,
                      backgroundColor: Color(0x33000000),
                      animationDuration: Duration(milliseconds: 500));
                  progressDialog.show();
                  postVoterDetailsToFirestore();
                  }
                  if(choice=='ORGANIZER')
                  {
                    ArsProgressDialog progressDialog = ArsProgressDialog(
                        context,
                        blur: 2,
                        backgroundColor: Color(0x33000000),
                        animationDuration: Duration(milliseconds: 500));
                    progressDialog.show();
                    postOrganizerDetailsToFirestore();
                  }



                },
              ),
            ),



          ],
        ),
      ),


    );
  }
  tapped(int step){
    setState(() => _currentStep = step);
  }

  continued(){
    _currentStep < 2 ?
    setState(() => _currentStep += 1): null;

  }
  cancel(){
    _currentStep > 0 ?
    setState(() => _currentStep -= 1) : null;
  }
  best()
  {
    return Expanded(
      child: Stepper(
        type: stepperType,
        physics: ScrollPhysics(),
        currentStep: _currentStep,
        onStepTapped: (step) => tapped(step),
        onStepContinue:  continued,
        onStepCancel: cancel,
        steps: <Step>[
          Step(
            title: new Text('Account'),
            content: Column(
              children: <Widget>[
                TextFormField(
                  enabled: false,
                  controller: TextEditingController(text: '$name'),
                  decoration: InputDecoration(
                    labelText: 'Full Name',


                  ),
                ),
                TextFormField(
                  enabled: false,
                  controller: TextEditingController(text: '$email'),
                  decoration: InputDecoration(
                    labelText: 'Email',

                  ),
                ),
                TextFormField(
                  controller: CnicController,
                  inputFormatters: [
                    CNICmaskFormatter
                  ],
                  validator: (value) {
                    RegExp regExp = new RegExp(r'^.{13,}$');
                    if(value.isEmpty)
                    {
                      return ("CNIC Required");
                    }
                    if(!regExp.hasMatch(value)){
                      return ("Enter Valid CNIC No (Min. 13 Characters)");}
                    return null;
                  },
                  onSaved: (value){CnicController.text=CNICmaskFormatter.getMaskedText();},
                  decoration: InputDecoration(
                    labelText: 'CNIC No',
                    hintText: 'e.g. 37204-2345674-1',

                  ),
                ),

              ],
            ),
            isActive: _currentStep >= 0,
            state: _currentStep >= 0 ?
            StepState.complete : StepState.disabled,
          ),
          Step(
            title: new Text('Address'),
            content: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Permanent Address'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Postal Address'),
                ),
              ],
            ),
            isActive: _currentStep >= 0,
            state: _currentStep >= 1 ?
            StepState.complete : StepState.disabled,
          ),
          Step(
            title: new Text('Mobile Number'),
            content: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Mobile Number'),
                ),
              ],
            ),
            isActive:_currentStep >= 0,
            state: _currentStep >= 2 ?
            StepState.complete : StepState.disabled,
          ),
        ],
      ),
    );
  }

  voter() {
    return Expanded(
      child: Stepper(
        type: stepperType,
        physics: ScrollPhysics(),
        currentStep: _currentStep,
        onStepTapped: (step) => tapped(step),
        onStepContinue:  continued,
        onStepCancel: cancel,
        steps: <Step>[
          Step(
            title: new Text('Account'),
            content: Column(
              children: <Widget>[
                TextFormField(
                  enabled: false,
                  controller: TextEditingController(text: '$name'),
                  decoration: InputDecoration(
                    labelText: 'Full Name',


                  ),
                ),
                TextFormField(
                  enabled: false,
                  controller: TextEditingController(text: '$email'),
                  decoration: InputDecoration(
                    labelText: 'Email',

                  ),
                ),
                TextFormField(
                  controller: RegisterationNoController,
                  inputFormatters: [
                    maskFormatter
                  ],
                  validator: (value) {
                    RegExp regExp = new RegExp(r'^.{11,}$');
                    if(value.isEmpty)
                    {
                      return ("RegNo Required");
                    }
                    if(!regExp.hasMatch(value)){
                      return ("Enter Valid Mobile No (Min. 11 Characters)");}
                    return null;
                  },
                  onSaved: (value){RegisterationNoController.text=maskFormatter.getMaskedText();},
                  decoration: InputDecoration(
                    labelText: 'Registration Number',
                    hintText: 'e.g. fa18-bse-021',

                  ),
                ),
              ],
            ),
            isActive: _currentStep >= 0,
            state: _currentStep >= 0 ?
            StepState.complete : StepState.disabled,
          ),
          Step(
            title: new Text('Address'),
            content: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Permanent Address'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Postal Address'),
                ),
              ],
            ),
            isActive: _currentStep >= 0,
            state: _currentStep >= 1 ?
            StepState.complete : StepState.disabled,
          ),
          Step(
            title: new Text('Mobile Number'),
            content: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Mobile Number'),
                ),
              ],
            ),
            isActive:_currentStep >= 0,
            state: _currentStep >= 2 ?
            StepState.complete : StepState.disabled,
          ),
        ],
      ),
    );
  }
  void showErrorDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Important'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
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
  postVoterDetailsToFirestore() async {


    final FirebaseUser user = await _auth.currentUser();
    try {showErrorDialog(context, 'Successfully Profile Completed');

    final uid = user.uid;
    final username = name;
    final useremail = email;
    final userphoneNo = phoneNo;
    print(uid);

    Firestore firebaseFirestore = Firestore.instance;

    completeVoterProfile userModel = completeVoterProfile();

    // writing all the values
    userModel.uid=uid;
    userModel.name=username;
    userModel.email=useremail;
    userModel.phoneNo=userphoneNo;
    userModel.Status = choice;
    userModel.regNo = RegisterationNoController.text;
    userModel.depart=_selectedType;
    userModel.permanentAddress = permanentAddressController.text;
    userModel.postalAddress = PresentAddressController.text;
    if(rec.length!=0)
    {
      userModel.nodeID=rec[0];
      Firestore.instance
          .collection('Blockchain')
          .document(rec[0])
          .updateData({
        "isAssigned":true
      });
    }
    else{
      userModel.nodeID='';
    }


    await firebaseFirestore.collection("Users").document(user.uid)
        .setData(userModel.toMap());




    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => SignInPage()),
            (route) => false);
    } catch (e) {
      Fluttertoast.showToast(msg:'Profile Completed');

      print(e.message);
    }

  }

  postOrganizerDetailsToFirestore() async {


    final FirebaseUser user = await _auth.currentUser();
    try {

      final uid = user.uid;

      final username = name;
      final useremail = email;
      final userphoneNo = phoneNo;
      print(uid);

      Firestore firebaseFirestore = Firestore.instance;

      completeOrganizerProfile userModel = completeOrganizerProfile();

      // writing all the values
      userModel.uid=uid;
      userModel.name=username;
      userModel.email=useremail;
      userModel.phoneNo=userphoneNo;
      userModel.Status = "not-verified";
      userModel.CNIC = CnicController.text;
      userModel.organization=organizationController.text;
      userModel.permanentAddress = permanentAddressController.text;
      userModel.postalAddress = PresentAddressController.text;
      if(rec.length!=0)
      {
        userModel.nodeID=rec[0];
        Firestore.instance
            .collection('Blockchain')
            .document(rec[0])
            .updateData({
          "isAssigned":true
        });
      }
      else{
        userModel.nodeID='';
      }


      await firebaseFirestore.collection("Users").document(user.uid)
          .setData(userModel.toMap());

      showErrorDialog(context, 'Successfully Profile Completed, Please Login Again for updates...');


      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => SignInPage()),
              (route) => false);
    } catch (e) {
      Fluttertoast.showToast(msg:'Profile Completed');

      print(e.message);
    }

  }
}
/*
class NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      print(text.length);
      if (nonZeroIndex <= 5) {
        print("non");
        print(nonZeroIndex);
        if (nonZeroIndex % 5 == 0 && nonZeroIndex != text.length) {
          buffer.write('-'); // Add double spaces.
        }
      } else {
        if (nonZeroIndex % 12 == 0 && nonZeroIndex != text.length) {
          buffer.write('-'); // Add double spaces.
        }
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}*/
