import 'dart:typed_data';

import 'package:e_voting_admin_panel/widgets/text_input_fields.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';


class AdminSettings extends StatefulWidget {
  const AdminSettings({Key key}) : super(key: key);

  @override
  _AdminSettingsState createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController secret = TextEditingController();
  Uint8List imagevalue;

  selectImage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'svg', 'jpeg']);

    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        imagevalue = file.bytes;
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    email.dispose();
    password.dispose();
    secret.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ExpansionTile(
            title: Text('ExpansionTile 1'),
            subtitle: Text('Trailing expansion arrow icon'),
            children: [
              TextFieldInput(
                  textEditingController: username,
                  hintText: "Enter Username",
                  textInputType: TextInputType.text),
              TextFieldInput(
                  textEditingController: email,
                  hintText: "Enter Email",
                  textInputType: TextInputType.emailAddress),
              TextFieldInput(
                  textEditingController: password,
                  hintText: "Enter Username",
                  textInputType: TextInputType.visiblePassword),
              TextFieldInput(
                  textEditingController: secret,
                  hintText: "Enter Secret Key",
                  textInputType: TextInputType.text),
              (imagevalue == null)
                  ? CircleAvatar(
                      radius: 40,
                    )
                  : CircleAvatar(
                      radius: 40,
                      backgroundImage: MemoryImage(imagevalue),
                    ),
              IconButton(onPressed: selectImage, icon: Icon(Icons.upload_file))
            ],
          ),
        ],
      ),
    );
  }
}
