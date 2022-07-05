import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalAppMethods {
  Future<Map<String, String>> getPsyData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String psy = (prefs.getString("psyData") ?? "{}");
    Map<String, String> psyData = Map.castFrom(json.decode(psy));
    print(psyData);
    return psyData;
  }

  savePsyData(Map<String, String> psy) async {
    String psyData = json.encode(psy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("psyData", psyData);
  }
}
