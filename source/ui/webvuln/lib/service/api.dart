// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:process_run/process_run.dart';
import '../model/model.dart';

Dio dio = Dio();
String baseUrl = 'http://127.0.0.1:5000';
Options _options = Options(
    headers: {'Content-Type': 'application/json', 'Origin': 'frontend'});

var shell = Shell();
Future<void> runShell({required String commandLine}) async {
  var resultRun = await shell.run(commandLine);
  print(resultRun);
}

class WebVulnSocket {
  final String url;
  final int port;
  ServerSocket? server;

  WebVulnSocket({required this.url, required this.port});

  Future<bool> create() async {
    try {
      server = await ServerSocket.bind(url, port, shared: true);
      return true;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<String> listen() async {
    // Ensure the server is initialized before listening
    if (server == null) {
      print('Error: Server not initialized');
      return '';
    }

    try {
      Socket client = await server!.first; // Wait for the first connection

      print(
          'Connection from ${client.remoteAddress.address}:${client.remotePort}');

      // Read data until the connection is closed
      StringBuffer receivedDataBuffer = StringBuffer();
      await for (List<int> data in client) {
        receivedDataBuffer.write(String.fromCharCodes(data));

        // Check if the received data indicates the end of communication
        if (receivedDataBuffer.toString().endsWith('}')) {
          break;
        }
      }

      // Process the received data or store it in response
      String response = receivedDataBuffer.toString();

      // Send a JSON response back to the client
      client.write("HTTP/1.1 200 OK\n\n");

      // Close the client socket after sending the response
      await client.close();

      return response;
    } catch (error) {
      print('Error during socket communication: $error');
      return '';
    }
  }

  Future<void> close() async {
    await server?.close();
  }
}

//POST api/scan
Future<String> postURL(
    {required List<String> nameURL, required List<String> moduleNumber}) async {
  final data = jsonEncode(URL(url: nameURL, modules: moduleNumber).toJson());
  final url = '$baseUrl/api/scan';
  try {
    final response = await dio.post(url, data: data, options: _options);
    switch (response.statusCode) {
      case 200:
        return "post data success";
      case 400:
        return "Not found data";
      case 500:
        return "Connection crasshed";
      default:
        return 'None';
    }
  } catch (e) {
    print(ContentType.json);
    print(nameURL);
    print(data);
    print(e);
    return "Error";
  }
}

//GET api/history
Future<String> getHistory(
    {required String nameURL, required String datetime}) async {
  final data = jsonEncode(History(domain: nameURL, scanDate: datetime));
  final url = '$baseUrl/api/history';
  try {
    final response = await dio.get(url, data: data, options: _options);

    if (response.statusCode == 200) {
      print('Get data successfully');
      return response.toString();
    } else {
      return 'Failed to get data';
    }
  } catch (e) {
    return 'Error: $e';
  }
}

//POST api/resources
Future<String> postResources(
    {required String vulnType,
    required String action,
    required String resType,
    required dynamic value}) async {
  final data = jsonEncode(ResourceNormal(
      vulnType: vulnType, action: action, resType: resType, value: value));
  final url = '$baseUrl/api/resourcesnormal';

  try {
    final response = await dio.post(url, data: data, options: _options);
    if (response.statusCode == 200) {
      return ('Posted resources successfully');
    } else {
      return ('Failed to Post Resources');
      // print('Status code:');
    }
  } catch (e) {
    return ('Error post resources: $e');
  }
}

Future<String> postResourcesFile({
  required String fileName,
  required String description,
  required dynamic base64value,
  required String? action,
}) async {
  final data = jsonEncode(ResourceFile(
      fileName: fileName,
      description: description,
      base64value: base64value,
      action: action));
  final url = '$baseUrl/api/resourcesfile';
  try {
    final response = await dio.post(url, data: data, options: _options);
    if (response.statusCode == 200 && response.data == 'Success') {
      return ('Posted file successfully');
    } else {
      return ('Failed to Post Resources');
      // print('Status code:');
    }
  } catch (e) {
    return ('Error post resources: $e');
  }
}

Future<String> getResourcesNormal(
    {required String vulnType, required String resType}) async {
  final data = jsonEncode(ResourceNormal(vulnType: vulnType, resType: resType));
  final url = '$baseUrl/api/resourcesnormal';
  try {
    final response = await dio.get(url, data: data, options: _options);
    if (response.statusCode == 200 && response.data != {}) {
      print('Get resources successfully');
      return response.toString();
    } else {
      print('Failed to get resources');
      return 'Failed to get resources';
    }
  } catch (e) {
    print('Error get resources: $e');
    return 'Error get resources';
  }
}

Future<String> getResourcesFile({required String description}) async {
  final data = jsonEncode(ResourceFile(description: description));
  final url = '$baseUrl/api/resourcesfile';
  try {
    final response = await dio.get(url, data: data, options: _options);
    if (response.statusCode == 200 && response.data != {}) {
      print('Get resources successfully');
      return response.toString();
    } else {
      print('Failed to get resources');
      return 'Failed to get resources';
    }
  } catch (e) {
    print('Error get resources: $e');
    return 'Error get resources';
  }
}

Future<String> createReport(
    {required List<dynamic> result, required String type}) async {
  final data = jsonEncode(Report(result: result, type: type));
  final url = '$baseUrl/api/report';
  try {
    final response = await dio.post(url, data: data, options: _options);
    if (response.statusCode == 200 && response.data != {}) {
      print('Create report successfully');
      return response.toString();
    } else {
      print('Failed to create report');
      return 'Failed to create report';
    }
  } catch (e) {
    print('Error create report: $e');
    return 'Error create report';
  }
}
