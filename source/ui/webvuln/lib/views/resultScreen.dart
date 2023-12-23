// ignore_for_file: unused_element, camel_case_types

import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webvuln/items/newSubmitButton.dart';
import 'package:webvuln/model/model.dart';
import 'package:webvuln/views/variable.dart';

// parse data function

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
  String state = 'All';
  List<HistoryTableData> jsonDecoded = [];

  @override
  void initState() {
    super.initState();
    isVisibled = true;
    isAppeared = true;
  }

  Icon warnLevel(String severity) {
    switch (severity) {
      case 'High':
        return const Icon(
          Icons.warning_amber_sharp,
          color: Colors.red,
        );
      case 'Medium':
        return const Icon(
          Icons.warning_amber_sharp,
          color: Colors.yellow,
        );
      default:
        return const Icon(
          Icons.warning_amber_sharp,
          color: Colors.blue,
        );
    }
  }

  // FIXME: updateTable function is not working
  // function to parse data to table based on the selected module
  List<DataRow> updateTable(String vulnType, List<Vulnerability> data) {
    List<Vulnerability> newData = [];
    if (vulnType != 'All') {
      for (var obj in data) {
        if (obj.type == vulnType) {
          newData.add(obj);
        }
      }
    } else {
      newData = data;
    }
    List<DataRow> dataRows = newData
        .map((e) => DataRow(cells: [
              DataCell(warnLevel(e.severity)),
              DataCell(Text(e.type)),
              DataCell(Text(e.payload.toString())),
            ]))
        .toList();
    return dataRows;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Get.testMode = true;
    List<DropdownMenuItem<String>> dropdownValue = [
      const DropdownMenuItem(value: 'All', child: Text('All'))
    ];
    List<dynamic> jsonDecoded = jsonDecode(widget.resultData);
    List<HistoryTableData> dataBeforeParse = [];
    // parse vuln into List<Vulnerability>
    List<Vulnerability> listVuln = [];
    for (var obj in jsonDecoded) {
      List<dynamic> listVulnJSON = obj["vulnerabilities"];
      for (var vuln in listVulnJSON) {
        Vulnerability newVuln = Vulnerability(
          type: vuln["type"].toString(),
          severity: vuln["severity"].toString(),
          payload: List<String>.from(vuln["payload"]),
          logs: vuln["logs"].toString(),
        );
        listVuln.add(newVuln);
      }
      // parse json into HistoryTableData
      HistoryTableData newVuln = HistoryTableData(
          domain: obj["domain"].toString(),
          numVuln: obj["numVuln"],
          resultPoint: obj["resultPoint"].toDouble(),
          id: obj["id"].toString(),
          resultSeverity: obj["resultSeverity"].toString(),
          vuln: listVuln,
          scanDate: obj["scanDate"].toString());
      dataBeforeParse.add(newVuln);
    }
    // get all vuln available and convert to string, separated by comma
    for (var vuln in listVuln) {
      dropdownValue.add(DropdownMenuItem(
        value: vuln.type.toString(),
        child: Text(vuln.type),
      ));
    }
    //dataRows = updateTable(state, dataBeforeParse);
    //select module to scan
    bool isHide(newData) {
      if (newData["numVuln"] == 0) {
        return false;
      } else {
        return true;
      }
    }

    return Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // dropdown
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                GradientButton(
                  horizontalMargin: 40,
                  verticalMargin: 10,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                Container(
                  margin: const EdgeInsetsDirectional.only(start: 40, top: 10),
                  child: Text("SCAN RESULT",
                      style: GoogleFonts.montserrat(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                Container(
                  margin: const EdgeInsetsDirectional.only(end: 40),
                  width: 200,
                  height: 40,
                  child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.filter_alt_outlined, size: 30),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.black12)),
                        contentPadding: EdgeInsetsDirectional.only(start: 15),
                      ),
                      focusColor: const Color(0xFFF0F0F0),
                      icon: const Icon(Icons.arrow_drop_down),
                      dropdownColor: Colors.white,
                      value: state,
                      items: dropdownValue,
                      onSaved: (v) {
                        setState(() {
                          state = v!;
                        });
                      },
                      onChanged: (v) {
                        setState(() {
                          state = v!;
                        });
                      }),
                ),
              ]),
              const Divider(
                  color: Colors.black,
                  thickness: 0.2,
                  indent: 40,
                  endIndent: 40),
              Container(
                height: screenHeight / 2,
                width: screenWidth,
                margin: const EdgeInsetsDirectional.only(
                    start: 40, end: 40, top: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 15,
                      spreadRadius: -7,
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsetsDirectional.only(
                          top: 20, start: 40, end: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Domain: ${dataBeforeParse[0].domain}',
                            style: GoogleFonts.montserrat(
                                fontSize: 24, fontWeight: FontWeight.normal),
                          ),
                          const Spacer(),
                          Text(
                            'Result Point: ${dataBeforeParse[0].resultPoint}',
                            style: GoogleFonts.montserrat(
                                fontSize: 24, fontWeight: FontWeight.normal),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: screenWidth,
                      height: screenHeight / 2 - 100,
                      margin: const EdgeInsetsDirectional.only(
                          start: 40, end: 40, top: 20),
                      decoration: BoxDecoration(
                        color: Colors.indigo[200],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 15,
                            spreadRadius: -7,
                          )
                        ],
                      ),
                      child: DataTable2(columns: const [
                        DataColumn2(
                          label: Text('Severity'),
                          tooltip: 'Blue - Low, Yellow - Medium, Red - High',
                        ),
                        DataColumn2(
                          label: Text('Type'),
                          tooltip: 'Type of vulnerability',
                        ),
                        DataColumn2(
                          label: Text('Payloads used'),
                          tooltip: 'Payloads used to get the result',
                        ),
                      ], rows: updateTable(state, listVuln)),
                    ),
                  ],
                ),
              ),
              Container(
                width: screenWidth,
                height: screenHeight / 2 - 150,
                margin: const EdgeInsetsDirectional.only(start: 40, end: 40, top: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 15,
                      spreadRadius: -7,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Image(image: AssetImage('lib/assets/Folders_light.png')),
                      title: Text(
                        'Description',
                        style: GoogleFonts.montserrat(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Constants.content_vulnerabilities[0],
                            // Add other scrollable content here
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )


            ]));
  }

  Container container(double screenWidth, double screenHeight,
      {required Widget child}) {
    return Container(
        width: screenWidth,
        height: screenHeight,
        margin: const EdgeInsetsDirectional.only(start: 40, end: 40),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 15,
              spreadRadius: -7,
            )
          ],
        ),
        child: child);
  }
}
