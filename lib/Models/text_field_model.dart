import 'package:flutter/material.dart';

class MyFormTextField extends StatelessWidget {
  final Function(String?)? onSaved;
  final InputDecoration decoration;
  final String? Function(String?)? validator;
  final bool isObscure;
  const MyFormTextField(
      this.isObscure, this.decoration, this.validator, this.onSaved,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscure,
      decoration: decoration,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
