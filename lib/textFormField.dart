import 'package:flutter/material.dart';
class textFormField extends StatelessWidget {
  String? textFieldName, textLableName;
  var control;
  var validator;
  bool? obscureText;
  textFormField(
      {super.key, this.control,
      this.validator,
      this.textFieldName,
      this.textLableName,
      this.obscureText,});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: control,
        validator: validator,
        obscureText: obscureText == true ? true : false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          hintText: textFieldName,
          labelText: textLableName,
        ),

    );
  }
}