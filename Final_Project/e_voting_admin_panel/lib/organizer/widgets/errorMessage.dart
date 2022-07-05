import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  const ErrorMessage({
    Key key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 19.0),
        child: Text(
          message,
          textAlign: TextAlign.left,
          style:
          GoogleFonts.titilliumWeb(fontSize: 13, color: Colors.redAccent),
        ),
      ),
    );
  }
}