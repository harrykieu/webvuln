import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webvuln/items/lineChart.dart';
import 'package:webvuln/items/pieGraph.dart';
// import 'package:webvuln/items/categoryButton.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:webvuln/views/detail_screen.dart';

class resultScreen extends StatefulWidget {
  const resultScreen({super.key});

  @override
  State<resultScreen> createState() => _resultScreenState();
}

class _resultScreenState extends State<resultScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title: Text('Result'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Table list errors
            const listVulnerabilities(),
            // Graph line and pie chart
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [const containerPieChart(), lineChart()],
            ),
            //Description
            Container(
              width: width - 100,
              height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
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
                  ]),
              child: Column(
                children: [
                  ListTile(
                    title: Row(
                      children: [
                        const Image(
                            image: AssetImage('lib/assets/Folders_light.png')),
                        Text(
                          '  Description',
                          style: GoogleFonts.montserrat(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'SQL injection, also known as SQLI, is a common attack vector that uses malicious SQL code for backend database manipulation to access information that was not intended to be displayed',
                      style: GoogleFonts.montserrat(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class listVulnerabilities extends StatefulWidget {
  const listVulnerabilities({super.key});

  @override
  State<listVulnerabilities> createState() => _listVulnerabilitiesState();
}

class _listVulnerabilitiesState extends State<listVulnerabilities> {
  @override
  void initState() {
    // TODO: implement initState
    _selectedModule = 'XSS';
    super.initState();
  }

  @override
  List<String> error = ['XSS', 'SQLi', 'LFI', 'RCE'];
  List<String> headersTable = ['Severity', 'Type', 'Vulnerabilities'];
  List<String> rowsTableXSS = ['yellow', 'XSS error', 'google.com'];
  List<String> rowsTableSQL = ['SQL injection', 'google.com'];
  List<String> rowsTableLFI = ['LFI error', 'google.com'];
  List<String> rowsTableRCE = ['Remote code execution', 'google.com'];
  String _selectedModule = 'XSS';
  bool _isVisibled = true;

  //important!! number_error is recognized as the number of error get api from backend
  int number_error = 0;
  TextStyle text_style_title = GoogleFonts.montserrat(
      fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold);
  TextStyle text_style_bold = GoogleFonts.montserrat(
      fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold);
  TextStyle text_style_normal = GoogleFonts.montserrat(
      fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal);

  // Column table = tableXSS();

  Widget build(BuildContext context) {
    int switch_widget_table = 0;
    List<Widget> list_vulnerabilities = [
      table_error_details(),
      Text(
        '404 Not found!!',
        style: text_style_bold,
      )
    ];
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width - 100,
      height: 500,
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(0, 4),
              blurRadius: 5,
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          ListTile(
            title: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Image(image: AssetImage('lib/assets/list.png')),
                Text(
                  '   List vulnerabilities',
                  style: text_style_title,
                ),
                Visibility(
                  visible: _isVisibled,
                  child: Container(
                    width: 100,
                    height: 50,
                    margin: EdgeInsetsDirectional.only(start: width - 800),
                    child: DropDown(
                      items: error,
                      initialValue: _selectedModule,
                      dropDownType: DropDownType.Button,
                      onChanged: (val) {
                        setState(() {
                          _selectedModule = val as String;
                        });
                        print(_selectedModule);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          table_error_details()
        ],
      ),
    );
  }

  Stack table_error_details() {
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
              child: DataTable(columns: [
                DataColumn(
                    label: Text(
                  'Serverity',
                  style: text_style_bold,
                )),
                DataColumn(
                    label: Text(
                  'Type',
                  style: text_style_bold,
                )),
                DataColumn(
                    label: Text(
                  'Description',
                  style: text_style_bold,
                ))
              ], rows: [
                DataRow(cells: [
                  DataCell(Text(
                    'Critical',
                    style: text_style_normal,
                  )),
                  DataCell(Text(
                    'XSS',
                    style: text_style_normal,
                  )),
                  DataCell(Text(
                    '"https://www.google.com.vn/intl/vi/about.html"',
                    style: text_style_normal,
                  ))
                ])
              ]),
            )),
        Positioned(
            top: 355,
            right: 40,
            child: ElevatedButton(
              onPressed: () {
                Get.to(detail_screen());
              },
              child: const Text('Details...'),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 50),
                  maximumSize: const Size(150, 50),
                  backgroundColor: Colors.white),
            ))
      ],
    );
  }
}
