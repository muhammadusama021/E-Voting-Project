import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Candidate extends StatefulWidget {
  const Candidate({Key key}) : super(key: key);

  @override
  _CandidateState createState() => _CandidateState();
}

class _CandidateState extends State<Candidate> {
  final fullNameController=new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String selectedSalutation;

  @override
  Widget build(BuildContext context) {
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
    return Form(
      key: _formKey,
      child: Column(
        children: [


        ],
      ),

    );
  }
}


