import 'package:flutter/material.dart';

class TextFieldCustom {
  const TextFieldCustom({
    required this.hinttext,
    required this.labeltext,
  });

  final String hinttext;
  final String labeltext;

  InputDecoration textfieldDecoration() {
    return InputDecoration(
      hintText: hinttext,
      hintStyle: TextStyle(color: Colors.black),
      labelText: labeltext,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.black),
      ),
    );
  }
}
