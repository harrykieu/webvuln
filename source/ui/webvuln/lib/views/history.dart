// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webvuln/items/gradient_button.dart';
import 'package:webvuln/model/model.dart';
import 'package:webvuln/service/api.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:webvuln/views/result.dart';
import '../items/input.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
                  DataCell(Text(tableData.domain,
                      style: GoogleFonts.montserrat(fontSize: 16))),
                  DataCell(Text(tableData.scanDate,
                      style: GoogleFonts.montserrat(fontSize: 16))),
                  DataCell(Text(tableData.numVuln.toString(),
                      style: GoogleFonts.montserrat(fontSize: 16))),
                  DataCell(Text(tableData.resultSeverity,
                      style: GoogleFonts.montserrat(fontSize: 16))),
                  DataCell(Text(tableData.resultPoint.toString(),
                      style: GoogleFonts.montserrat(fontSize: 16))),
                ],
                onTap: () async {
                  String resp = await getHistory(
                    nameURL: tableData.domain,
                    // for compatibility with backend
                    datetime: '${tableData.scanDate.replaceAll(' ', 'T')}Z',
                  );
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResultScreen(
                                data: resp,
                              )));
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
      appBar: AppBar(
          title: ListTile(
        leading: const Icon(Icons.history),
        title: Text(
          "HISTORY",
          style:
              GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // search bar
          Container(
            width: screenWidth,
            height: 75,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Search criteria: ",
                    style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
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
                        .map((json) => HistoryTableData.fromJsonHistory(json))
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
              height: screenHeight - 220,
              margin: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
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
                child: DataTable2(
                  columns: [
                    DataColumn2(
                        label: Text(
                          'Domain',
                          style: GoogleFonts.montserrat(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        size: ColumnSize.M),
                    DataColumn2(
                      label: Text(
                        'Scan Date',
                        style: GoogleFonts.montserrat(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      size: ColumnSize.M,
                      // TODO: sort by date
                    ),
                    DataColumn2(
                        label: Text(
                          'Number of Vulnerabilities',
                          style: GoogleFonts.montserrat(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        size: ColumnSize.M),
                    DataColumn2(
                        label: Text(
                          'Severity',
                          style: GoogleFonts.montserrat(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        size: ColumnSize.S),
                    DataColumn2(
                        label: Text(
                          'Safety Rating',
                          style: GoogleFonts.montserrat(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        size: ColumnSize.S),
                  ],
                  rows: dataRowList,
                ),
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
