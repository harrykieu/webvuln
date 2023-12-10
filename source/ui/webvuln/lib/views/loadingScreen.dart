// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webvuln/service/api.dart';
import 'package:webvuln/views/resultScreen.dart';

class loadingScreen extends StatefulWidget {
  const loadingScreen({Key? key}) : super(key: key);

  @override
  _loadingScreenState createState() => _loadingScreenState();
}

class _loadingScreenState extends State<loadingScreen> {
  late Future<String> serverResponse;

  @override
  void initState() {
    super.initState();
    serverResponse = listen();
  }

  Future<String> fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    return "Success";
  }

  String modifydata(data) {
    String rawData = data;
    String extractJson(String rawData) {
      // index to start read data
      int startIndex = rawData.indexOf('{', rawData.indexOf('"result"'));
      // index to end process read data
      int endIndex = rawData.indexOf('}');
      String jsonData = rawData.substring(startIndex, endIndex + 1);
      return jsonData;
    }

    ;
    String jsonData = extractJson(rawData);
    return jsonData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: serverResponse,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.connectionState == ConnectionState.done) {
              String snapData = snapshot.data!;
              // FIXME: ERROR!
              return resultScreen(data: modifydata(snapData));
            } else {
              return const Text('Error');
            }
          },
        ),
      ),
    );
  }
}
