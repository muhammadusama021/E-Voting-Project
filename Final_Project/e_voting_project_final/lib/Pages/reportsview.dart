import 'package:flutter/material.dart';
import '../drawer.dart';
class ReportsView extends StatelessWidget {
  static const String routeName = '/reports';

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff03c8a8),
            title: const Text('Candidates'),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.notifications,
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () { },
                    child: Icon(
                      Icons.search,
                      size: 26.0,
                    ),
                  )),
            ],
          ),
            drawer: createDrawer(context)
        ));
  }
}