// ignore_for_file: file_names

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webvuln/service/api.dart';
import 'package:webvuln/views/resultScreen.dart';

class loadingScreen extends StatefulWidget {
  const loadingScreen({super.key});

  @override
  _loadingScreenState createState() => _loadingScreenState();
}

class _loadingScreenState extends State<loadingScreen> {
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

  String modifydata(data) {
    String rawData = data;
    String extractJson(String rawData) {
      // index to start read data
      int startIndex = rawData.indexOf('{', rawData.indexOf('"result"'));
      // index to end process read data
      int endIndex = rawData.lastIndexOf('}');
      String jsonData = rawData.substring(startIndex, endIndex + 1);
      // FIXME: jsonDecode did not accept '[]' as a valid json format
      return jsonData;
    }

    String jsonData = extractJson(rawData);
    return jsonData;
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
              String snapData = snapshot.data!;
              return resultScreen(data: modifydata(snapData));
            }
          },
        ),
      ),
    );
  }
}
