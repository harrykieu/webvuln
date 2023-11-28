// ignore_for_file: camel_case_types, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webvuln/items/newSubmitButton.dart';
import 'package:webvuln/model/model.dart';
import 'package:webvuln/service/api.dart';
import 'package:google_fonts/google_fonts.dart';
import '../items/input.dart';
import 'package:data_table_2/data_table_2.dart';

class resourceScreen extends StatefulWidget {
  const resourceScreen({super.key});

  @override
  State<resourceScreen> createState() => _resourceScreenState();
}

class _resourceScreenState extends State<resourceScreen> {
  late String state;
  late String fileGetState;
  late String fileSendState;
  List<ResourceNormalTableData> normalTableDataList = [];
  List<ResourceFileTableData> fileTableDataList = [];
  List<DataRow> dataRowList = [];

  @override
  void initState() {
    state = '/normalPost';
    fileGetState = 'valid';
    fileSendState = 'valid';
    super.initState();
  }

  void updateTableNormal(List<ResourceNormalTableData> newData) {
    setState(() {
      normalTableDataList = newData;
      dataRowList = normalTableDataList
          .map((tableData) => DataRow(cells: [
                DataCell(Text(tableData.vulnType)),
                DataCell(Text(tableData.type)),
                DataCell(Text(tableData.value)),
                DataCell(Text(tableData.createdDate)),
                DataCell(Text(tableData.editedDate)),
              ]))
          .toList();
    });
  }

  void updateTableFile(List<ResourceFileTableData> newData) {
    setState(() {
      fileTableDataList = newData;
      dataRowList = fileTableDataList
          .map((tableData) => DataRow(cells: [
                DataCell(Text(tableData.fileName)),
                DataCell(Text(tableData.description)),
                DataCell(Text(tableData.base64value ?? '')),
                DataCell(Text(tableData.createdDate)),
                DataCell(Text(tableData.editedDate)),
              ]))
          .toList();
    });
  }

