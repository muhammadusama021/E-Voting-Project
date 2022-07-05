import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show File, Platform, exit;
Future<void> saveAndLaunchFile(List<int> bytes,String fileName) async
{
  String dir;
  if(Platform.isAndroid) {
    dir = (await getExternalStorageDirectory()).path;
  } else if(Platform.isIOS) {
    dir = (await getApplicationDocumentsDirectory()).path;
  }
  print(dir);
  final file =File('$dir/$fileName');
  await file.writeAsBytes(bytes,flush: true);

  OpenFile.open('$dir/$fileName');

}