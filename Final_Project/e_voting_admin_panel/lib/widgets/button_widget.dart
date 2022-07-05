import 'package:flutter/material.dart';
import 'package:e_voting_admin_panel/utils/colors.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final Color fgColor;
  final Color bgColor;
  final String text;

  const ButtonWidget(
      {Key key,
      this.onTap,
      this.bgColor = greenColor,
      this.fgColor = primaryColor,
      this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        child: Text(
          '$text',
          style: TextStyle(color: primaryColor, fontSize: 18),
        ),
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: ShapeDecoration(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
            ),
            color: bgColor),
      ),
    );
  }
}
