import 'package:e_voting_project_final/splashScreen/introScreen.dart';
import 'package:e_voting_project_final/ui/signin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoadingAuth extends StatefulWidget {
  const LoadingAuth({Key key}) : super(key: key);

  @override
  _LoadingAuthState createState() => _LoadingAuthState();
}

class _LoadingAuthState extends State<LoadingAuth> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    if (_seen) {
      //here check if user is login already or not
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SignInPage()));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => IntroSliderPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkFirstSeen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container();
          }
        });
  }
}