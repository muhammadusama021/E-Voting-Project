import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:e_voting_admin_panel/providers/Organizers_data.dart';
import 'package:e_voting_admin_panel/resources/local_app_methods.dart';
import 'package:e_voting_admin_panel/utils/colors.dart';

class ContactDetails extends StatefulWidget {
  const ContactDetails({
    Key key,
  }) : super(key: key);

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _contact = TextEditingController();
  final TextEditingController _about = TextEditingController();
  final TextEditingController _location = TextEditingController();

  FocusNode usernameFocus = FocusNode();
  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode contactFocus = FocusNode();
  FocusNode locationFocus = FocusNode();
  FocusNode aboutFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LocalAppMethods().savePsyData({});
    usernameFocus.addListener(() {
      if (!usernameFocus.hasFocus) {
        setPsyDataValues("username", _username.text);
      }
    });
    firstNameFocus.addListener(() {
      if (!firstNameFocus.hasFocus) {
        setPsyDataValues("firstName", _firstName.text);
      }
    });
    lastNameFocus.addListener(() {
      if (!lastNameFocus.hasFocus) {
        setPsyDataValues("lastName", _lastName.text);
      }
    });
    contactFocus.addListener(() {
      if (!contactFocus.hasFocus) {
        setPsyDataValues("contact", _contact.text);
      }
    });
    aboutFocus.addListener(() {
      if (!aboutFocus.hasFocus) {
        setPsyDataValues("bio", _about.text);
      }
    });
    locationFocus.addListener(() {
      if (!locationFocus.hasFocus) {
        setPsyDataValues("location", _location.text);
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
      margin: const EdgeInsets.symmetric(horizontal: 54, vertical: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextField(
                  focusNode: usernameFocus,
                  style: GoogleFonts.titilliumWeb(fontWeight: FontWeight.w400),
                  cursorColor: greyBlack,
                  controller: _username,
                  decoration: InputDecoration(
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: darkpurplish)),
                      border: OutlineInputBorder(),
                      labelText: "Username",
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
                  style: GoogleFonts.titilliumWeb(fontWeight: FontWeight.w400),
                  controller: _email,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: darkpurplish)),
                      border: OutlineInputBorder(),
                      labelText: "Email",
                      labelStyle:
                          GoogleFonts.titilliumWeb(fontWeight: FontWeight.w400),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 3)),
                  enabled: false,
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
                  focusNode: firstNameFocus,
                  style: GoogleFonts.titilliumWeb(fontWeight: FontWeight.w400),
                  cursorColor: greyBlack,
                  controller: _firstName,
                  decoration: InputDecoration(
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: darkpurplish)),
                      border: OutlineInputBorder(),
                      labelText: "First Name",
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
                  focusNode: lastNameFocus,
                  style: GoogleFonts.titilliumWeb(fontWeight: FontWeight.w400),
                  cursorColor: greyBlack,
                  controller: _lastName,
                  decoration: InputDecoration(
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: darkpurplish)),
                      border: OutlineInputBorder(),
                      labelText: "Last Name",
                      labelStyle:
                          GoogleFonts.titilliumWeb(fontWeight: FontWeight.w400),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 3)),
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
                  focusNode: contactFocus,
                  style: GoogleFonts.titilliumWeb(fontWeight: FontWeight.w400),
                  cursorColor: greyBlack,
                  controller: _contact,
                  decoration: InputDecoration(
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: darkpurplish)),
                      border: OutlineInputBorder(),
                      labelText: "Phone Number",
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
                  focusNode: locationFocus,
                  style: GoogleFonts.titilliumWeb(fontWeight: FontWeight.w400),
                  cursorColor: greyBlack,
                  controller: _location,
                  decoration: InputDecoration(
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: darkpurplish)),
                      border: OutlineInputBorder(),
                      labelText: "Location",
                      labelStyle:
                          GoogleFonts.titilliumWeb(fontWeight: FontWeight.w400),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 3)),
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
                  focusNode: aboutFocus,
                  style: GoogleFonts.titilliumWeb(fontWeight: FontWeight.w400),
                  cursorColor: greyBlack,
                  controller: _about,
                  decoration: InputDecoration(
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: darkpurplish)),
                    border: OutlineInputBorder(),
                    hintText: "Write about yourself..",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                  ),
                  maxLines: 5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
