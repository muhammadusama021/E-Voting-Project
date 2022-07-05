
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_voting_project_final/utils/dimensions.dart';

class Small_Text extends StatelessWidget {
  Color color;
  final double latterSpacing;
  final String text;
  double size;
  double height;

  Small_Text({Key key,this.color = const Color(0xff000000),
    this.text,
    this.latterSpacing,
    this.size=0,
    this.height=1.2
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(

      text,
      textAlign:TextAlign.justify,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(

          letterSpacing: latterSpacing,
          fontSize: size==0?Dimensions.font14:size,
          color: color,
          fontWeight: FontWeight.w700,

        ),
      ),
    );
  }
}
