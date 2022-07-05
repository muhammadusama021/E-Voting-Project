import 'package:ars_progress_dialog/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_voting_project_final/services/contract_linking.dart';
import 'package:e_voting_project_final/widgets/big_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:e_voting_project_final/Pages/resources.dart';
import 'package:rounded_letter/rounded_letter.dart';


class CandidatePage extends StatefulWidget {

  static const String routeName = '/candidates';




  @override
  _ExpansionTileCardDemoState createState() => _ExpansionTileCardDemoState();
}

class _ExpansionTileCardDemoState extends State<CandidatePage> with SingleTickerProviderStateMixin{

  TabController _controller;
  int _selectedIndex = 0;

  List<Widget> list = [
    Tab(child: Text('Candidates',style: TextStyle(color: Colors.white,fontSize: 16))),
    //Tab(child: Text('Panels',style: TextStyle(color: Colors.white,fontSize: 16))),
  ];

  @override
  void initState() {

    _fetch();
    _fetch_panel();
    // TODO: implement initState
    _refreshData();

    super.initState();

    // Create TabController for getting the index of current tab
    _controller = TabController(length: list.length, vsync: this);

    _controller.addListener(() {

      setState(() {
        _selectedIndex = _controller.index;

      });

    });
  }
  bool _expanded = false;

