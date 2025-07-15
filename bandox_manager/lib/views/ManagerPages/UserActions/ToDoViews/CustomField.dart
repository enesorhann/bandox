import 'package:flutter/material.dart';

Widget TextFld(TextEditingController addingController,String hintText) {


  return TextField(
    focusNode: FocusNode(),
    autofocus: true,
    controller: addingController,
    maxLength: 30,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      hintText: hintText,
    ),
  );
}