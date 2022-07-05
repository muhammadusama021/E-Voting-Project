
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_voting_project_final/utils/dimensions.dart';
import 'package:e_voting_project_final/widgets/big_text.dart';
import 'package:e_voting_project_final/widgets/small_text.dart';

class IconWithText extends StatelessWidget {
  final IconData icon;
  final iconSize;
  final String text;
  final round;
  final Color iconColor;
  final  link;
  const IconWithText({Key key,
    this.icon,
    this.iconSize=0,
    this.text,
    this.round,
    this.link,
    this.iconColor }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10,horizontal: Dimensions.width15),
      child: Card(
        elevation: 5,
        shape: round,
        child: new InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => link));

          },
          child: Container(
            child: Center(
              child: Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width20, vertical: Dimensions.height20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          icon,color: iconColor,
                          size: iconSize==0?Dimensions.Icon50:iconSize,
                        ),
                        SizedBox(height: Dimensions.height10), // icon
                        Small_Text(text: text,size: Dimensions.font13)// text
                      ],
                    ),
                  ],
                ),
              ),
            ),
            width: Dimensions.mainGridContainerWidth,
            height: Dimensions.mainGridContainerHeight,
          ),
        ),
      ),
    );
  }
}
