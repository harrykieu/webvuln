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

  String ?validateName(String ?value){
    if ( value == null || value.isEmpty){
      return 'This field must be filled!!';
    }
    final regexURL = RegExp(r'(https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z0-9]{2,}(\.[a-zA-Z0-9]{2,})(\.[a-zA-Z0-9]{2,})?');
    if ( !regexURL.hasMatch(value)){
      return "Invalid URL";
    }
  }
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator:validateName ,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: hintName,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
        ),
        suffixIcon: underIcon,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
        ),
      ),
      controller: controller,
    );
  }
}
