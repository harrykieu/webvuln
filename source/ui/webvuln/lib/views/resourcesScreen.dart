// ignore_for_file: camel_case_types, avoid_print, depend_on_referenced_packages, use_build_context_synchronously

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

  void updateTableNormal(List<ResourceNormalTableData> newData,
      TextEditingController valueEditController, BuildContext context) {
    setState(() {
      normalTableDataList = newData;
      dataRowList = normalTableDataList
          .map((tableData) => DataRow(cells: [
                DataCell(Text(tableData.vulnType)),
                DataCell(Text(tableData.type)),
                DataCell(Text(tableData.value)),
                DataCell(Text(tableData.createdDate)),
                DataCell(Text(tableData.editedDate)),
                DataCell(TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                              child: editDataNormal(
                                  vulnType: tableData.vulnType,
                                  type: tableData.type,
                                  value: tableData.value,
                                  createdDate: tableData.createdDate,
                                  editedDate: tableData.editedDate,
                                  valueEditController: valueEditController,
                                  context: context)));
                    },
                    child: const Icon(Icons.remove_red_eye))),
              ]))
          .toList();
    });
  }

  void updateTableFile(
      List<ResourceFileTableData> newData, BuildContext context) {
    setState(() {
      fileTableDataList = newData;
      dataRowList = fileTableDataList
          .map((tableData) => DataRow(cells: [
                DataCell(Text(tableData.fileName)),
                DataCell(Text(tableData.description)),
                DataCell(Text(tableData.base64value)),
                DataCell(Text(tableData.createdDate)),
                DataCell(Text(tableData.editedDate)),
                DataCell(TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                              child: editDataFile(
                                  fileName: tableData.fileName,
                                  description: tableData.description,
                                  base64value: tableData.base64value,
                                  createdDate: tableData.createdDate,
                                  editedDate: tableData.editedDate,
                                  context: context)));
                    },
                    child: const Icon(Icons.remove_red_eye))),
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
    // For search
    final TextEditingController vulnTypeSearchController =
        TextEditingController();
    final TextEditingController typeSearchController = TextEditingController();
    // For post
    final TextEditingController vulnTypePostController =
        TextEditingController();
    final TextEditingController typePostController = TextEditingController();
    // For edit
    final TextEditingController valueEditController = TextEditingController();
    final TextEditingController valueController = TextEditingController();
    final TextEditingController actionController = TextEditingController();
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width *
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
          fileState: fileGetState,
          context: context);
      dataRowList = [];
      //tableWidget =
    } else if (state == '/normalPost') {
      inputWidget = normalPost(
        screenHeight: screenHeight,
        screenWidth: screenWidth,
        vulnTypePostController: vulnTypePostController,
        typePostController: typePostController,
        valueController: valueController,
      ); 
      tableWidget = normalSearch(
        screenHeight: screenHeight,
        screenWidth: screenWidth,
        vulnTypeSearchController: vulnTypeSearchController,
        typeSearchController: typeSearchController,
        valueEditController: valueEditController,
        context: context,
      );
      dataRowList = [];
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsetsDirectional.only(start: 40, top: 10),
                child: Text("RESOURCE TYPE",
                    style: GoogleFonts.montserrat(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: const EdgeInsetsDirectional.only(end: 40),
                width: 200,
                height: 40,
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
            ],
          ),
          const Divider(
              color: Colors.black, thickness: 0.2, indent: 40, endIndent: 40),
          //table
          tableWidget,
          // search box
          inputWidget,
        ],
      ),
    );
  }

  Container normalSearch({
    required double screenHeight,
    required double screenWidth,
    required TextEditingController vulnTypeSearchController,
    required TextEditingController typeSearchController,
    required TextEditingController valueEditController,
    required BuildContext context,
  }) {
    return Container(
      width: screenWidth,
      height: screenHeight / 2,
      margin: const EdgeInsetsDirectional.only(start: 40, end: 40),
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
            getBoxInput(
                width: screenWidth / 4,
                controller: vulnTypeSearchController,
                content: "Vulnerability Type"),
            getBoxInput(
                width: screenWidth / 4,
                controller: typeSearchController,
                content: "Type"),
            GradientButton(
                horizontalMargin: 50,
                onPressed: () async {
                  String response = await getResourcesNormal(
                      vulnType: vulnTypeSearchController.text,
                      resType: typeSearchController.text);
                  if (response == '[]') {
                    showDialog(
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
                                  'No resource found with given criteria!',
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
                  List<dynamic> jsonD = jsonDecode(response);
                  List<ResourceNormalTableData> newData = jsonD
                      .map((json) => ResourceNormalTableData.fromJson(json))
                      .toList();
                  updateTableNormal(newData, valueEditController, context);
                },
                borderRadius: BorderRadius.circular(10),
                child: const Text(
                  'Find',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        Container(
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
                  DataColumn2(label: Text('Vulnerability'), fixedWidth: 100),
                  DataColumn2(label: Text('Resource Type'), fixedWidth: 120),
                  DataColumn2(label: Text('Value'), size: ColumnSize.L),
                  DataColumn2(label: Text('Created Date'), size: ColumnSize.S),
                  DataColumn2(
                    label: Text('Edited Date'),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(label: Text('Info'), fixedWidth: 40),
                ],
                rows: dataRowList,
              ),
            )),
      ]),
    );
  }

  Container fileSearch(
      {required double screenHeight,
      required double screenWidth,
      required String fileState,
      required BuildContext context}) {
    return Container(
      width: screenWidth,
      height: screenHeight / 2,
      margin: const EdgeInsetsDirectional.only(start: 40, end: 40),
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
                  String response =
                      await getResourcesFile(description: fileState);
                  if (response == '[]') {
                    showDialog(
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
                                  'No resource found with given criteria!',
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
                  List<dynamic> jsonD = jsonDecode(response);
                  List<ResourceFileTableData> newData = jsonD
                      .map((json) => ResourceFileTableData.fromJson(json))
                      .toList();
                  updateTableFile(newData, context);
                },
                borderRadius: BorderRadius.circular(10),
                child: const Text(
                  'Find',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        Container(
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
                color: Colors.brown.shade100,
              ),
              child: DataTable2(
                  columnSpacing: 20,
                  columns: const [
                    DataColumn2(label: Text('File name'), fixedWidth: 100),
                    DataColumn2(label: Text('Description'), fixedWidth: 100),
                    DataColumn2(
                        label: Text('Base64 Value'), size: ColumnSize.L),
                    DataColumn2(
                        label: Text('Created Date'), size: ColumnSize.S),
                    DataColumn2(label: Text('Edited Date'), size: ColumnSize.S),
                    DataColumn2(label: Text('Info'), fixedWidth: 40),
                  ],
                  rows: dataRowList),
            )),
      ]),
    );
  }

  Container normalPost(
      {required double screenHeight,
      required double screenWidth,
      required TextEditingController vulnTypePostController,
      required TextEditingController typePostController,
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
              postBoxInput(
                  controller: vulnTypePostController, content: "Type here...")
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
              postBoxInput(
                  controller: typePostController, content: "Type here...")
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
              postBoxInput(controller: valueController, content: "Type here...")
            ]),
            GradientButton(
                onPressed: () async {
                  String resp = await postResources(
                      vulnType: vulnTypePostController.text,
                      resType: typePostController.text,
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

  Container editDataNormal(
      {required String vulnType,
      required String type,
      required String value,
      required String createdDate,
      required String editedDate,
      required TextEditingController valueEditController,
      required BuildContext context}) {
    return Container(
        width: 1000,
        height: 280,
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("RESOURCE INFORMATION",
                    style: GoogleFonts.montserrat(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                                title: Row(
                                  children: [
                                    const Icon(Icons.warning),
                                    const SizedBox(width: 5),
                                    Text('Warning',
                                        style: GoogleFonts.montserrat(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                content: Text(
                                    'Are you sure you want to delete this resource?',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal)),
                                alignment: Alignment.center,
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        String resp = await postResources(
                                            vulnType: vulnType,
                                            resType: type,
                                            value: value,
                                            action: "remove");
                                        if (resp ==
                                                'Failed to Post Resources' ||
                                            resp.contains(
                                                'Error post resources')) {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                      title: Row(
                                                        children: [
                                                          const Icon(
                                                              Icons.error),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text('Error',
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))
                                                        ],
                                                      ),
                                                      content: Text(
                                                          'Failed to delete resource!',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal)),
                                                      alignment:
                                                          Alignment.center,
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'OK'))
                                                      ]));
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                      title: Row(
                                                        children: [
                                                          const Icon(
                                                              Icons.check),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text('Success',
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))
                                                        ],
                                                      ),
                                                      content: Text(
                                                          'Resource deleted successfully! Press Find again to see changes!',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal)),
                                                      alignment:
                                                          Alignment.center,
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'OK'))
                                                      ]));
                                        }
                                      },
                                      child: const Text('OK'))
                                ]));
                  },
                  icon: const Icon(Icons.delete),
                ),
                IconButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Row(
                                  children: [
                                    const Icon(Icons.edit),
                                    const SizedBox(width: 5),
                                    Text('Edit value:',
                                        style: GoogleFonts.montserrat(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    getBoxInput(
                                        width: 400,
                                        controller: valueEditController,
                                        content: "Type here..."),
                                    GradientButton(
                                        onPressed: () async {
                                          String resp = await postResources(
                                              vulnType: vulnType,
                                              resType: type,
                                              value: [
                                                value,
                                                valueEditController.text
                                              ],
                                              action: "update");
                                          if (resp ==
                                                  'Failed to Post Resources' ||
                                              resp.contains(
                                                  'Error post resources')) {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                        title: Row(
                                                          children: [
                                                            const Icon(
                                                                Icons.error),
                                                            const SizedBox(
                                                                width: 5),
                                                            Text('Error',
                                                                style: GoogleFonts.montserrat(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))
                                                          ],
                                                        ),
                                                        content: Text(
                                                            'Failed to edit resource!',
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)),
                                                        alignment:
                                                            Alignment.center,
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'OK'))
                                                        ]));
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                        title: Row(
                                                          children: [
                                                            const Icon(
                                                                Icons.check),
                                                            const SizedBox(
                                                                width: 5),
                                                            Text('Success',
                                                                style: GoogleFonts.montserrat(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))
                                                          ],
                                                        ),
                                                        content: Text(
                                                            'Resource edited successfully! Press Find again to see changes!',
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)),
                                                        alignment:
                                                            Alignment.center,
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'OK'))
                                                        ]));
                                          }
                                        },
                                        horizontalMargin: 40,
                                        verticalMargin: 10,
                                        borderRadius: BorderRadius.circular(10),
                                        child: const Text(
                                          'Send',
                                          style: TextStyle(color: Colors.white),
                                        ))
                                  ],
                                ),
                              ));
                    },
                    icon: const Icon(Icons.edit))
              ],
            ),
            const Divider(
                color: Colors.black, thickness: 0.2, indent: 0, endIndent: 0),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Vulnerability type:",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                Text(vulnType,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.black))
              ],
            ),
            const Divider(
                color: Colors.black, thickness: 0.2, indent: 0, endIndent: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Resource type:",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                Text(type,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.black))
              ],
            ),
            const Divider(
                color: Colors.black, thickness: 0.2, indent: 0, endIndent: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Value:",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(width: 200),
                Flexible(
                    child: Text(value,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.black)))
              ],
            ),
            const Divider(
                color: Colors.black, thickness: 0.2, indent: 0, endIndent: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Created date:",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                Text(createdDate,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.black)),
              ],
            ),
            const Divider(
                color: Colors.black, thickness: 0.2, indent: 0, endIndent: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Edited date:",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                Text(editedDate,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.black))
              ],
            )
          ],
        ));
  }

  Container editDataFile(
      {required String fileName,
      required String description,
      required String base64value,
      required String createdDate,
      required String editedDate,
      required BuildContext context}) {
    return Container(
        width: 1000,
        height: 300,
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("RESOURCE INFORMATION",
                    style: GoogleFonts.montserrat(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                                title: Row(
                                  children: [
                                    const Icon(Icons.warning),
                                    const SizedBox(width: 5),
                                    Text('Warning',
                                        style: GoogleFonts.montserrat(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                content: Text(
                                    'Are you sure you want to delete this resource?',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal)),
                                alignment: Alignment.center,
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        String resp = await postResourcesFile(
                                            fileName: fileName,
                                            description: description,
                                            base64value: base64value,
                                            action: "remove");
                                        if (resp ==
                                                'Failed to Post Resources' ||
                                            resp.contains(
                                                'Error post resources')) {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                      title: Row(
                                                        children: [
                                                          const Icon(
                                                              Icons.error),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text('Error',
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))
                                                        ],
                                                      ),
                                                      content: Text(
                                                          'Failed to delete resource!',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal)),
                                                      alignment:
                                                          Alignment.center,
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'OK'))
                                                      ]));
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                      title: Row(
                                                        children: [
                                                          const Icon(
                                                              Icons.check),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text('Success',
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))
                                                        ],
                                                      ),
                                                      content: Text(
                                                          'Resource deleted successfully! Press Find again to see changes!',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal)),
                                                      alignment:
                                                          Alignment.center,
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'OK'))
                                                      ]));
                                        }
                                      },
                                      child: const Text('OK'))
                                ]));
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            const Divider(
                color: Colors.black, thickness: 0.2, indent: 0, endIndent: 0),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("File name:",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                Text(fileName,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.black))
              ],
            ),
            const Divider(
                color: Colors.black, thickness: 0.2, indent: 0, endIndent: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Description:",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                Text(description,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.black))
              ],
            ),
            const Divider(
                color: Colors.black, thickness: 0.2, indent: 0, endIndent: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Base64 value:",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(width: 100),
                Container(
                  width: 750,
                  height: 50,
                  alignment: Alignment.centerRight,
                  child: SingleChildScrollView(
                      child: Text(base64value,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.black))),
                )
              ],
            ),
            const Divider(
                color: Colors.black, thickness: 0.2, indent: 0, endIndent: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Created date:",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                Text(createdDate,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.black)),
              ],
            ),
            const Divider(
                color: Colors.black, thickness: 0.2, indent: 0, endIndent: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Edited date:",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                Text(editedDate,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.black))
              ],
            )
          ],
        ));
  }
}

Container getBoxInput(
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

Container postBoxInput(
    {required TextEditingController controller, required String content}) {
  return Container(
    width: 350,
    height: 50,
    margin: const EdgeInsetsDirectional.symmetric(horizontal: 40, vertical: 20),
    child: inputUser(
      controller: controller,
      hintName: content,
      underIcon: const Icon(Icons.text_fields),
    ),
  );
}
