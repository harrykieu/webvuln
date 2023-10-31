import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webvuln/views/drawer.dart';
import 'package:get/get.dart';
import 'scanScreen.dart';
import 'package:webvuln/service/api.dart';

class historyScreen extends StatefulWidget {
  const historyScreen({super.key});

  @override
  State<historyScreen> createState() => _historyScreenState();
}

class _historyScreenState extends State<historyScreen> {
  @override
  final TextEditingController _historyURLController = TextEditingController();
  final TextEditingController _dateScanController = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:null ,
      body: Column(
        children: [
          Text(
            "Search history scan",
            style: GoogleFonts.montserrat(
                fontSize: 20, fontWeight: FontWeight.bold),
          ),
          inputUser(controller: _historyURLController, hintName: 'URL'),
          inputUser(controller: _dateScanController, hintName: 'Date & Time'),
          submitButton(
              onPressed: () {
                postHistory(
                  nameURL: _historyURLController.text,
                  datetime: _dateScanController.text,
                );
              },
              title: 'GET URL and Date')
        ],
      ),
    );
  }
}
