import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final FocusNode focus;
  final bool isPass;
  final bool isError;
  final String hintText;
  final TextInputType textInputType;
  const TextFieldInput(
      {Key key,
        this.textEditingController,
        this.focus,
        this.isPass = false,
        this.isError = false,
        this.hintText,
        this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color error = Colors.grey.shade300;
    if (isError) {
      error = Colors.redAccent;
    }
    final inputBorder = OutlineInputBorder(
        borderSide: Divider.createBorderSide(context, color: error));
    return TextField(
      focusNode: focus,
      style: GoogleFonts.titilliumWeb(),
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}