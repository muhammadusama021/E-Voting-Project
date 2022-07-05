import 'package:e_voting_project_final/services/contract_linking.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class electionData extends StatefulWidget {
  const electionData({Key key}) : super(key: key);

  @override
  _electionDataState createState() => _electionDataState();
}

class _electionDataState extends State<electionData> {
  @override
  Widget build(BuildContext context) {
    var contractLink = Provider.of<ContractLinking>(context);

    //print(cryptoData);
    return ListView(
        padding: const EdgeInsets.all(8),
    children: <Widget>[
    ListTile( title: Text("Battery Full"),subtitle: Text("The battery is full."),leading: Icon(Icons.battery_full),trailing: Icon(Icons.star)),
    ListTile( title: Text("Anchor"),subtitle: Text("Lower the anchor."), leading: Icon(Icons.anchor), trailing: Icon(Icons.star)),
    ListTile( title: Text("Alarm"),subtitle: Text("This is the time."), leading: Icon(Icons.access_alarm), trailing: Icon(Icons.star)),
    ListTile( title: Text("Ballot"),subtitle: Text("Cast your vote."), leading: Icon(Icons.ballot), trailing: Icon(Icons.star))
    ]);
  }
}
