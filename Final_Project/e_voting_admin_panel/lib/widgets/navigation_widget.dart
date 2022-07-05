import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';

class NavigationWidget extends StatefulWidget {
  final String headline;
  final String username;

  const NavigationWidget(
      {Key key,
      this.headline,
      this.username,
     })
      : super(key: key);

  @override
  _NavigationWidgetState createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  @override
  Widget build(BuildContext context) {
    String dropdownvalue = widget.username;

    var items = [dropdownvalue];
    String headline = widget.headline;
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [purplish, blueColor],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 15, left: 20, right: 10, bottom: 15),
        child: Row(
          children: [
            Text(
              "Welcome $headline",
              style: GoogleFonts.robotoCondensed(
                  color: primaryColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.4),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
            ),

            SizedBox(
              width: 10,
            ),
            DropdownButton(
              style: GoogleFonts.titilliumWeb(
                  fontSize: 20, color: primaryColor),
              dropdownColor: blueColor,
              // Initial Value
              value: dropdownvalue,
              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),

              // Array list of items
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String newValue) {
                setState(() {
                  dropdownvalue = newValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
