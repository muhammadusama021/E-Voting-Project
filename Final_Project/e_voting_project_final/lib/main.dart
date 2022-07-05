import 'package:e_voting_project_final/Pages/about.dart';
import 'package:e_voting_project_final/Pages/resources.dart';
import 'package:e_voting_project_final/services/contract_linking.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:get/get.dart';
import 'Pages/splashScreen.dart';
import 'loadingAuth.dart';
import 'splashScreen/introScreen.dart';

void main() async {
  // init flutter hive
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ContractLinking>(
        create: (_) => ContractLinking(),
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Navigation Drawer Demo',
          theme: _createTheme(),
          home: AnimatedSplashScreen(
            backgroundColor: kmainColor,
            splashIconSize: double.infinity,
            splash: SplashScreen(),
            nextScreen: LoadingAuth(),
            duration: 2500,
          ),
          routes: {
            'about': (context) => AboutPage(),
          },
        ));
  }
}

ThemeData _createTheme() {
  return ThemeData(
    primaryColor: Color(0xff03c8a8),
    accentColor: Color(0xff03c8a8),
    canvasColor: Color(0xffffffff),
    fontFamily: 'Hind',
  );
}
