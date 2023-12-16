// ignore_for_file: unused_element

import 'dart:convert';
import 'package:data_table_2/data_table_2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:webvuln/items/custom_dropdown.dart';
import 'package:webvuln/items/lineChart.dart';
import 'package:webvuln/items/newSubmitButton.dart';
import 'package:webvuln/items/pdf.dart';
import 'package:webvuln/items/pieGraph.dart';
import 'package:webvuln/items/tables.dart';
import 'package:webvuln/model/model.dart';
import 'package:webvuln/views/variable.dart';

// TODO: parse data from loading screen to display on result screen
class resultScreen extends StatefulWidget {
  final List<dynamic> data;
  const resultScreen({super.key, required this.data});

  @override
  State<resultScreen> createState() => _resultScreenState();
  List<dynamic> get resultData => data;
}

class RadioController extends GetxController {
  RxString type_format = ''.obs;
}

class _resultScreenState extends State<resultScreen> {
  final RadioController myController = RadioController();
  final TextEditingController name_file_controller = TextEditingController();
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

  String selectedFolderPath = '';

  Future<void> _pickFolder() async {
    String? directory = (await FilePicker.platform.getDirectoryPath());

    if (directory != null) {
      setState(() {
        selectedFolderPath = directory;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double borderRadiusValue = 20.0; // Adjust the radius as needed
    Get.testMode = true;
    List<Vulnerability> listVuln = [];
    for (var obj in widget.resultData) {
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
      HistoryTableData newVuln = HistoryTableData(
          domain: obj["domain"].toString(),
          numVuln: obj["numVuln"],
          resultPoint: obj["resultPoint"],
          id: obj["id"].toString(),
          resultSeverity: obj["resultSeverity"].toString(),
          vuln: listVuln,
          scanDate: obj["scanDate"].toString());
      results.add(obj);
    }
    List<DataRow> dataRows = results
        .map((e) => DataRow(cells: [
              DataCell(Text(e.domain)),
              DataCell(Text(e.scanDate)),
              DataCell(Text(e.resultSeverity)),
              DataCell(Text(e.resultPoint.toString())),
              DataCell(Text(e.numVuln.toString())),
              DataCell(Text(e.id)),
            ]))
        .toList();
    //String severityPoint = json["resultPoint"].toString();
    List<String> error = ['All', 'XSS', 'SQLi', 'RCE', 'LFI'];
    List<Widget> tables = [
      //TableAll(dataTable: newData),
      const TableXSS(),
      const TableSQli(),
      const TableRCE(),
      const TableLFI()
    ];
    //select module to scan
    String selectedModule = "All";
    bool isHide(newData) {
      if (newData["numVuln"] == 0) {
        return false;
      } else {
        return true;
      }
    }

    void showDownloadSuccessSnackbar(BuildContext context) {
      final snackBar = SnackBar(
        content: Text('Download Successful'),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        title: const Row(
                          children: [
                            Text('Export data format   '),
                          ],
                        ),
                        actions: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Obx(
                                    () => Radio(
                                      value: 'json',
                                      groupValue:
                                          myController.type_format.value,
                                      onChanged: (value) {
                                        setState(() {
                                          myController.type_format.value =
                                              value!;
                                        });
                                      },
                                    ),
                                  ),
                                  Text('JSON'),
                                  Obx(
                                    () => Radio(
                                      value: 'PDF',
                                      groupValue:
                                          myController.type_format.value,
                                      onChanged: (value) {
                                        setState(() {
                                          myController.type_format.value =
                                              value!;
                                        });
                                      },
                                    ),
                                  ),
                                  Text('PDF'),
                                ],
                              ),
                              TextFormField(
                                controller: name_file_controller,
                                decoration: const InputDecoration(
                                    labelText: 'File name',
                                    prefixIcon: Icon(Icons.file_copy_outlined),
                                    border: OutlineInputBorder()),
                              ),
                              Obx(
                                () => Text(
                                  'Selected format: ${myController.type_format.value == "PDF" ? 'file pdf' : 'file xml/json'}',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                              SizedBox(height: 20),
                              Text('Selected Folder: $selectedFolderPath'),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _pickFolder,
                                child: Text('Pick location to download'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue, // Background color
                                  onPrimary: Colors.white, // Text color
                                  padding:
                                      EdgeInsets.all(16.0), // Button padding
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Button border radius
                                  ),
                                  elevation: 4.0, // Button shadow
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              /*  ElevatedButton(
                                onPressed: () {
                                  if (selectedFolderPath.isNotEmpty) {
                                    //createPDF(newData, selectedFolderPath,
                                        name_file_controller.text);
                                    showDownloadSuccessSnackbar(context);
                                  } else {
                                    // Handle the case where no folder is selected
                                    print('Please pick a folder first.');
                                  }
                                },
                                child: Text('Download'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue, // Background color
                                  onPrimary: Colors.white, // Text color
                                  padding:
                                      EdgeInsets.all(16.0), // Button padding
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Button border radius
                                  ),
                                  elevation: 4.0, // Button shadow
                                ),
                              ), */
                            ],
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.download))
        ],
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
                  visible: isHide(json),
                  child: CustomDropdownButton(
                      selectedItem: selectedModule,
                      items: error,
                      onItemSelected: (item) {
                        print(item);
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
                          trailing: Text(
                              'Point Severity:   ', //$severityPoint points',
                              style: GoogleFonts.montserrat(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                        ),
                        DataTable2(columns: const [
                          DataColumn(
                            label: Row(
                              children: [Text('Serverity')],
                            ),
                          ),
                          DataColumn(
                            label: Row(
                              children: [Text('Type')],
                            ),
                          ),
                          DataColumn(
                            label: Row(
                              children: [Text('Description')],
                            ),
                          ),
                          DataColumn(
                            label: Row(
                              children: [
                                Text('Scan Date'),
                              ],
                            ),
                          ),
                        ], rows: dataRows)
                        //tables[number_module]
                      ],
                    )),
                // Graph line and pie chart
                Visibility(
                  visible: true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      //containerPieChart(data: widget.data),
                      lineChart()
                    ],
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
        padding: const EdgeInsets.all(20),
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
