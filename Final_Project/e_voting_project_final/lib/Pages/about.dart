import 'package:e_voting_project_final/Pages/resources.dart';
import 'package:e_voting_project_final/Pages/transactionview.dart';
import 'package:e_voting_project_final/widgets/small_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_letter/rectangle_shape.dart';
class AboutPage extends StatefulWidget {
  const AboutPage({Key key}) : super(key: key);
  static const String routeName = '/about';

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Fluttertoast.showToast(msg: "You can't go back kinldy press Close button.",backgroundColor: kmainColor,textColor: Colors.white);
          ; // Action to perform on back pressed
          return false;
        },
    child: Scaffold(

      body: Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)

        ),

        elevation: 10,
        child: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10)
          ),
          height: 510,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: kmainColor,
                    borderRadius: BorderRadius.circular(10)
                ),

                child: Center(
                  child: Small_Text(text: "About Us",color: Colors.white,size: 24,),
                ),

                height: 100,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Padding(padding: EdgeInsets.all(10),
                        child: Small_Text(text:"E-voting system using blockchain work as a step towards creating secure and transparent environment"
                            " for election where the voter will be able to cast their vote only once. In this system voter will "
                            "register by provided his/her personal information. Data has been stored on distributed blockchain "
                            "ledger in encrypted form through peer to peer network. The system will generate a hash key "
                            "for each individual voter that hash key will be unique for each voter.",size: 13,),
                      ),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.email,color: kmainColor,),
                              SizedBox(width: 10,),
                              Text("e_voting@cuiatk.edu.pk"),
                            ],
                          )
                        ],
                      ),)
                    ],
                  )




                ],
              ),
              ElevatedButton(

                onPressed: (){
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => TransactionView()),
                          (route) => false
                  );
                }, child: Text("Close"),
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty
                      .all(kmainColor),
                ),
              )
            ],
          ),
        ),
      ),
    ),);

  }
}
