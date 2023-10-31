import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webvuln/main.dart';
import 'package:webvuln/views/drawer.dart';
import 'package:get/get.dart';

class resultScreen extends StatefulWidget {
  const resultScreen({super.key});

  @override
  State<resultScreen> createState() => _resultScreenState();
}

class _resultScreenState extends State<resultScreen> {
  @override
  Widget build(BuildContext context) {
    Get.testMode = true;
    return Scaffold(
      body: Row(
        children: [
          FloatingActionButton(onPressed: () {
            Get.to(mainScreen());
          }),
          Text('result')
        ],
      ),
    );
  }
}
