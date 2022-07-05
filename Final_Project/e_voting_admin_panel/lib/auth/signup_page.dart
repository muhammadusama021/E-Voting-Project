import 'dart:typed_data';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';


import '../resources/auth_methods.dart';
import '../utils/colors.dart';

import '../widgets/text_input_fields.dart';

import 'package:google_fonts/google_fonts.dart';

import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  Uint8List _image;

  selectImage() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'jpeg']);

    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        _image = file.bytes;
      });
    } else {
      // User canceled the picker
    }
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void signupPsy() async {
    setState(() {
      _isLoading = true;
    });
    if (_image != null) {
      String res = await AuthMethods().signupAdmin(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          username: _usernameController.text.trim(),
          file: _image);

      setState(() {
        _isLoading = false;
      });

      if (res == "success") {
        // showSnackBar(
        //     "account created successfully check email for verification code",
        //     context);
        Future.delayed(const Duration(milliseconds: 1000), () {
          navigateToLogin;
        });
      } else {
        // showSnackBar(res, context);
      }
    } else {
      // showSnackBar("Please Select Image first", context);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
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
                              "https://images.unsplash.com/photo-1653641563248-9120bbe39f18?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80")),
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
                                ExactAssetImage("assets/stressed.png"),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "Glad to have you on Board",
                              style: GoogleFonts.titilliumWeb(
                                  color: primaryColor,
                                  fontSize: 48,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.30,
                    margin: EdgeInsets.only(left: 35),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 52,
                                backgroundColor: primaryColor,
                                child: CircleAvatar(
                                  radius: 44,
                                  child: _image != null
                                      ? CircleAvatar(
                                          radius: 64,
                                          backgroundImage: MemoryImage(_image),
                                        )
                                      : CircleAvatar(
                                          radius: 64,
                                          child: Image.asset(
                                            'user-circle.svg',
                                            color: primaryColor,
                                            height: 85,
                                          ),
                                          backgroundColor: blueColor,
                                        ),
                                  backgroundColor: blueColor,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: ClipOval(
                                  child: Container(
                                    color: primaryColor,
                                    padding: EdgeInsets.all(5),
                                    child: ClipOval(
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        color: blueColor,
                                        child: IconButton(
                                          onPressed: selectImage,
                                          icon: const Icon(
                                            Icons.add_a_photo,
                                            color: primaryColor,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          TextFieldInput(
                            hintText: "Enter Username",
                            textInputType: TextInputType.text,
                            textEditingController: _usernameController,
                          ),
                          const SizedBox(height: 24),
                          TextFieldInput(
                            hintText: "Enter Email",
                            textInputType: TextInputType.emailAddress,
                            textEditingController: _emailController,
                          ),
                          const SizedBox(height: 24),
                          TextFieldInput(
                            hintText: "Enter Password",
                            isPass: true,
                            textInputType: TextInputType.text,
                            textEditingController: _passwordController,
                          ),
                          const SizedBox(height: 24),
                          InkWell(
                            onTap: () {
                              signupPsy();
                            },
                            child: Container(
                              child: _isLoading
                                  ? const Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          backgroundColor: primaryColor,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          color: primaryColor, fontSize: 18),
                                    ),
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 14),
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
                          Flexible(
                            child: Container(),
                            flex: 2,
                          ),
                          GestureDetector(
                            onTap: () {
                              navigateToLogin();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text("Already have an account?"),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                ),
                                Container(
                                  child: const Text(
                                    " Log in.",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
