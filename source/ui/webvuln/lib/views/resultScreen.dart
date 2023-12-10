// ignore_for_file: unused_element

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:webvuln/items/custom_dropdown.dart';
import 'package:webvuln/items/lineChart.dart';
import 'package:webvuln/items/newSubmitButton.dart';
import 'package:webvuln/items/pieGraph.dart';
import 'package:webvuln/items/tables.dart';
import 'package:webvuln/views/variable.dart';
import 'package:webvuln/model/model.dart';

// TODO: parse data from loading screen to display on result screen
class resultScreen extends StatefulWidget {
  final String data;
  const resultScreen({super.key, required this.data});

  @override
  State<resultScreen> createState() => _resultScreenState();
  String get resultData => data;
}

class _resultScreenState extends State<resultScreen> {
  bool isVisibled = true;
  bool isAppeared = true;
  int number_module = 0;
  List<HistoryTableData> results = [];

  @override
  void initState() {
    super.initState();
    isVisibled = true;
    number_module = 0;
    isAppeared = true;
  }

  String __jsonHandle(String strJSON) {
    // Read the string line by line to find the json format
    for (String line in strJSON.split('\n')) {
      if (line.startsWith('{')) {
        // Handle the json data
        return line;
      }
    }
    return '';
  }

  List<HistoryTableData> __parseData(Map<String, dynamic> json) {
    results.add(HistoryTableData.fromJson(json));
    return results;
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double borderRadiusValue = 20.0; // Adjust the radius as needed
    Get.testMode = true;
    // parse json string to list of HistoryTableData object
    String newData = __jsonHandle(widget.data);
    Map<String, dynamic> json = jsonDecode(newData);
    String severity_point = json["resultPoint"];
    results = __parseData(json['result'][0]);
    List<String> error = ['All', 'XSS', 'SQLi', 'RCE', 'LFI'];
    List<Widget> tables = [
      TableAll(dataTable: newData),
      TableXSS(),
      TableSQli(),
      TableRCE(),
      TableLFI()
    ];
    //select module to scan
    String selectedModule = "All";
    bool isHide(newData) {
      if (newData['numVuln'] == 0) {
        return false;
      } else {
        return true;
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: GradientButton(
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.download))],
        toolbarHeight: 80,
        leadingWidth: 100,
        backgroundColor: Colors.transparent,
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadiusValue),
        child: Visibility(
          visible: isAppeared,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Visibility(
                  visible: isHide(newData),
                  child: CustomDropdownButton(
                      selectedItem: selectedModule,
                      items: error,
                      onItemSelected: (item) {
                        print(item);
                        print(newData);
                        setState(() {
                          isVisibled = item == 'All';
                          print(isVisibled);
                        });
                        switch (item) {
                          case 'All':
                            setState(() {
                              number_module = 0;
                            });
                            break;
                          case 'XSS':
                            setState(() {
                              number_module = 1;
                            });
                            break;
                          case 'SQLi':
                            setState(() {
                              number_module = 2;
                            });
                            break;
                          case 'RCE':
                            setState(() {
                              number_module = 3;
                            });
                            break;
                          case 'LFI':
                            setState(() {
                              number_module = 4;
                            });
                            break;
                          default:
                        }
                      }),
                ),
                /* Table list errors*/
                container(screenWidth,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Image(
                              image: AssetImage('lib/assets/list.png')),
                          title: Text('List Vulnerabilities',
                              style: GoogleFonts.montserrat(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          trailing: Text('Point Severity:$severity_point',
                              style: GoogleFonts.montserrat(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                        ),
                        tables[number_module]
                      ],
                    )),
                // Graph line and pie chart
                Visibility(
                  visible: isVisibled,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [containerPieChart(), lineChart()],
                  ),
                ),
                // Description
                container(
                  screenWidth,
                  child: Column(
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            const Image(
                                image:
                                    AssetImage('lib/assets/Folders_light.png')),
                            Text(
                              '  Description',
                              style: GoogleFonts.montserrat(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            tool_tip(content: 'Info about description')
                          ],
                        ),
                      ),
                      Constants.content_vulnerabilities[number_module]
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container container(double screenWidth, {required Widget child}) {
    return Container(
        width: screenWidth,
        height: 550,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        padding: EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(0, 4),
              blurRadius: 10,
              spreadRadius: 1,
            )
          ],
        ),
        child: child);
  }

  JustTheTooltip tool_tip({required String content}) {
    return JustTheTooltip(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          content,
        ),
      ),
      child: const Icon(
        Icons.info_outline_rounded,
        color: Colors.black,
        size: 16,
      ),
    );
  }
}
