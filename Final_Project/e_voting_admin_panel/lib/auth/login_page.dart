import 'dart:ui';

import 'package:e_voting_admin_panel/admin/admin_dashboard_page.dart';
import 'package:e_voting_admin_panel/auth/signup_page.dart';
import 'package:e_voting_admin_panel/organizer/profile_page.dart';

import 'package:e_voting_admin_panel/organizer/widgets/errorMessage.dart';

import 'package:e_voting_admin_panel/resources/auth_methods.dart';
import 'package:e_voting_admin_panel/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';



import '../widgets/text_input_fields.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _secretKeyController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode secretFocus = FocusNode();

  String title = "ADMIN";
  bool isAdmin = true;
  bool _roleError = false;
  bool _emailError = false;
  bool _passwordError = false;
  bool _secretKeyError = false;
  bool _isLoading = false;
  String _result = "";
  String authUser = "Select Role";
  List<String> items = ["Select Role", "Admin"];

  loginAdmin() async {
    if (_emailController.text.isNotEmpty) {
      if (_passwordController.text.isNotEmpty) {
        if (authUser == "Admin") {
          setState(() {
            _isLoading = true;
          });
          String res = await AuthMethods().loginAdmin(
              email: _emailController.text,
              password: _passwordController.text,
              );
          if (res == "success") {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const AdminDashBoardPage()),
                    (route) => false);
            setState(() {
              _isLoading = false;
            });
          } else {
            setState(() {
              _result = res;
              _isLoading = false;
            });
          }
        } else {
          if (authUser == "Select Role") {
            setState(() {
              _roleError = true;
            });
          }
        }
      } else {
        setState(() {
          _passwordError = true;
        });
      }
    } else {
      setState(() {
        _emailError = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailFocus.addListener(() {
      if (_emailError) {
        setState(() {
          _emailError = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purplish,
      body: Stack(
        children: [
          //main container
          Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  height: MediaQuery.of(context).size.height * 0.80,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.3),
                        spreadRadius: 10,
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.30,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  "https://images.unsplash.com/photo-1516397281156-ca07cf9746fc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80")),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 50,
                              ),
                              CircleAvatar(
                                radius: 68,
                                backgroundImage:
                                ExactAssetImage("assets/vote2.png"),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Welcome to E-Voting Admin Panel",
                                style: GoogleFonts.titilliumWeb(
                                    color: primaryColor,
                                    fontSize: 48,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.30,
                        margin: EdgeInsets.only(left: 25),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                "$title LOGIN",
                                style: GoogleFonts.robotoCondensed(
                                    color: greyBlack,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.4),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: TextFieldInput(
                                focus: emailFocus,
                                hintText: "Enter Email",
                                isError: _emailError,
                                isPass: false,
                                textInputType: TextInputType.emailAddress,
                                textEditingController: _emailController,
                              ),
                            ),
                            _emailError
                                ? const ErrorMessage(
                                message: "Please Enter Email First")
                                : Container(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: TextFieldInput(

                                hintText: "Enter Password",
                                isPass: true,
                                textInputType: TextInputType.text,
                                textEditingController: _passwordController,
                              ),
                            ),
                            _passwordError
                                ? const ErrorMessage(
                                message: "Please Enter Password First")
                                : Container(),

                            Container(
                              padding: EdgeInsets.only(top: 10, right: 15),
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Forgot Password?",
                                style: GoogleFonts.titilliumWeb(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              width: MediaQuery.of(context).size.width,
                              child: DropdownButton(
                                value: authUser,
                                items: items.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                isExpanded: true,
                                underline: _roleError
                                    ? Container(
                                  height: 2,
                                  color: Colors.red,
                                )
                                    : null,

                                style: GoogleFonts.titilliumWeb(
                                  fontSize: 18,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    authUser = newValue;
                                    if (authUser == "Psychiatrist") {
                                      isAdmin = false;
                                      title = "PSYCHIATRIST";
                                    } else {
                                      title = "ADMIN";
                                      isAdmin = true;
                                    }
                                    _roleError = false;
                                  });
                                },
                              ),
                            ),
                            _roleError
                                ? Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Text(
                                "Please select a role first",
                                style: GoogleFonts.titilliumWeb(
                                    fontSize: 13, color: Colors.red),
                              ),
                            )
                                : Container(),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                loginAdmin();
                              },
                              child: Container(
                                child: _isLoading
                                    ? const Center(
                                  child: SizedBox(
                                    width: 29,
                                    height: 29,
                                    child: CircularProgressIndicator(

                                    ),
                                  ),
                                )
                                    : Text(
                                  'Login'.toUpperCase(),
                                  style: GoogleFonts.titilliumWeb(
                                      color: primaryColor,
                                      fontSize: 19,
                                      letterSpacing: 1.3),
                                ),
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                decoration: const ShapeDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [purplish, blueColor]),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            _result != ""
                                ? Container(
                              constraints: BoxConstraints(
                                  minWidth:
                                  MediaQuery.of(context).size.width),
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 7),
                              decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  border: Border.all(
                                      color: Colors.red, width: 1.5),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                              child: Text(
                                _result,
                                style: GoogleFonts.titilliumWeb(
                                    fontSize: 13, color: primaryColor),
                              ),
                            )
                                : Container(),
                            SizedBox(
                              height: 10,
                            ),
                            !isAdmin
                                ? InkWell(
                              child: Text("Sign up as a psychiatrist?"),
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => SignupPage(),
                                  ),
                                );
                              },
                            )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}