  void updateDropdownState(String newState) {
    setState(() {
      fileGetState = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController vulnTypeController = TextEditingController();
    final TextEditingController typeController = TextEditingController();
    final TextEditingController valueController = TextEditingController();
    final TextEditingController actionController = TextEditingController();
    final TextEditingController vulnTypeSearchController =
        TextEditingController();
    final double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width *
        (1 - 0.13); // 0.13 is width of sidebar
    Widget inputWidget;
    Widget tableWidget;
    if (state == '/filePost') {
      inputWidget = filePost(
        screenHeight: screenHeight,
        screenWidth: screenWidth,
        actionController: actionController,
      );
      tableWidget = fileSearch(
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          fileState: fileGetState);
      //tableWidget =
    } else if (state == '/normalPost') {
      inputWidget = normalPost(
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          actionController: actionController);
      tableWidget = normalSearch(
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          vulnTypeController: vulnTypeController,
          typeController: typeController);
    } else {
      // Handle default case or provide an empty widget
      inputWidget = Container();
      tableWidget = Container();
    }
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // dropdown
          SizedBox(
            width: 200,
            height: 50,
            child: DropdownButtonFormField<String>(
                focusColor: Colors.white,
                icon: const Icon(Icons.arrow_drop_down),
                dropdownColor: Colors.white,
                value: state,
                items: const [
                  DropdownMenuItem(
                      value: '/normalPost', child: Text('Normal Resource')),
                  DropdownMenuItem(
                      value: '/filePost', child: Text('File Resource'))
                ],
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
          //table
          tableWidget,
          // search box
          inputWidget,
        ],
      ),
    );
  }

  Container normalSearch(
      {required double screenHeight,
      required double screenWidth,
      required TextEditingController vulnTypeController,
      required TextEditingController typeController}) {
    return Container(
      width: screenWidth,
      height: screenHeight / 2,
      margin: const EdgeInsetsDirectional.only(start: 40, end: 40, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black38),
        color: Colors.white12,
      ),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsetsDirectional.only(start: 40),
              child: Text("Enter search criteria:",
                  style: GoogleFonts.montserrat(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            boxInput(
                width: screenWidth / 4,
                controller: vulnTypeController,
                content: "Vulnerability Type"),
            boxInput(
                width: screenWidth / 4,
                controller: typeController,
                content: "Type"),
            GradientButton(
                horizontalMargin: 50,
                onPressed: () async {
                  String response = await getResourcesNormal(
                      vulnType: vulnTypeController.text,
                      resType: typeController.text);
                  if (response == '[]') {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('No result found'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'))
                            ],
                          );
                        });
                  }
                  List<dynamic> jsonD = jsonDecode(response);
                  List<ResourceNormalTableData> newData = jsonD
                      .map((json) => ResourceNormalTableData.fromJson(json))
                      .toList();
                  updateTableNormal(newData);
                },
                borderRadius: BorderRadius.circular(10),
                child: const Text(
                  'Find',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        Container(
            // TODO: calculate height of table using other element's height
            // (need to find efficient way)
            height: screenHeight / 2 - 50 - 20 - 20 - 10,
            width: screenWidth,
            margin: const EdgeInsetsDirectional.symmetric(horizontal: 40),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Colors.white24),
            child: DataTable2(
                columnSpacing: 10,
                columns: const [
                  DataColumn2(label: Text('Vulnerability'), size: ColumnSize.S),
                  DataColumn2(label: Text('Resource Type'), size: ColumnSize.S),
                  DataColumn2(label: Text('Value'), size: ColumnSize.L),
                  DataColumn2(label: Text('Created Date'), size: ColumnSize.S),
                  DataColumn2(label: Text('Edited Date'), size: ColumnSize.S),
                ],
                rows: dataRowList)),
      ]),
    );
  }

  Container fileSearch(
      {required double screenHeight,
      required double screenWidth,
      required String fileState}) {
    return Container(
      width: screenWidth,
      height: screenHeight / 2,
      margin: const EdgeInsetsDirectional.only(start: 40, end: 40, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black38),
        color: Colors.white12,
      ),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsetsDirectional.only(start: 40),
              child: Text("Enter search criteria:",
                  style: GoogleFonts.montserrat(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 50,
              width: 400,
              margin: const EdgeInsetsDirectional.only(end: 40),
              child: DropdownButtonFormField<String>(
                  focusColor: Colors.white,
                  icon: const Icon(Icons.arrow_drop_down),
                  dropdownColor: Colors.white,
                  value: fileState,
                  items: const [
                    DropdownMenuItem(value: 'valid', child: Text('Valid File')),
                    DropdownMenuItem(
                        value: 'invalidbutvalidMH',
                        child: Text('Invalid file but valid Magic Header')),
                    DropdownMenuItem(
                        value: 'invalidbutvalidExtension',
                        child: Text('Invalid file but valid Extension'))
                  ],
                  onSaved: (v) {
                    updateDropdownState(v!);
                  },
                  onChanged: (v) {
                    updateDropdownState(v!);
                    print(v);
                  }),
            ),
            GradientButton(
                horizontalMargin: 50,
                onPressed: () async {
                  print(fileState);
                  String response =
                      await getResourcesFile(description: fileState);
                  if (response == '[]') {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('No result found'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'))
                            ],
                          );
                        });
                  }
                  List<dynamic> jsonD = jsonDecode(response);
                  List<ResourceFileTableData> newData = jsonD
                      .map((json) => ResourceFileTableData.fromJson(json))
                      .toList();
                  updateTableFile(newData);
                },
                borderRadius: BorderRadius.circular(10),
                child: const Text(
                  'Find',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        Container(
            // TODO: calculate height of table using other element's height
            // (need to find efficient way)
            height: screenHeight / 2 - 50 - 20 - 20 - 10,
            width: screenWidth,
            margin: const EdgeInsetsDirectional.symmetric(horizontal: 40),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Colors.white24),
            child: DataTable2(
                columnSpacing: 10,
                columns: const [
                  DataColumn2(label: Text('File name'), size: ColumnSize.S),
                  DataColumn2(label: Text('Description'), size: ColumnSize.S),
                  DataColumn2(label: Text('Base64 Value'), size: ColumnSize.L),
                  DataColumn2(label: Text('Created Date'), size: ColumnSize.S),
                  DataColumn2(label: Text('Edited Date'), size: ColumnSize.S),
                ],
                rows: dataRowList)),
      ]),
    );
  }

  Container normalPost(
      {required double screenHeight,
      required double screenWidth,
      required TextEditingController actionController}) {
    return Container(
      width: screenWidth,
      height: screenHeight / 2 - 100 - 50,
      margin:
          const EdgeInsetsDirectional.symmetric(horizontal: 40, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black38),
        color: Colors.white12,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                margin: const EdgeInsetsDirectional.only(start: 40),
                child: Text("Vulnerability type:",
                    style: GoogleFonts.montserrat(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              boxInput1(controller: actionController, content: "Type here...")
            ]),
            const Divider(
                color: Colors.black, thickness: 0.2, indent: 40, endIndent: 40),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                margin: const EdgeInsetsDirectional.only(start: 40),
                child: Text("Resource type:",
                    style: GoogleFonts.montserrat(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              boxInput1(controller: actionController, content: "Type here...")
            ]),
            const Divider(
                color: Colors.black, thickness: 0.2, indent: 40, endIndent: 40),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                margin: const EdgeInsetsDirectional.only(start: 40),
                child: Text("Value:",
                    style: GoogleFonts.montserrat(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              boxInput1(controller: actionController, content: "Type here...")
            ]),
            GradientButton(
                onPressed: () {
                  print("Send");
                },
                horizontalMargin: 40,
                verticalMargin: 0,
                borderRadius: BorderRadius.circular(10),
                child: const Text(
                  'Send',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }

  Container filePost(
      {required double screenHeight,
      required double screenWidth,
      required TextEditingController actionController}) {
    String fileState = 'valid';
    return Container(
      width: screenWidth,
      height: screenHeight / 2 - 100 - 50,
      margin:
          const EdgeInsetsDirectional.symmetric(horizontal: 40, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black38),
        color: Colors.white12,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                margin: const EdgeInsetsDirectional.only(start: 40, top: 10),
                child: Text("File type:",
                    style: GoogleFonts.montserrat(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              // TODO: fix dropdown value
              Container(
                width: 400,
                margin: const EdgeInsetsDirectional.only(end: 40, top: 10),
                child: DropdownButtonFormField<String>(
                    focusColor: Colors.white,
                    icon: const Icon(Icons.arrow_drop_down),
                    dropdownColor: Colors.white,
                    value: fileState,
                    items: const [
                      DropdownMenuItem(
                          value: 'valid', child: Text('Valid File')),
                      DropdownMenuItem(
                          value: 'invalidbutvalidMH',
                          child: Text('Invalid file but valid Magic Header')),
                      DropdownMenuItem(
                          value: 'invalidbutvalidExtension',
                          child: Text('Invalid file but valid Extension'))
                    ],
                    onSaved: (v) {
                      setState(() {
                        fileState = v!;
                      });
                    },
                    onChanged: (v) {
                      setState(() {
                        fileState = v!;
                      });
                      print(fileState);
                    }),
              ),
            ]),
            const Divider(
                color: Colors.black, thickness: 0.2, indent: 40, endIndent: 40),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                margin: const EdgeInsetsDirectional.only(start: 40, top: 10),
                child: Text("Choose file:",
                    style: GoogleFonts.montserrat(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              GradientButton(
                  borderRadius: BorderRadius.circular(10),
                  horizontalMargin: 40,
                  verticalMargin: 10,
                  onPressed: () {
                    print("Browse");
                  },
                  child: Text("Browse",
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.white)))
            ]),
            const Divider(
                color: Colors.black, thickness: 0.2, indent: 40, endIndent: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: screenWidth / 2 + 200,
                  height: screenHeight / 4 - 100,
                  margin: const EdgeInsetsDirectional.only(
                      start: 40, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white24),
                    color: const Color.fromARGB(255, 189, 149, 134),
                  ),
                  child: ListTile(
                    title: Text("File Information:",
                        style: GoogleFonts.montserrat(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: const Text("This file is sus"),
                  ),
                ),
                GradientButton(
                    onPressed: () {
                      print("Send");
                    },
                    horizontalMargin: 40,
                    verticalMargin: 10,
                    borderRadius: BorderRadius.circular(10),
                    child: const Text(
                      'Send',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Container boxInput(
    {required TextEditingController controller,
    required String content,
    required double width}) {
  return Container(
    width: width,
    height: 50,
    margin: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 20),
    child: inputUser(
      controller: controller,
      hintName: content,
      underIcon: const Icon(Icons.text_fields),
    ),
  );
}

Container boxInput1(
    {required TextEditingController controller, required String content}) {
  return Container(
    width: 400,
    height: 50,
    margin: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 20),
    child: inputUser(
      controller: controller,
      hintName: content,
      underIcon: const Icon(Icons.text_fields),
    ),
  );
}
