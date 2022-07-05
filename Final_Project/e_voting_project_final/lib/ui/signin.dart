import 'package:ars_progress_dialog/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_voting_project_final/Pages/resources.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:e_voting_project_final/Pages/SetupProfile.dart';

import 'package:e_voting_project_final/Pages/transactionview.dart';
import 'package:e_voting_project_final/ui/signup.dart';

import 'package:flutter/material.dart';

import 'package:e_voting_project_final/ui/widgets/custom_shape.dart';
import 'package:e_voting_project_final/ui/widgets/responsive_ui.dart';




class SignInPage extends StatefulWidget {
  @override
  const SignInPage({Key key}) : super(key: key);
  _SignInScreenState createState() => _SignInScreenState();

}

class _SignInScreenState extends State<SignInPage> {
  bool rememberMe = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  final _auth = FirebaseAuth.instance;
  String errorMessage;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController _resetEmailController = TextEditingController();
  SharedPreferences prefs;
  Future<void> initState() {
    // TODO: implement initState

    super.initState();

    createOpenBox();


  }
  @override


  void createOpenBox()async{
    prefs=await SharedPreferences.getInstance();

    getdata();

    //getdata();  // when user re-visit app, we will get data saved in local database
    //how to get data from hive db check it in below steps
  }
  void _onRememberMeChanged(bool newValue,String email,String pass) => setState(() {
    rememberMe = newValue;

    if (rememberMe) {
      // TODO: Here goes your functionality that remembers the user.
      prefs.setString('email', email.toString().trim());
      prefs.setString('pass', pass.toString().trim());
    }

  });
  void getdata() async{


    if(prefs.getString('email')!=null){
      emailController.text = prefs.getString('email');
      rememberMe = true;
      setState(() {
      });
    }
    if(prefs.getString('pass')!=null){
      passwordController.text = prefs.getString('pass');
      rememberMe = true;
      setState(() {
      });
    }
  }


  bool _passwordVisible = false;

