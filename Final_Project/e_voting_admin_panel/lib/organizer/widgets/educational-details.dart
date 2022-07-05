import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../resources/local_app_methods.dart';
import '../../utils/colors.dart';

class EducationalDetails extends StatefulWidget {
  const EducationalDetails({
    Key key,
  }) : super(key: key);

  @override
  State<EducationalDetails> createState() => _EducationalDetailsState();
}

class _EducationalDetailsState extends State<EducationalDetails> {
  final TextEditingController _degree = TextEditingController();
  final TextEditingController _dataPassOut = TextEditingController();
  final TextEditingController _experience = TextEditingController();
  final TextEditingController _university = TextEditingController();

  FocusNode degreeFocus = FocusNode();
  FocusNode dataPassOutFocus = FocusNode();
  FocusNode experienceFocus = FocusNode();
  FocusNode universityFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    degreeFocus.addListener(() {
      if (!degreeFocus.hasFocus) {
        setPsyDataValues("degree", _degree.text);
      }
    });
    dataPassOutFocus.addListener(() {
      if (!dataPassOutFocus.hasFocus) {
        setPsyDataValues("datePassOut", _dataPassOut.text);
      }
    });
    experienceFocus.addListener(() {
      if (!experienceFocus.hasFocus) {
        setPsyDataValues("experience", _experience.text);
      }
    });
    universityFocus.addListener(() {
      if (!universityFocus.hasFocus) {
        setPsyDataValues("university", _university.text);
      }
    });
  }

  void setPsyDataValues(String key, String value) async {
    print(key + " " + value);
    Map<String, String> psyData = await LocalAppMethods().getPsyData();
    psyData[key] = value;
    LocalAppMethods().savePsyData(psyData);
    print("done");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 54, vertical: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextField(
                  focusNode: degreeFocus,
                  style: GoogleFonts.titilliumWeb(fontWeight: FontWeight.w400),
                  cursorColor: greyBlack,
                  controller: _degree,
                  decoration: InputDecoration(
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: darkpurplish)),
                      border: OutlineInputBorder(),
                      labelText: "Last Degree",
                      labelStyle:
                          GoogleFonts.titilliumWeb(fontWeight: FontWeight.w400),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 3)),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  focusNode: dataPassOutFocus,
                  style: GoogleFonts.titilliumWeb(fontWeight: FontWeight.w400),
                  cursorColor: greyBlack,
                  controller: _dataPassOut,
                  decoration: InputDecoration(
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: darkpurplish)),
                    border: OutlineInputBorder(),
                    labelText: "Pass out Date",
                    labelStyle:
                        GoogleFonts.titilliumWeb(fontWeight: FontWeight.w400),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextField(
                  focusNode: experienceFocus,
                  style: GoogleFonts.titilliumWeb(fontWeight: FontWeight.w400),
                  cursorColor: greyBlack,
                  controller: _experience,
                  decoration: InputDecoration(
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: darkpurplish)),
                      border: OutlineInputBorder(),
                      labelText: "Experience",
                      labelStyle:
                          GoogleFonts.titilliumWeb(fontWeight: FontWeight.w400),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 3)),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  focusNode: universityFocus,
                  style: GoogleFonts.titilliumWeb(fontWeight: FontWeight.w400),
                  cursorColor: greyBlack,
                  controller: _university,
                  decoration: InputDecoration(
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: darkpurplish)),
                      border: OutlineInputBorder(),
                      labelText: "University",
                      labelStyle:
                          GoogleFonts.titilliumWeb(fontWeight: FontWeight.w400),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 3)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
