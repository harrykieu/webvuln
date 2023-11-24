// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:webvuln/model/url.dart';

import '../model/model.dart';
import 'package:dio/dio.dart';

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
Future<void> postResources(
    {required String vulnType,
    required String action,
    required String resType,
    required String value}) async {
  final data = jsonEncode(ResourceNormal(
      vulnType: vulnType, action: action, resType: resType, value: value));
  final url = '$baseUrl/api/resources';

  try {
    final response = await dio.post(url, data: data, options: _options);
    if (response.statusCode == 200) {
      print('Posted resources successfully');
    } else {
      print('Failed to Post Resources');
      // print('Status code:');
    }
  } catch (e) {
    print('Error post resources: $e');
  }
}

Future<String> getResourcesNormal(
    {required String vulnType, required String resType}) async {
  final data = jsonEncode(ResourceNormal(vulnType: vulnType, resType: resType));
  final url = '$baseUrl/api/resourcesnormal';
  try {
    final response = await dio.get(url, data: data, options: _options);
    if (response.statusCode == 200) {
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
    if (response.statusCode == 200) {
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
