import 'package:e_voting_project_final/Pages/resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Positioned(
            top: -50,
            left: -60,
            child: Container(
              width: 330,
              height: 330,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: kmainColor.withOpacity(0.4)),
            ),
          ),
          Positioned(
            right: 80,
            top: 190,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  backgroundBlendMode: BlendMode.luminosity,
                  color: kmainColor),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2,
            left: MediaQuery.of(context).size.width / 2,
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white70.withOpacity(0.3),
                backgroundBlendMode: BlendMode.luminosity,
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 50,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white70.withOpacity(0.2),
                backgroundBlendMode: BlendMode.luminosity,
              ),
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "E-Voting App",
                  style: GoogleFonts.lobster(
                    fontSize: 48,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Secure Voting",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    letterSpacing: 3,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}