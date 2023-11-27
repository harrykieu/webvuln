import 'package:flutter/material.dart';
// import 'package:webvuln/items/categoryButton.dart';

class detail_screen extends StatefulWidget {
  const detail_screen({super.key});

  @override
  State<detail_screen> createState() => _detail_screenState();
}

class _detail_screenState extends State<detail_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back)),
    ));
  }
}
