import 'package:e_voting_project_final/Pages/resources.dart';
import 'package:flutter/material.dart';
class Snackbar extends StatefulWidget {
  String content;
  Color color;
  Snackbar({Key key, this.content,this.color}) : super(key: key);

  @override
  _SnackBarState createState() => _SnackBarState();
}

class _SnackBarState extends State<Snackbar> {
  @override
  Widget build(BuildContext context) {
    return SnackBar(content: Text(widget.content,style: TextStyle(color: Colors.white),),
      backgroundColor: widget.color,
    );
  }
}
