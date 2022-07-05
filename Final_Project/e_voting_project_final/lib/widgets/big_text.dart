
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_voting_project_final/utils/dimensions.dart';

class Big_Text extends StatelessWidget {
  Color color;
  final String text;
  final double letterspacing;
  double size;
  TextOverflow overflow;
  Big_Text({Key key,this.color=const Color(0xff332d2b),
    this.text,
    this.letterspacing,
    this.size=0,
    this.overflow=TextOverflow.ellipsis
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: overflow,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(
          letterSpacing: letterspacing,
          fontSize: size==0?Dimensions.font16:size,
          color: color,
          fontWeight: FontWeight.w900,

        ),
      ),

    );
  }
}
