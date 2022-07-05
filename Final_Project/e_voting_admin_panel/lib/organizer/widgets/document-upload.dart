/*
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:e_voting_admin_panel/utils/colors.dart';

import '../../resources/local_app_methods.dart';

class DocumentUpload extends StatefulWidget {
  const DocumentUpload({Key key}) : super(key: key);

  @override
  State<DocumentUpload> createState() => _DocumentUploadState();
}

class _DocumentUploadState extends State<DocumentUpload> {
 */
/* String cvText = "Upload CV";
  String degreeText = "Upload CV";

  Uint8List _cvValue;
  Uint8List _degreeValue;

  selectCv() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        _cvValue = file.bytes;
        cvText = file.name;
        String cvUrl;
        uploadCV().then((value) {
          cvUrl = value;
          setPsyDataValues("cvUrl", cvUrl);
        });
      });
    } else {
      // User canceled the picker
    }
  }

  selectDegree() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        _degreeValue = file.bytes;
        degreeText = file.name;
        String degreeUrl;
        uploadDegree().then((value) {
          degreeUrl = value;
          StorageMethods().uploadCvToStorage(
              "PsychiatristProfilePics/Degree", _degreeValue);
          setPsyDataValues("degreeUrl", degreeUrl);
        });
      });
    } else {
      // User canceled the picker
    }
  }

  Future<String> uploadCV() async {
    String url = await StorageMethods()
        .uploadCvToStorage("PsychiatristProfilePics/Cv", _cvValue);
    return url;
  }

  Future<String> uploadDegree() async {
    String url = await StorageMethods()
        .uploadCvToStorage("PsychiatristProfilePics", _degreeValue);
    return url;
  }*//*


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
          SizedBox(
            height: 40,
          ),
          Container(
            padding: EdgeInsets.all(7),
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              border: Border.all(color: greyBlack),
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(cvText),
                IconButton(
                  icon: Icon(Icons.upload_file),
                  onPressed: () {
                    selectCv();
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(7),
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              border: Border.all(color: greyBlack),
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(degreeText),
                IconButton(
                  icon: Icon(Icons.upload_file),
                  onPressed: () {
                    selectDegree();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/
