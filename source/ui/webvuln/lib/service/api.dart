// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../model/model.dart';

Dio dio = Dio();
String baseUrl = 'http://127.0.0.1:5000';
Options _options = Options(
    headers: {'Content-Type': 'application/json', 'Origin': 'frontend'});

//POST api/scan
//Post url and number module to scan in screen scan
Future<String> postURL(
    {required String nameURL, required List<String> moduleNumber}) async {
  final data = jsonEncode(URL(url: nameURL, modules: moduleNumber).toJson());
  final url = '$baseUrl/api/scan';
  print(url);
  try {
    final response = await dio.post(url, data: data, options: _options);

    if (response.statusCode == 200) {
      print(data);
      print('Sucessfull post data');
      return "Data posted successfull";
    } else {
      return "Failed post data";
    }
  } catch (e) {
    print(ContentType.json);
    print(nameURL);
    print(data);
    print(e);
    return "Error";
  }
}

//POST api/history
Future<void> postHistory(
    {required String nameURL, required String datetime}) async {
  final data = jsonEncode(historyURL(domain: nameURL, scanDate: datetime));
  final url = '$baseUrl/api/history';
  try {
    final response = await dio.get(url, data: data, options: _options);

    if (response.statusCode == 200) {
      print('Get data successfully');
      print(response);
    } else {
      print('Failed to get data');
    }
  } catch (e) {
    print('Error: $e');
    print(ContentType.json);
    print(nameURL);
    print(data);
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
