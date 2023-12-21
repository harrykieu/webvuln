// ignore_for_file: non_constant_identifier_names, duplicate_ignore, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:webvuln/items/newSubmitButton.dart';
import 'package:webvuln/views/detail_screen.dart';
import 'package:webvuln/views/resultScreen.dart';

class CustomDataTable extends StatelessWidget {
  final List<DataRow> rows;

  const CustomDataTable({required this.rows, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle text_style_title = GoogleFonts.montserrat(
        fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold);
    TextStyle text_style_bold = GoogleFonts.montserrat(
        fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold);
    TextStyle text_style_normal = GoogleFonts.montserrat(
        fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal);
    TextStyle text_style_normal_white = GoogleFonts.montserrat(
        fontSize: 20, color: Colors.white, fontWeight: FontWeight.normal);
    TextStyle text_style_code = GoogleFonts.ubuntu(
        fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal);

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 400,
          margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 60, vertical: 20),
          decoration: const BoxDecoration(
              color: Color(0xFFDEEDFF),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: SingleChildScrollView(
            child: DataTable(
              columns: [
                DataColumn(
                  label: Row(
                    children: [
                      Text('Serverity', style: text_style_bold),
                      toolTip(
                          content:
                              'Color severity: Green - good, yellow - normal, red - bad'),
                    ],
                  ),
                ),
                DataColumn(
                  label: Row(
                    children: [
                      Text('Type', style: text_style_bold),
                      toolTip(
                          content: 'Name of vulnerabilities and type of this'),
                    ],
                  ),
                ),
                DataColumn(
                  label: Row(
                    children: [
                      Text('Description', style: text_style_bold),
                      toolTip(content: 'About domain, path, severity,....'),
                    ],
                  ),
                ),
                DataColumn(
                  label: Row(
                    children: [
                      Text('Scan Date', style: text_style_bold),
                      toolTip(content: 'Time and Date scan Url'),
                    ],
                  ),
                ),
              ],
              rows: rows,
            ),
          ),
        ),
        Positioned(
          top: 340,
          right: 35,
          child: GradientButton(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            onPressed: () {
              Get.to(const detail_screen());
            },
            child: const Icon(
              Icons.more_horiz,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  JustTheTooltip toolTip({required String content}) {
    return JustTheTooltip(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(content),
      ),
      child: const Icon(
        Icons.info_outline,
        color: Colors.black,
        size: 16,
      ),
    );
  }
}

class TableAll extends StatelessWidget {
  String dataTable;
  TableAll({super.key, required this.dataTable});
  // ignore: non_constant_identifier_names

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> dataVuln1 = jsonDecode(dataTable);
    List<Map<String, dynamic>> dataVulnList =
        List<Map<String, dynamic>>.from(dataVuln1["vulnerabilities"]);
  
    if (dataVulnList.isEmpty) {
      return const Text('No vulnerabilities');
    }

    Map<String, dynamic> dataVuln = dataVulnList[0];

    String type(data) {
      if (data["numVuln"] == 0) {
        print(dataTable);
        return 'No vulnerabilities';
      } else {
        return dataVuln["type"];
      }
    }

    int numVuln(data) {
      switch (data['numVuln']) {
        case 0:
          return 1;
        case 1:
          return 1;
        case 2:
          return 2;
        case 3:
          return 3;
        default:
          return 1;
      }
    }

    Icon icon_warning(data) {
      switch (data["severity"]) {
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
            Icons.check_circle_outline,
            color: Colors.green,
          );
      }
    }

    List<DataRow> duplicatedRows = List.generate(numVuln(dataVuln1), (index) {
      return DataRow(cells: [
        DataCell(icon_warning(dataVuln)),

        DataCell(Text(type(dataVuln), style: text_style_normal)),
        //using current data
        DataCell(Text(dataVuln["severity"].toString(), style: text_style_code)),
        DataCell(Text(dataVuln["scanDate"].toString(), style: text_style_code)),
      ]);
    });

    return CustomDataTable(
      rows: duplicatedRows,
    );
  }

  TextStyle get text_style_normal => GoogleFonts.montserrat(
        fontSize: 24,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      );

  TextStyle get text_style_code => GoogleFonts.ubuntu(
        fontSize: 24,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      );
}

class TableXSS extends StatelessWidget {
  String data;
  TableXSS({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> dataXSS = jsonDecode(data);
    List<Map<String, dynamic>> dataXSSList =
        List<Map<String, dynamic>>.from(dataXSS["vulnerabilities"]);
    
    Map<String,dynamic> jsonXSS = dataXSSList[0];
    if (dataXSSList.isEmpty) {
      return const Text('None vulnerabilities');
    }
    return CustomDataTable(
      rows: [
        DataRow(cells: [
          const DataCell(
              Icon(Icons.warning_amber, color: Colors.amber, size: 30)),
          DataCell(Text("XSS", style: text_style_normal)),
          DataCell(Text('"https://www.google.com.vn/intl/vi/about.html"',
              style: text_style_code)),
          DataCell(Text('"https://www.google.com.vn/intl/vi/about.html"',
              style: text_style_code))
        ]),
        // Add more rows as needed
      ],
    );
  }

  TextStyle get text_style_normal => GoogleFonts.montserrat(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      );

  TextStyle get text_style_code => GoogleFonts.ubuntu(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      );
}

class TableSQli extends StatelessWidget {
  const TableSQli({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDataTable(
      rows: [
        DataRow(cells: [
          const DataCell(
              Icon(Icons.warning_amber, color: Colors.amber, size: 30)),
          DataCell(Text("SQLi", style: text_style_normal)),
          DataCell(Text('"https://www.google.com.vn/intl/vi/about.html"',
              style: text_style_code)),
          DataCell(Text('"https://www.google.com.vn/intl/vi/about.html"',
              style: text_style_code))
        ]),
        // Add more rows as neededlo
      ],
    );
  }

  TextStyle get text_style_normal => GoogleFonts.montserrat(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      );

  TextStyle get text_style_code => GoogleFonts.ubuntu(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      );
}

class TableLFI extends StatelessWidget {
  const TableLFI({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDataTable(
      rows: [
        DataRow(cells: [
          const DataCell(
              Icon(Icons.warning_amber, color: Colors.amber, size: 30)),
          DataCell(Text("LFI", style: text_style_normal)),
          DataCell(Text('"https://www.google.com.vn/intl/vi/about.html"',
              style: text_style_code)),
        ]),
        // Add more rows as neededlo
      ],
    );
  }

  TextStyle get text_style_normal => GoogleFonts.montserrat(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      );

  TextStyle get text_style_code => GoogleFonts.ubuntu(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      );
}

class TableRCE extends StatelessWidget {
  const TableRCE({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDataTable(
      rows: [
        DataRow(cells: [
          const DataCell(
              Icon(Icons.warning_amber, color: Colors.amber, size: 30)),
          DataCell(Text("RCE", style: text_style_normal)),
          DataCell(Text('"https://www.google.com.vn/intl/vi/about.html"',
              style: text_style_code)),
        ]),
        // Add more rows as neededlo
      ],
    );
  }

  TextStyle get text_style_normal => GoogleFonts.montserrat(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      );

  TextStyle get text_style_code => GoogleFonts.ubuntu(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      );
}

// Add more table classes as needed
