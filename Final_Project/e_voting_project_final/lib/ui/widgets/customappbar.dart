import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Material(
      child: Container(
        height: height/10,
        width: width,
        padding: EdgeInsets.only(left: 15, top: 25),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                spreadRadius: 0.0,
                color: Colors.black26,
                offset: Offset(1.0, 10.0),
                blurRadius: 20.0),
          ],
          gradient: LinearGradient(
              colors: [Color(0xff03c8a8),Color(0xff89d8d3)]
          ),
        ),
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.keyboard_arrow_left,color: Colors.black),
                onPressed: (){
                  Navigator.of(context).pop();
            }),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
}