  Color colorGreen=Color(0xff03c8a8);
  Color colorGrey=Colors.grey;
  double textSize=16;

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  );
  final roundShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10)),
  );


  //final image = [Image.asset('assets/images/mypic.jpg'),Image.asset('assets/images/APPICON56.png'),
  //Image.asset('assets/images/mypic.jpg'), Image.asset('assets/images/APPICON1.png')];

  final database = Firestore.instance;
  String name;
  String candidate_name;
  String candidate_email;
  String candidate_phoneNo;
  String candidate_RegNo;
  String candidate_depart;
  var Type_identifier = new Map();
  var C_identifier = new Map();
  var candidates_list = [];
  var candidates_data = [];
  var Candidate_identifier = new Map();

  String P_name;
  String P_candidate_name;
  var Panel_identifier = new Map();
  var panel_list = [];
  var panel_data = [];
  var P_candidate_identifier = new Map();
  var myList = {"CR of Class":["Usama","Nadeem","Saad"]};

  Future<void> _fetch() async {

    QuerySnapshot _myDoc =
        await Firestore.instance.collection('ElectionData').getDocuments();
    List<DocumentSnapshot> _myDocCount = _myDoc.documents;
    for (var item in _myDocCount) {
      await database
          .collection("ElectionData")
          .document(item.documentID)
          .get()
          .then((value) {
        name = value.data['name'];
        Type_identifier[item.documentID] = name;
      }).catchError((e) {
        print(e);
      });

      QuerySnapshot _mycandidateDoc = await Firestore.instance
          .collection('ElectionData')
          .document(item.documentID)
          .collection('Candidates')
          .getDocuments();
      List<DocumentSnapshot> _candidateCount = _mycandidateDoc.documents;
      for (var item2 in _candidateCount) {
        await database
            .collection("ElectionData")
            .document(item.documentID)
            .collection('Candidates')
            .document(item2.documentID)
            .get()
            .then((value) {
          candidate_name = value.data['name'];
          candidates_data.add(candidate_name);
          candidate_email = value.data['email'];
          candidates_data.add(candidate_email);
          candidate_phoneNo = value.data['phoneNo'];
          candidates_data.add(candidate_phoneNo);
          candidate_RegNo = value.data['regNo'];
          candidates_data.add(candidate_RegNo);
          candidate_depart = value.data['depart'];
          candidates_data.add(candidate_depart);
          candidate_name = candidate_name.replaceFirst(
              candidate_name[0], candidate_name[0].toUpperCase());
          candidates_list.add(candidate_name);

          C_identifier[item2.documentID] = candidates_data;
          candidates_data = [];
        }).catchError((e) {
          print(e);
        });
      }
      Candidate_identifier[name] = candidates_list;

      candidates_list = [];

    }
    //print(Candidate_identifier);




  }
  Future<void> _fetch_panel() async {
    QuerySnapshot _myDoc =
    await Firestore.instance.collection('PanelData').getDocuments();
    List<DocumentSnapshot> _myPanelCount = _myDoc.documents;
    for (var item in _myPanelCount) {
      await database
          .collection("PanelData")
          .document(item.documentID)
          .get()
          .then((value) {
        P_name = value.data['name'];
        Panel_identifier[item.documentID] = P_name;
      }).catchError((e) {
        print(e);
      });

      QuerySnapshot _myPanel_candidateDoc = await Firestore.instance
          .collection('PanelData')
          .document(item.documentID)
          .collection('Candidates')
          .getDocuments();
      List<DocumentSnapshot> _candidate_Count = _myPanel_candidateDoc.documents;
      for (var item2 in _candidate_Count) {
        await database
            .collection("PanelData")
            .document(item.documentID)
            .collection('Candidates')
            .document(item2.documentID)
            .get()
            .then((value) {
          P_candidate_name = value.data['name'];
          panel_data.add(candidate_name);

          P_candidate_name = P_candidate_name.replaceFirst(
              P_candidate_name[0], P_candidate_name[0].toUpperCase());
          panel_list.add(P_candidate_name);

          Panel_identifier[item2.documentID] = panel_data;
          panel_data = [];
        }).catchError((e) {
          print(e);
        });
      }
      P_candidate_identifier[P_name] = panel_list;

      panel_list = [];

    }
    // print(P_candidate_identifier);

  }


  @override



  Widget _card(context,list) {
    return Container(
        width: MediaQuery.of(context).size.width - 50,
        margin: EdgeInsets.only(left: 50),
        child: InkWell(
          onTap: (){
            _openPopup(context, list, "", "");
            },
          child: Card(
            elevation: 10,
            child: ListTile(
              title: Text(
                list,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Candidate"),
              leading: CircleAvatar(
                  child: RoundedLetter.withRedCircle(list[0], 40, 20)),
            ),
          ),
        ));
  }

  /*Widget _ListView() {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return ExpansionTileCard(
            elevation: 5.0,
            title: Text(
              Panel[index],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Candidates"),
            leading: CircleAvatar(
                child: RoundedLetter.withRedCircle(Panel[index][0], 40, 20)),
            children: <Widget>[
              Divider(
                thickness: 1.0,
                height: 1.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: _New(),
                ),
              ),
            ],
          );
        });
  }

  Widget _expensionPanel() {
    return Column(children: [
      Container(
        margin: EdgeInsets.all(5),
        color: Colors.green,
        child: ExpansionPanelList(
          animationDuration: Duration(milliseconds: 200),
          children: [
            ExpansionPanel(
              headerBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    "",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Candidates',
                      style: TextStyle(color: Colors.black45)),
                  leading: CircleAvatar(
                      child: RoundedLetter.withRedCircle("Pre", 40, 20)),
                );
              },
              isExpanded: _expanded,
              body: _New(),
              canTapOnHeader: true,
            ),
          ],
          dividerColor: Colors.grey,
          expansionCallback: (panelIndex, isExpanded) {
            _expanded = !_expanded;
            setState(() {});
          },
        ),
      ),
    ]);
  }

  Widget _New() {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          itemCount: titles.length,
          itemBuilder: (context, index) {
            return Card(
                color: Colors.grey[200],
                elevation: 5,
                child: ListTile(
                  title: Text(
                    titles[index],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(subtitles[index]),
                  leading: CircleAvatar(
                      child: RoundedLetter.withRedCircle(
                          titles[index][0], 40, 20)),
                ));
          }),
    );
  }*/

  _openPopup(context,text,type,id) {

    Alert(
        style: AlertStyle(),
        context: context,
        title: "INFORMATION",
        onWillPopActive: true,
        closeIcon: Icon(Icons.close,color: Color(0xff03c8a8)),
        content: Column(
          children: <Widget>[
            /*Material(
              color: Color(0xff03c8a8),
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Container(

                alignment: Alignment.centerLeft,
                child:Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      "Information".toUpperCase(),
                      style: TextStyle(
                          letterSpacing: 1.2,
                          color: Colors.white,
                          fontSize: textSize,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),*/
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              child: Column(

                children: [
                  Row(
                    children: [
                      Text("Name ",
                        style: TextStyle(color: colorGreen,fontSize: textSize),
                      ),
                      Expanded(
                        child: Text("$text",
                          textAlign: TextAlign.end,
                          style: TextStyle(color: colorGrey,fontSize: textSize),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Email ",
                        style: TextStyle(color: colorGreen,fontSize: textSize),
                      ),
                      Expanded(
                        child: Text("$text",
                          textAlign: TextAlign.end,
                          style: TextStyle(color: colorGrey,fontSize: textSize),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Phone No",
                        style: TextStyle(color:colorGreen,fontSize: textSize),
                      ),
                      Expanded(
                        child: Text("$text",
                          textAlign: TextAlign.end,
                          style: TextStyle(color: colorGrey,fontSize: textSize),
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Reg No ",
                        style: TextStyle(color: colorGreen,fontSize: textSize),
                      ),
                      Expanded(
                        child: Text("$text",
                          textAlign: TextAlign.end,
                          style: TextStyle(color: colorGrey,fontSize: textSize),
                        ),
                      ),

                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            color: Color(0xff03c8a8),
            onPressed: () {
              /*postPanelDetailsToFirestore(electionTypeController.text);
                Fluttertoast.showToast(msg: "Successfully Save");*/
              Navigator.of(context).pop();
            },


            child: Text(
              "CANCEL",
              style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
            ),
          )


        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    var contractLink = Provider.of<ContractLinking>(context);


    return
      Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),

          title: Text('Candidate/Panel',style: TextStyle(color: Colors.white),),
          backgroundColor: kmainColor,
          bottom:TabBar(
                indicatorWeight: 8,

                indicatorColor: Colors.white,
                /*indicator: BoxDecoration(

                    borderRadius: BorderRadius.circular(15), // Creates border
                    color: colorGrey.withOpacity(0.8)),
*/
                controller: _controller,
                tabs: list,
              ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    contractLink.initialSetup();

                  },
                  child: Icon(
                    Icons.refresh,
                  ),
                )),
          ],
        ),
        body:
        TabBarView(
          controller: _controller,
          children: [


            RefreshIndicator(
              child: Center(
                child: contractLink.isLoading
                    ? CircularProgressIndicator()
                    : Container(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                      children: [
                        if(contractLink.candidatesData.entries!=null)...{
                          for (var p in contractLink.candidatesData.entries) ...{
                            Card(
                              elevation: 5,
                              child: ExpansionTileCard(
                                  title: Text(
                                    "Voting for " + p.key.toString(),
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text("Candidates"),
                                  leading: CircleAvatar(
                                      child: RoundedLetter.withRedCircle(
                                          p.key[0].toString(), 40, 20)),
                                  children: [
                                    for (var item in p.value) ...{
                                      _card(context,item),
                                    }
                                  ]



                              ),
                            ),
                            Divider(thickness: 2,color: Colors.black87,)
                          }
                        }
                        else...{
                          Center(child: Text("Curently! No Election Opened"),)
                        }

                      ],
                    ),
                  ),

              ),
              onRefresh: _refreshData,
            ),
            /*RefreshIndicator(
              child: Center(
                child: myCandidate(context,'Panels'),
              ),
              onRefresh: _refreshData,
            ),*/
          ],
        ),


        );
  }
  @override
  // TODO: implement widget

  Future _refreshData() async {

    await Future.delayed(Duration(seconds: 5));


  }
}