  final _formKey = GlobalKey<FormState>();
  final _resetKey = GlobalKey<FormState>();
  String _resetEmail;
  bool _resetValidate = false;
  String status='';
  final database =Firestore.instance;
  _fetch(ID) async
  {
    final FirebaseUser firebaseUser = await _auth.currentUser();
    if(firebaseUser != null)
    {
      await database.collection("Users").document(ID).get().then((value)
      {
        setState(() {
          status=value.data['Status'];
          print(status);
          myfuction();
        });



      }).catchError((e)
      {
        print(e);
      });
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    final emailField =TextFormField(

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

    final passwordField =TextFormField(
        autofocus: false,
        controller: passwordController,
        keyboardType: TextInputType.name,
        obscureText: !_passwordVisible,
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
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock,color: Color(0xff03c8a8), size: 20),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: 'Enter Password',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30)
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
    final signInButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),

      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        onPressed: () {
          SnackBar(content: Text('Data is in processing.'));


          signIn(emailController.text, passwordController.text);
            // If the form is valid, display a Snackbar.

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
            'SIGN IN',
            style: TextStyle(fontSize: _large ? 14 : (_medium ? 14 : 13)),
          ),
        ),
      ),

    );
    final forgetPassTextRow = Container(
      margin: EdgeInsets.only(top: _height / 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Forgot your password?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 12 : 13)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              _displayTextInputDialog(context);
            },
            child: Text(
              "Reset",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Color(0xff03c8a8)),
            ),
          )
        ],
      ),
    );


    return Material(
      child:Scaffold(
        body: Container(
          height: _height,
          width: _width,
          padding: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                clipShape(),
                welcomeTextRow(),
                signInTextRow(),
                Container(
                  margin: EdgeInsets.only(
                      left: _width / 20.0, right: _width / 20.0, top: _height / 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [

                        emailField,
                        SizedBox(height: 20),

                        passwordField,
                        SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            //new ClipRRect(
                            // borderRadius: BorderRadius.all(Radius.circular(90.0)),
                            //  child:
                            new Checkbox(
                              checkColor: Colors.white,
                              fillColor: MaterialStateProperty.all(Color(0xff03c8a8)),
                              value: rememberMe,
                              onChanged: (bool value) {
                                setState(() {
                                  rememberMe = value;
                                });
                              },
                            ),                          // ),
                            new Expanded(
                                child: new Text('Remember me',
                                  style: new TextStyle(
                                      color: Color(0xff797979)
                                  ),
                                )
                            ),

                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            forgetPassTextRow,
                          ],
                        ),

                        SizedBox(height: 20),
                        signInButton,
                      ],
                    ),
                  ),
                ),
                SizedBox(height: _height / 40),
                signUpTextRow(),
                _label()
              ],
            ),
          ),
        ),
      ),

    );
  }

  Widget clipShape() {
    //double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 4
                  : (_medium ? _height / 3.75 : _height / 3.5),
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
                  ? _height / 4.5
                  : (_medium ? _height / 4.25 : _height / 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff03c8a8), Color(0xff89d8d3)],
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(
              top: _large
                  ? _height / 30
                  : (_medium ? _height / 25 : _height / 20)),
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage("assets/images/pic2.png"),
                    fit: BoxFit.fill),
              ),
            )
        ),
      ],
    );
  }

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 20, top: _height / 100),
      child: Row(
        children: <Widget>[
          Text(
            "Welcome",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff03c8a8),
              fontSize: _large ? 60 : (_medium ? 50 : 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 15.0),
      child: Row(
        children: <Widget>[
          Text(
            "Sign in to your account",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontSize: _large ? 20 : (_medium ? 17.5 : 15),
            ),
          ),
        ],
      ),
    );
  }







  /*Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: _large ? _width / 4 : (_medium ? _width / 2.75 : _width / 2.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: [Color(0xff03c8a8), Color(0xff89d8d3)],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('SIGN IN',
            style: TextStyle(fontSize: _large ? 14 : (_medium ? 14 : 13))),
      ),
    );
  }*/

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Don't have an account?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 12 : 13)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUp()));
            },
            child: Text(
              "Sign up",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xff03c8a8),
                  fontSize: _large ? 19 : (_medium ? 17 : 15)),
            ),
          )
        ],
      ),
    );
  }

  Widget _label() {
    return Container(
        margin: EdgeInsets.only(top: 20, bottom: 30),
        child: Column(
          children: <Widget>[
            Text(
              'Or Quick login with Fingerprint',
              style: TextStyle(color: Color(0xff03c8a8), fontSize: 17,fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 10,
            ),
            IconButton(
                icon: Icon(Icons.fingerprint_rounded,size: 60, color: Colors.black),
              onPressed: () async {

                  bool val = await getPref();
                  if(val == true){
                    bool isAthuhenticate= await loginUsingFingerprint();
                    print(isAthuhenticate);
                if(isAthuhenticate)
                  {
                    signIn(emailController.text, passwordController.text);

                  }

              }else{
                    Fluttertoast.showToast(msg: "Your login first and check remmeber me. then Login using Fingerprint",backgroundColor: Colors.red,textColor: Colors.white);

                  }
                  },),
            SizedBox(
              height: 10,
            ),
          ],
        ));
  }

  // login function
  void signIn(String email, String password) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        dismissable: false,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));
    if (_formKey.currentState.validate()) {


      try {
        progressDialog.show();
        _onRememberMeChanged(rememberMe,email,password);


        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
              verify(),
              progressDialog.dismiss(),


        }

        );
      } catch (error) {
        progressDialog.dismiss();

        switch (error.code) {
          case "ERROR_INVALID_EMAIL":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "ERROR_WRONG_PASSWORD":
            errorMessage = "Your password is wrong.";
            break;
          case "ERROR_USER_NOT_FOUND":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "ERROR_USER_DISABLED":
            errorMessage = "User with this email has been disabled.";
            break;
          case "ERROR_TOO_MANY_REQUESTS":
            errorMessage = "Too many requests. Try again later.";
            break;
          case "ERROR_OPERATION_NOT_ALLOWED":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "Please Check your internet Connection.";
        }

       /* Fluttertoast.showToast(msg: errorMessage);*/
        showErrorDialog(context, errorMessage);




      }
    }
  }

  verify() async {


    final FirebaseUser user = await _auth.currentUser();

    if (user.isEmailVerified)
      {
        _fetch(user.uid);
      }
    else
      {
        showErrorDialog(context, 'Your email is not Verified, Kindly verify your Email Address.');
        return null;
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

  Future<void> _displayTextInputDialog(BuildContext context) async {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Reset Your Account Password!'),
          content: new SingleChildScrollView(
            child: Form(
              key: _resetKey,
              autovalidate: _resetValidate,
              child: ListBody(
                children: <Widget>[
                  new Text(
                    'Enter the Email Address associated with your account.',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  Row(
                    children: <Widget>[

                      new Expanded(
                        child: TextFormField(
                          controller: _resetEmailController,
                          validator: validateEmail,
                          onSaved: (String val) {
                            _resetEmailController.text = val;
                          },

                          keyboardType: TextInputType.emailAddress,
                          autofocus: true,
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

                            ),
                          style: TextStyle(color: Colors.black),

                        ),
                      )
                    ],
                  ),
                  new Column(children: <Widget>[
                    Container(
                      decoration: new BoxDecoration(
                          ),
                    )
                  ]),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
              child: Text('CANCEL',
                style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
            ),
            // ignore: deprecated_member_use
            FlatButton(

              child: Text('SEND EMAIL',
                style: TextStyle(color: Color(0xff03c8a8)),
              ),
              onPressed: () {
                ArsProgressDialog progressDialog2 = ArsProgressDialog(
                    context,
                    dismissable: false,
                    blur: 2,
                    backgroundColor: Color(0x33000000),
                    animationDuration: Duration(milliseconds: 500));


                if (_resetEmailController.text != '') {
                  progressDialog2.show();
                  _sendResetEmail();
                  Navigator.of(context).pop();
                }




              },
            ),
          ],
        );
      },
    );
  }

 resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }

    }

  Future<bool> _sendResetEmail() async {
    ArsProgressDialog progressDialog2 = ArsProgressDialog(
        context,
        dismissable: false,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    _resetEmail = _resetEmailController.text;

    if (_resetKey.currentState.validate()) {
      _resetKey.currentState.save();

      try {
        // You could consider using async/await here
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _resetEmail);

        showErrorDialog(context, 'Reset Password link sent to your email address, Please check your Email Address.');
        progressDialog2.dismiss();

        return true;
      } catch (exception) {

        showErrorDialog(context, 'The user with this email does not exist, Kindly recheck your email!');
        progressDialog2.dismiss();

      }
    } else {
      setState(() {
        progressDialog2.dismiss();
        _resetValidate = true;
      });
      return false;
    }
  }
  myfuction()
  {
    if(status == 'VOTER')
    {
      Fluttertoast.showToast(msg: "Login Successful",backgroundColor: kmainColor,textColor: Colors.white);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => TransactionView()),
              (route) => false
      );
    }
    if(status == 'ORGANIZER')
    {
      Fluttertoast.showToast(msg: "Login Successful",backgroundColor: kmainColor,textColor: Colors.white);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => TransactionView()),
            (route) => false
    );
    }
    if(status == null)
    {
      Fluttertoast.showToast(msg: "Login; But Kindly Complete Your Profile Please",backgroundColor: kmainColor,textColor: Colors.white);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => StepperDemo()),
              (route) => false
      );
    }
    if(status=='not-verified')
      {
        Fluttertoast.showToast(msg: "Login Successful",backgroundColor: kmainColor,textColor: Colors.white);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => TransactionView()),
                (route) => false
        );
      }
  }
  final LocalAuthentication auth = LocalAuthentication();
  // get user logged in using fingerprint
  Future<bool> loginUsingFingerprint() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
        localizedReason: 'Scan your fingerprint to authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
    return authenticated;
  }

  Future<bool> getPref() async{

    if(prefs.getString('email')!=null && prefs.getString('pass')!=null){
      return true;
    }
    else{
      return false;
    }
  }

}
