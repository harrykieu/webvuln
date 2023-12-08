// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:webvuln/items/lineChart.dart';
import 'package:webvuln/items/newSubmitButton.dart';
import 'package:webvuln/items/pieGraph.dart';
import 'package:webvuln/items/tables.dart';

class resultScreen extends StatefulWidget {
  final String data;
  const resultScreen({super.key, required this.data});

  @override
  State<resultScreen> createState() => _resultScreenState();
  String get resultData => data;
}

class _resultScreenState extends State<resultScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double borderRadiusValue = 20.0; // Adjust the radius as needed
    Get.testMode = true;
    String data = widget.data;
    print(data);
    return Scaffold(
      appBar: AppBar(
        leading: GradientButton(
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        toolbarHeight: 80,
        leadingWidth: 100,
        backgroundColor: Colors.transparent,
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadiusValue),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Table list errors
              const listVulnerabilities(),
              // Graph line and pie chart
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [const containerPieChart(), lineChart()],
              ),
              // Description
              Container(
                width: screenWidth - (0.13 * screenWidth),
                height: 200,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
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
      ),
    );
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

  List<String> error = ['XSS', 'SQLi', 'LFI', 'RCE'];
  List<String> headersTable = ['Severity', 'Type', 'Vulnerabilities'];
  List<String> rowsTableXSS = ['yellow', 'XSS error', 'google.com'];
  List<String> rowsTableSQL = ['SQL injection', 'google.com'];
  List<String> rowsTableLFI = ['LFI error', 'google.com'];
  List<String> rowsTableRCE = ['RCE', 'google.com'];
  String _selectedModule = 'XSS';

  //important!! number_error is recognized as the number of error get api from backend
  int number_error = 2;
  // ignore: non_constant_identifier_names
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

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<Widget> listVulnerabilities = [
      tableXSS(),
      Text(
        '404 Not found!!',
        style: text_style_bold,
      ),
      Container(
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
      Container(
        color: Colors.transparent,
      )
    ];
    @override
    Widget checkNumberErrors(numberError) {
      if (numberError == 0) {
        return listVulnerabilities[1];
      } else {
        return listVulnerabilities[0];
      }
    }

    Widget visibleDropdown(numberError) {
      if (numberError == 0) {
        return listVulnerabilities[3];
      } else {
        return listVulnerabilities[2];
      }
    }

    //table chinh
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
                visibleDropdown(number_error)
              ],
            ),
          ),
          checkNumberErrors(number_error)
        ],
      ),
    );
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
          Icons.info_outline,
          color: Colors.black,
          size: 16,
        ));
  }
}
