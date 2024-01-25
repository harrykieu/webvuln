// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webvuln/items/gradient_button.dart';
import 'package:webvuln/model/model.dart';
import 'package:webvuln/service/api.dart';
import 'package:webvuln/variable.dart';

class ResultScreen extends StatefulWidget {
  final String data;

  const ResultScreen({super.key, required this.data});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
  String get resultData => data;
}

class _ResultScreenState extends State<ResultScreen> {
  bool isVisibled = true;
  bool isAppeared = true;
  String state = 'All';
  // String exportState = dotenv.env['DEFAULT_EXPORT_TYPE']!;
  String exportState = 'pdf';
  List<HistoryTableData> jsonDecoded = [];

  @override
  // bool isVisibled = true;
  void initState() {
    super.initState();
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

  // function to parse data to table based on the selected module
  List<DataRow> updateTable(String vulnType, List<Vulnerability> data,
      double dialogWidth, double dialogHeight) {
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
        .map((e) => DataRow2(
                cells: [
                  DataCell(warnLevel(e.severity)),
                  DataCell(Text(e.type)),
                  DataCell(Text(e.payload.toString())),
                ],
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Row(
                              children: [
                                const Icon(Icons.warning_amber_sharp),
                                const SizedBox(width: 10),
                                Text('VULNERABILITY DETAILS',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            content: SizedBox(
                                width: dialogWidth,
                                height: dialogHeight,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Type: ",
                                            style: GoogleFonts.montserrat(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        Text(e.type,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Severity: ",
                                            style: GoogleFonts.montserrat(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        Text(e.severity,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Payload used: ",
                                            style: GoogleFonts.montserrat(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        Text(e.payload.toString(),
                                            style: GoogleFonts.montserrat(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500))
                                      ],
                                    ),
                                    Text("Scanner module logs: ",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[350],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: SingleChildScrollView(
                                          child: Text(e.logs,
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'))
                            ],
                          ));
                }))
        .toList();
    return dataRows;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double dialogWidth = MediaQuery.of(context).size.width / 2;
    double dialogHeight = MediaQuery.of(context).size.height / 2;
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

    return Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        appBar: AppBar(
            title: ListTile(
          leading: const Icon(Icons.checklist_rounded),
          title: Text("SCAN RESULT",
              style: GoogleFonts.montserrat(
                  fontSize: 24, fontWeight: FontWeight.bold)),
          trailing: SizedBox(
            width: 200,
            height: 40,
            child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  icon: Icon(Icons.filter_alt_outlined, size: 30),
                  alignLabelWithHint: true,
                  label: Text('Filter by type'),
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
        )),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // dropdown
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
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          Text(
                            'Result Point: ${dataBeforeParse[0].resultPoint}',
                            style: GoogleFonts.montserrat(
                                fontSize: 24, fontWeight: FontWeight.w500),
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
                      child: DataTable2(
                          columns: [
                            DataColumn2(
                              label: Text(
                                'Severity',
                                style: GoogleFonts.montserrat(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              tooltip:
                                  'Blue - Low, Yellow - Medium, Red - High',
                            ),
                            DataColumn2(
                              label: Text(
                                'Type',
                                style: GoogleFonts.montserrat(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              tooltip: 'Type of vulnerability',
                            ),
                            DataColumn2(
                              label: Text(
                                'Payloads used',
                                style: GoogleFonts.montserrat(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              tooltip: 'Payloads used to get the result',
                            ),
                          ],
                          rows: updateTable(
                              state, listVuln, dialogWidth, dialogHeight)),
                    ),
                  ],
                ),
              ),
              Container(
                  width: screenWidth,
                  height: screenHeight / 2 - 200,
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          title: Row(
                            children: [
                              const Image(
                                  image: AssetImage(
                                      'lib/assets/Folders_light.png')),
                              const SizedBox(width: 10),
                              Text(
                                'VULNERABILITIES DEFINITIONS',
                                style: GoogleFonts.montserrat(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Constants.vulnDesc,
                      ],
                    ),
                  )),
              SizedBox(
                width: screenWidth,
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsetsDirectional.only(top: 20),
                      width: 200,
                      child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            icon:
                                Icon(Icons.document_scanner_outlined, size: 30),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(color: Colors.black12)),
                            contentPadding:
                                EdgeInsetsDirectional.only(start: 15),
                            label: Text('Export report as'),
                          ),
                          focusColor: const Color(0xFFF0F0F0),
                          icon: const Icon(Icons.arrow_drop_down),
                          dropdownColor: Colors.white,
                          value: exportState,
                          items: const [
                            DropdownMenuItem(
                              value: 'csv',
                              child: Text('CSV'),
                            ),
                            DropdownMenuItem(
                              value: 'json',
                              child: Text('JSON'),
                            ),
                            DropdownMenuItem(
                              value: 'pdf',
                              child: Text('PDF'),
                            )
                          ],
                          onSaved: (v) {
                            setState(() {
                              exportState = v!;
                            });
                          },
                          onChanged: (v) {
                            setState(() {
                              exportState = v!;
                            });
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: GradientButton(
                        horizontalMargin: 40,
                        verticalMargin: 10,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        onPressed: () async {
                          // TODO: implement export function
                          String result = await createReport(
                              result: jsonDecoded, type: exportState);
                          // ignore: use_build_context_synchronously
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Row(
                                      children: [
                                        const Icon(Icons.error),
                                        const SizedBox(width: 5),
                                        Text('Export status',
                                            style: GoogleFonts.montserrat(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                    content: Text('$result',
                                        style: GoogleFonts.montserrat(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal)),
                                    alignment: Alignment.center,
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('OK'))
                                    ],
                                  ));
                        },
                        child: const Text(
                          'Export',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
