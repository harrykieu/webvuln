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
      height:50,
      child: FloatingActionButton(
        backgroundColor: Color(0xFF4C4FAB),
      onPressed: onPressed,
      child: childButton,
    ),
    );
  }
}