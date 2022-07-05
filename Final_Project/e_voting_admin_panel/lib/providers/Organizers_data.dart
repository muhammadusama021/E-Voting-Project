import 'package:flutter/material.dart';

class PsychiatristData extends ChangeNotifier {
  Map<String, dynamic> psyData;

  void updatePsyData(String key, dynamic value) {
    psyData[key] = value;
    notifyListeners();
  }

  Map<String, dynamic> getPsyData() {
    return psyData;
  }
}
