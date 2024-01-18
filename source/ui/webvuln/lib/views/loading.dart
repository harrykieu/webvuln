// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webvuln/service/api.dart';
import 'package:webvuln/views/result.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late Future<String?> serverResponse;
  late WebVulnSocket socket;

  @override
  void initState() {
    super.initState();
    socket = WebVulnSocket(url: '0.0.0.0', port: 5001);
    serverResponse = _initializeSocket();
  }

  Future<String?> _initializeSocket() async {
    _closeExistingSocket();
    try {
      if (await socket.create()) {
        final data = await socket.listen();
        return data;
      } else {
        // Handle the case where server initialization fails
        print('Error: Server not initialized');
        return null;
      }
    } catch (error) {
      // Handle errors during socket communication
      print('Error during socket communication: $error');
      return null;
    }
  }

  void _closeExistingSocket() {
    if (socket.server != null) {
      socket.close();
    }
  }

  String extractJson(String response) {
    int startIndex = response.indexOf('[', response.indexOf('"result"'));
    int endIndex = response.lastIndexOf(']');
    String resultData = response.substring(startIndex, endIndex + 1);
    return resultData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<String?>(
          future: serverResponse,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError || snapshot.data == null) {
              return Text('Error: ${snapshot.error ?? "Unknown error"}');
            } else {
              String? snapData = snapshot.data;
              return ResultScreen(data: extractJson(snapData!));
            }
          },
        ),
      ),
    );
  }
}
