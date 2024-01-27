// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class inputUser extends StatelessWidget {
  const inputUser({
    super.key,
    required this.controller,
    required this.hintName,
    required this.underIcon,
    // required this.validator,
  });

  final TextEditingController controller;
  final String hintName;
  final Widget underIcon;
  // final Function() validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: hintName,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.black, width: 1.0),
        ),
        suffixIcon: underIcon,
      ),
      controller: controller,
    );
  }
}
