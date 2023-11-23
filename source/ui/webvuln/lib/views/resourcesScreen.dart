// ignore_for_file: camel_case_types, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webvuln/items/newSubmitButton.dart';
import 'package:webvuln/model/model.dart';
import 'package:webvuln/service/api.dart';
import 'package:google_fonts/google_fonts.dart';
import '../items/input.dart';
import 'package:data_table_2/data_table_2.dart';

// TODO: Dropdown change screen
class resourceScreen extends StatefulWidget {
  const resourceScreen({super.key});

  @override
  State<resourceScreen> createState() => _resourceScreenState();
}

class _resourceScreenState extends State<resourceScreen> {
  late String state;
  List<ResourceNormalTableData> tableDataList = [];
  List<DataRow> dataRowList = [];
  @override
  void initState() {
    state = '/normalResource';
    super.initState();
  }

  void updateTable(List<ResourceNormalTableData> newData) {
    setState(() {
      tableDataList = newData;
      dataRowList = tableDataList
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

  @override
  Widget build(BuildContext context) {
    final TextEditingController _vulnTypeController = TextEditingController();
    final TextEditingController _typeController = TextEditingController();
    final TextEditingController _valueController = TextEditingController();
    final TextEditingController _actionController = TextEditingController();
    final TextEditingController _vulnTypeSearchController =
        TextEditingController();
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width *
        (1 - 0.13); // 0.13 is width of sidebar
    List<ResourceNormalTableData> tableDataList;
    Widget selectedWidget;
    if (state == '/fileResource') {
      selectedWidget = fileResource(
        screenHeight: screenHeight,
        screenWidth: screenWidth,
        actionController: _actionController,
      );
    } else if (state == '/normalResource') {
      selectedWidget = normalResource(
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          actionController: _actionController);
    } else {
      // Handle default case or provide an empty widget
      selectedWidget = Container();
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
                      value: '/normalResource', child: Text('Normal Resource')),
                  DropdownMenuItem(
                      value: '/fileResource', child: Text('File Resource'))
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
                  print(state);
                }),
          ),
          //table
          Container(
            width: screenWidth,
            height: screenHeight / 2,
            margin:
                const EdgeInsetsDirectional.only(start: 40, end: 40, top: 10),
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
                      controller: _vulnTypeController,
                      content: "Vulnerability Type"),
                  boxInput(
                      width: screenWidth / 4,
                      controller: _typeController,
                      content: "Type"),
                  GradientButton(
                      horizontalMargin: 50,
                      onPressed: () async {
                        String response = await getResourcesNormal(
                            vulnType: _vulnTypeController.text,
                            resType: _typeController.text);
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
                            .map((json) =>
                                ResourceNormalTableData.fromJson(json))
                            .toList();
                        updateTable(newData);
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
                        DataColumn2(
                            label: Text('Vulnerability'), size: ColumnSize.S),
                        DataColumn2(
                            label: Text('Resource Type'), size: ColumnSize.S),
                        DataColumn2(label: Text('Value'), size: ColumnSize.L),
                        DataColumn2(
                            label: Text('Created Date'), size: ColumnSize.S),
                        DataColumn2(
                            label: Text('Edited Date'), size: ColumnSize.S),
                      ],
                      rows: dataRowList)),
            ]),
          ),

          // search box
          selectedWidget,
        ],
      ),
    );
  }

  Container boxInput(
      {required TextEditingController controller,
      required String content,
      required double width}) {
    return Container(
      width: width,
      height: 50,
      margin:
          const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 20),
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
      margin:
          const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 20),
      child: inputUser(
        controller: controller,
        hintName: content,
        underIcon: const Icon(Icons.text_fields),
      ),
    );
  }

  Container normalResource(
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

  Container fileResource(
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
