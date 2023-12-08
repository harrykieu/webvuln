// ignore_for_file: file_names

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
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

  Future<String> listen() async {
    Completer<String> completer = Completer<String>();

    await ServerSocket.bind("0.0.0.0", 5001).then((ServerSocket server) {
      print('Server listening on ${server.address}:${server.port}');
      server.listen((Socket server) {
        server.listen((data) async {
          String response = String.fromCharCodes(data);
          server.close();

          if (!completer.isCompleted) {
            completer.complete(response);
          }
        });
      }, onError: (error) {
        print(error);
        if (!completer.isCompleted) {
          completer.completeError('Error');
        }
      }, onDone: () {
        print('done');
      });
    });

    return completer.future;
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
              return resultScreen(data: snapData);
            } else {
              return const Text('Error');
            }
          },
        ),
      ),
    );
  }
}
