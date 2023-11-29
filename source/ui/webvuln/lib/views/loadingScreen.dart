import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:webvuln/service/api.dart';
import 'package:webvuln/views/resultScreen.dart';
import 'package:webvuln/views/scanScreen.dart';

class loadingScreen extends StatelessWidget {
  const loadingScreen({super.key});
  Future<String> fetchData() async {
    // postURL(nameURL: nameURL, moduleNumber: moduleNumber)
    await Future.delayed(const Duration(seconds: 2));
    return "Success";
  }

  /* void listen() async {
    await ServerSocket.bind("0.0.0.0", 5001).then((ServerSocket server) {
      print('Server listening on ${server.address}:${server.port}');
      server.listen((Socket server) {
        server.listen((data) {
          String serverResponse = String.fromCharCodes(data);
          setState(() {
            dataReceive = serverResponse;
            print(dataReceive);
          });
        });
      }, onError: (error) => print(error), onDone: () => print('done'));
    });
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return resultScreen();
            }
          },
        ),
      ),
    );
  }
}
