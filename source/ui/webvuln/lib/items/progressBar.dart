import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: camel_case_types
class progressBar extends StatefulWidget {
  const progressBar({super.key});

  @override
  State<progressBar> createState() => _progressBarState();
}

class _progressBarState extends State<progressBar> {
  double progress = 0;
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        progress += 0.1;
      });
      if (progress >= 1) {
        timer.cancel();
      }
    });
  }

  Widget build(BuildContext context) {
    return Container(
      width: 800,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white,width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[800]!,
            blurRadius: 10,
            offset: Offset(0, 5), // changes position of shadow
          )
        ]
      ),
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: Colors.grey[300],
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}
