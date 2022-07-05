import 'dart:collection';
import 'dart:developer';

import 'package:ars_progress_dialog/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_voting_project_final/Models/userModel.dart';
import 'package:e_voting_project_final/Pages/transactionview.dart';
import 'package:e_voting_project_final/ui/screens/login_screen/login_screen.dart';
import 'package:e_voting_project_final/ui/signin.dart';
import 'package:flutter/material.dart';

import 'package:e_voting_project_final/constants/constants.dart';
import 'package:e_voting_project_final/ui/widgets/custom_shape.dart';
import 'package:e_voting_project_final/ui/widgets/customappbar.dart';
import 'package:e_voting_project_final/ui/widgets/responsive_ui.dart';
import 'package:e_voting_project_final/ui/widgets/textformfield.dart';
import 'package:e_voting_project_final/utils/validator.dart';

import '../customDialog.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();

}

class _SignUpScreenState extends State<SignUp> {





    bool _passwordVisible = false;


  final _auth = FirebaseAuth.instance;
  //our form key
  final _formKey = GlobalKey<FormState>();

  // editing Controller

  final fullNameController=new TextEditingController();
  final RegisterationNoController=new TextEditingController();
  final emailController=new TextEditingController();
  final phoneNoController=new TextEditingController();
  final passwordController=new TextEditingController();
  final confirm_passwordController=new TextEditingController();



  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  String errorMessage='';


  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
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
            hintText: 'Full Name',
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

    final passwordField =TextFormField(
        autofocus: false,
        controller: passwordController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regExp = new RegExp(r'^.{6,}$');
          if(value.isEmpty)
          {
            return ("Password is Required");
          }
          if(!regExp.hasMatch(value)){
            return ("Enter Valid Password (Min. 6 Characters)");}
          return null;
        },
        onSaved: (value){passwordController.text=value;},
        textInputAction: TextInputAction.next,
        cursorColor: Color(0xff03c8a8),
        obscureText: !_passwordVisible,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock,color: Color(0xff03c8a8), size: 20),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Enter Password',
        border: OutlineInputBorder(

          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Color(0xff03c8a8),
            width: 2.0,
          ),


        ),
        focusedBorder: OutlineInputBorder(

          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xff03c8a8), width: 2.0),
        ),

        // Here is key idea
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _passwordVisible
                ? Icons.visibility
                : Icons.visibility_off,
            color: Color(0xff03c8a8),
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
    );
    final confirm_passwordField =TextFormField(
        autofocus: false,
        controller: confirm_passwordController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if(confirm_passwordController.text.length > 0 && passwordController.text !=value)
          {
            return ("Password does not match");
          }
          return null;

        },
        onSaved: (value){confirm_passwordController.text=value;},
        textInputAction: TextInputAction.next,
        cursorColor: Color(0xff03c8a8),
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock,color: Color(0xff03c8a8), size: 20),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: 'Enter Confirm Password',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Color(0xff03c8a8),
                width: 2.0,
              ),
            ),
          focusedBorder: OutlineInputBorder(

            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xff03c8a8), width: 2.0),
          ),

          // Here is key idea
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _passwordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Color(0xff03c8a8),
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        )
    );
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),

      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        onPressed: () {
          signUp(emailController.text, passwordController.text);
        },
        textColor: Colors.white,
        padding: EdgeInsets.all(0.0),
        child: Container(
          alignment: Alignment.center,
//        height: _height / 20,
          width: _large ? _width / 4 : (_medium ? _width / 1.75 : _width / 1.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            gradient: LinearGradient(
              colors: [Color(0xff03c8a8), Color(0xff89d8d3)],
            ),
          ),
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'SIGN UP',
            style: TextStyle(fontSize: _large ? 14 : (_medium ? 14 : 13)),
          ),
        ),
      ),

    );



    return Material(
      child: Scaffold(
        body: Container(
          height: _height,
          width: _width,


          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Opacity(opacity: 0.88, child: CustomAppBar()),
                clipShape(),
                Container(
                  margin: EdgeInsets.only(
                      left: _width / 20.0, right: _width / 20.0, top: _height / 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        fullNameField,
                        SizedBox(height: 20),
                        emailField,
                        SizedBox(height: 20),
                        phoneNoField,
                        SizedBox(height: 20),
                        passwordField,
                        SizedBox(height: 20),
                        confirm_passwordField,
                        SizedBox(height: 20),
                        signUpButton,
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: _height / 100,
                ),

                signInTextRow(),
                SizedBox(
                  height: _height / 35,
                ),
                //signInTextRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 8
                  : (_medium ? _height/7: _height / 6.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff03c8a8), Color(0xff89d8d3)],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 12
                  : (_medium ? _height / 11 : _height / 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff03c8a8), Color(0xff89d8d3)],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: _height / 5.5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  spreadRadius: 0.0,
                  color: Colors.black26,
                  offset: Offset(1.0, 10.0),
                  blurRadius: 20.0),
            ],
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("assets/images/register.png"),
                      fit: BoxFit.fill),
                ),
              )),
//        Positioned(
//          top: _height/8,
//          left: _width/1.75,
//          child: Container(
//            alignment: Alignment.center,
//            height: _height/23,
//            padding: EdgeInsets.all(5),
//            decoration: BoxDecoration(
//              shape: BoxShape.circle,
//              color:  Colors.orange[100],
//            ),
//            child: GestureDetector(
//                onTap: (){
//                  print('Adding photo');
//                },
//                child: Icon(Icons.add_a_photo, size: _large? 22: (_medium? 15: 13),)),
//          ),
//        ),
      ],
    );
  }


  /*Widget infoTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Or create using social media",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }*/

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInPage()));
            },
            child: Text(
              "Sign in",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color(0xff03c8a8),
                  fontSize: _large? 19: (_medium? 17: 15)),
            ),
          )
        ],
      ),
    );
  }

  void signUp(String email, String password) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(

        context,
        dismissable: false,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    if (_formKey.currentState.validate()) {
      try {progressDialog.show();
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {

              postDetailsToFirestore()
            })
            .catchError((e) {
          progressDialog.dismiss();
          showErrorDialog(context, e.message);

        });
      } on AuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "SignUp with this Email is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        progressDialog.dismiss();
        showErrorDialog(context, errorMessage);
      }
    }
  }
  postDetailsToFirestore() async {


      final FirebaseUser user = await _auth.currentUser();
      try {
        await user.sendEmailVerification();
        showErrorDialog(context, 'We have send an email verification link on your email, Please Verify your Email Address.');
        final uid = user.uid;

        Firestore firebaseFirestore = Firestore.instance;

        UserModel userModel = UserModel();

        // writing all the values

        userModel.uid = user.uid;
        userModel.name = fullNameController.text;
        userModel.email = user.email;
        userModel.phoneNo = phoneNoController.text;

        await firebaseFirestore.collection("Users").document(user.uid)
            .setData(userModel.toMap());



        Navigator.pushAndRemoveUntil(
            (context),
            MaterialPageRoute(builder: (context) => SignInPage()),
                (route) => false);
      } catch (e) {
        showErrorDialog(context, 'An error occured while trying to send email verification link.');

      }

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
}
