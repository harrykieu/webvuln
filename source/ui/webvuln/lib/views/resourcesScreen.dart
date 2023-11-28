// ignore_for_file: camel_case_types, avoid_print, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:data_table_2/data_table_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:webvuln/items/newSubmitButton.dart';
import 'package:webvuln/model/model.dart';
import 'package:webvuln/service/api.dart';

import '../items/input.dart';

// TODO: Add feature to edit and delete resource
// TODO: Separate file and normal resource into different content table
// TODO: Change post normal resource to use dropdown menu
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
  late ResourceFile resourceFile;
  // For file information
  late String fileInfo;
  @override
  void initState() {
    state = '/normalPost';
    fileGetState = 'valid';
    fileSendState = 'valid';
    fileInfo = '';
    // ignore: prefer_const_constructors
    resourceFile = ResourceFile(
        fileName: '', description: '', base64value: '', action: '');
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
                DataCell(Text(tableData.base64value)),
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

  void chooseFile(String newInfo, String filename, String description,
      String base64value, String action) {
    setState(() {
      fileInfo = newInfo;
      resourceFile = ResourceFile(
          fileName: filename,
          description: description,
          base64value: base64value,
          action: action);
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController vulnTypeController = TextEditingController();
    final TextEditingController typeController = TextEditingController();
    final TextEditingController valueController = TextEditingController();
    final TextEditingController actionController = TextEditingController();
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
        fileInfo: fileInfo,
        resourceFile: resourceFile,
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
        vulnTypeController: vulnTypeController,
        typeController: typeController,
        valueController: valueController,
      );
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
      backgroundColor: const Color(0xFFF0F0F0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // dropdown
          SizedBox(
            width: 200,
            height: 50,
            child: DropdownButtonFormField<String>(
                focusColor: const Color(0xFFF0F0F0),
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
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 15,
              spreadRadius: -7,
            )
          ]),
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
                        context: context as BuildContext,
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
            height: screenHeight / 2 - 50 - 20 - 20 - 10 - 10,
            width: screenWidth,
            margin: const EdgeInsetsDirectional.only(
                start: 40, end: 40, bottom: 10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Colors.white24),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.blue.shade100),
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
                    DataColumn2(label: Text('Edited Date'), size: ColumnSize.S),
                  ],
                  rows: dataRowList),
            )),
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
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 15,
              spreadRadius: -7,
            )
          ]),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsetsDirectional.only(start: 40),
              child: Text("File type:",
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
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.brown.shade100),
              child: DataTable2(
                  columnSpacing: 10,
                  columns: const [
                    DataColumn2(label: Text('File name'), size: ColumnSize.S),
                    DataColumn2(label: Text('Description'), size: ColumnSize.S),
                    DataColumn2(
                        label: Text('Base64 Value'), size: ColumnSize.L),
                    DataColumn2(
                        label: Text('Created Date'), size: ColumnSize.S),
                    DataColumn2(label: Text('Edited Date'), size: ColumnSize.S),
                  ],
                  rows: dataRowList),
            )),
      ]),
    );
  }

  Container normalPost(
      {required double screenHeight,
      required double screenWidth,
      required TextEditingController vulnTypeController,
      required TextEditingController typeController,
      required TextEditingController valueController}) {
    return Container(
      width: screenWidth,
      height: screenHeight / 2 - 100 - 50,
      margin:
          const EdgeInsetsDirectional.symmetric(horizontal: 40, vertical: 10),
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
              boxInput1(controller: vulnTypeController, content: "Type here...")
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
              boxInput1(controller: typeController, content: "Type here...")
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
              boxInput1(controller: valueController, content: "Type here...")
            ]),
            GradientButton(
                onPressed: () async {
                  String resp = await postResources(
                      vulnType: vulnTypeController.text,
                      resType: typeController.text,
                      value: valueController.text,
                      action: "add");
                  if (resp == 'Failed to Post Resources' ||
                      resp.contains('Error post resources')) {
                    print("Failed to post file");
                  } else {
                    print("Posted file successfully");
                  }
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

  Container filePost({
    required double screenHeight,
    required double screenWidth,
    required TextEditingController actionController,
    required String fileInfo,
    required ResourceFile resourceFile,
  }) {
    String fileState = 'valid';
    return Container(
      width: screenWidth,
      height: screenHeight / 2 - 100 - 50,
      margin:
          const EdgeInsetsDirectional.symmetric(horizontal: 40, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.brown.shade100,
              blurRadius: 15,
              spreadRadius: -7,
            )
          ]),
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
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    if (result != null) {
                      File file = File(result.files.single.path!);
                      try {
                        // TODO: add loading screen while analyzing file
                        final filename = basename(result.files.single.path!);
                        var filestat = file.statSync();
                        final fileInfoStr =
                            "Filename: $filename\nSize: ${filestat.size} bytes\nType: ${filestat.type}";
                        List<int> bytes = file.readAsBytesSync();
                        String base64value = base64Encode(bytes);
                        chooseFile(fileInfoStr, filename, fileState,
                            base64value, "add");
                      } catch (e) {
                        print("Error reading file: $e");
                      }
                    } else {
                      print("Something went wrong!");
                    }
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
                    color: Colors.brown.shade100,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ListTile(
                      title: Text(
                        "File Information:",
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        fileInfo,
                        // Use null-aware operator
                        overflow: TextOverflow.values[1],
                        style: GoogleFonts.montserrat(fontSize: 15),
                      ),
                    ),
                  ),
                ),
                GradientButton(
                    onPressed: () async {
                      String resp = await postResourcesFile(
                          fileName: resourceFile.fileName!,
                          description: resourceFile.description,
                          base64value: resourceFile.base64value!,
                          action: resourceFile.action!);
                      if (resp == 'Failed to Post Resources' ||
                          resp.contains('Error post resources')) {
                        print("Failed to post file");
                      } else {
                        print("Posted file successfully");
                      }
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
