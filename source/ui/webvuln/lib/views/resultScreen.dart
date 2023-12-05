// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webvuln/items/lineChart.dart';
import 'package:webvuln/items/newSubmitButton.dart';
import 'package:webvuln/items/pieGraph.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:webvuln/items/tables.dart';
import 'package:webvuln/views/detail_screen.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class resultScreen extends StatefulWidget {
  const resultScreen({super.key});

  @override
  State<resultScreen> createState() => _resultScreenState();
}

class _resultScreenState extends State<resultScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double borderRadiusValue = 20.0; // Adjust the radius as needed
    Get.testMode = true;
    bool isVisibled = true;
    List<String> error = ['XSS', 'SQLi', 'LFI', 'RCE'];
    String _selectedModule = 'XSS';
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
              DropDown(
                items: error, // Ensure unique values
                initialValue: _selectedModule,
                dropDownType: DropDownType.Button,
                onChanged: (val) {
                  setState(() {
                    _selectedModule = val as String;
                    // if (val == 'XSS') {
                    //   setState(() {});
                    // }
                  });
                  print(_selectedModule);
                },
              ),
              // Table list errors
              const list_vulnerabilities(),
              // Graph line and pie chart
              Visibility(
                visible: isVisibled,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [containerPieChart(), lineChart()],
                ),
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

class list_vulnerabilities extends StatefulWidget {
  const list_vulnerabilities({super.key});

  @override
  State<list_vulnerabilities> createState() => _list_vulnerabilitiesState();
}

class _list_vulnerabilitiesState extends State<list_vulnerabilities> {
  @override
  void initState() {
    // TODO: implement initState
    _selectedModule = 'XSS';
    super.initState();
  }
  String _selectedModule = 'XSS';

  //important!! number_error is recognized as the number of error get api from backend
  int number_error = 1;
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

    //table chinh
    return Container(
      width: width - 100,
      height: 600,
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
              ],
            ),
          ),
          const tableXSS()
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
