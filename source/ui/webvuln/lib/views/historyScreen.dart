// ignore_for_file: file_names, camel_case_types, use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webvuln/items/newSubmitButton.dart';
import 'package:webvuln/model/model.dart';
import 'package:webvuln/service/api.dart';
import 'package:data_table_2/data_table_2.dart';
import '../items/input.dart';

class historyScreen extends StatefulWidget {
  const historyScreen({super.key});

  @override
  State<historyScreen> createState() => _historyScreenState();
}

class _historyScreenState extends State<historyScreen> {
  final TextEditingController _historyURLController = TextEditingController();
  final TextEditingController _dateScanController = TextEditingController();
  List<HistoryTableData> historyTableData = [];
  List<DataRow2> dataRowList = [];
  String value = "";
  @override
  void initState() {
    super.initState();
  }

  void updateTable(List<HistoryTableData> newData, BuildContext context) {
    setState(() {
      historyTableData = newData;
      dataRowList = historyTableData
          .map((tableData) => DataRow2(
                cells: [
                  DataCell(Text(tableData.domain)),
                  DataCell(Text(tableData.scanDate)),
                  DataCell(Text(tableData.numVuln.toString())),
                  DataCell(Text(tableData.resultSeverity)),
                  DataCell(Text(tableData.resultPoint.toString())),
                ],
                onTap: () async {
                  String resp = await getHistory(
                    nameURL: tableData.domain,
                    // for compatibility with backend
                    datetime: '${tableData.scanDate.replaceAll(' ', 'T')}Z',
                  );
                  List<dynamic> jsonD = jsonDecode(resp);
                  // TODO: show result screen with jsonD
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Row(
                              children: [
                                const Icon(Icons.history),
                                const SizedBox(width: 5),
                                Text('History',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            content: SizedBox(
                              width: 500,
                              height: 500,
                              child: ListView.builder(
                                itemCount: jsonD.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Scan date: ${jsonD[index]['scanDate']}',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Number of vulnerabilities: ${jsonD[index]['numVuln']}',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Result severity: ${jsonD[index]['resultSeverity']}',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Result point: ${jsonD[index]['resultPoint']}',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'))
                            ],
                          ));
                },
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width * (1 - 0.13);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsetsDirectional.only(start: 40, top: 10),
            child: Text(
              "HISTORY",
              style: GoogleFonts.montserrat(
                  fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ),
          const Divider(
            color: Colors.black,
            thickness: 0.2,
            indent: 40,
            endIndent: 40,
          ),
          // search bar
          Container(
            width: screenWidth,
            height: 75,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 15,
                    spreadRadius: -7,
                  )
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Text("Search criteria: ",
                      style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ),
                getBoxInput(
                    controller: _historyURLController,
                    content: "URL",
                    width: 300,
                    height: 40),
                getBoxInput(
                    controller: _dateScanController,
                    content: "Date/Time",
                    width: 300,
                    height: 40),
                GradientButton(
                  height: 40,
                  verticalMargin: 10,
                  borderRadius: BorderRadius.circular(10),
                  onPressed: () async {
                    String resp = await getHistory(
                      nameURL: _historyURLController.text,
                      datetime: _dateScanController.text,
                    );
                    if (resp == '[]') {
                      await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Row(
                                  children: [
                                    const Icon(Icons.error),
                                    const SizedBox(width: 5),
                                    Text('Error',
                                        style: GoogleFonts.montserrat(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                content: Text(
                                    'No history found with given criteria!',
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
                    }
                    List<dynamic> jsonD = jsonDecode(resp);
                    List<HistoryTableData> newData = jsonD
                        .map((json) => HistoryTableData.fromJson(json))
                        .toList();
                    updateTable(newData, context);
                  },
                  child: const Icon(
                    Icons.search_sharp,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          // history table
          Container(
              width: screenWidth,
              height: screenHeight - 200,
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 15,
                      spreadRadius: -7,
                    )
                  ]),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: DataTable2(columns: const [
                  DataColumn2(label: Text('Domain'), size: ColumnSize.M),
                  DataColumn2(label: Text('Scan Date'), size: ColumnSize.M),
                  DataColumn2(
                      label: Text('Number of Vulnerabilities'),
                      size: ColumnSize.M),
                  DataColumn2(label: Text('Severity'), size: ColumnSize.S),
                  DataColumn2(label: Text('Safety Rating'), size: ColumnSize.S),
                ], rows: dataRowList),
              ))
        ],
      ),
    );
  }

  Container getBoxInput(
      {required TextEditingController controller,
      required String content,
      required double width,
      required double height}) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 10,
      ),
      child: inputUser(
        controller: controller,
        hintName: content,
        underIcon: const Icon(Icons.text_fields),
      ),
    );
  }
}
