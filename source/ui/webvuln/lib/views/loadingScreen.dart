import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:webvuln/views/resultScreen.dart';
import 'package:webvuln/views/scan_screen.dart';

class loadingScreen extends StatefulWidget {
  const loadingScreen({super.key});

  @override
  State<loadingScreen> createState() => _loadingScreenState();
}

class _loadingScreenState extends State<loadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text("PreloadPageView Demo"),
        // ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.amber,
        ));
  }
}