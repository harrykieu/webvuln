import 'package:flutter/material.dart';

class submitButton extends StatelessWidget {
  submitButton(
      {super.key,
      // required TextEditingController moduleController,
      required this.onPressed,
      required this.childButton});

  final Function() onPressed;
  Widget childButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      width:100,
      height:100,
      child: FloatingActionButton(
      onPressed: onPressed,
      child: childButton,
    ),
    );
  }
}