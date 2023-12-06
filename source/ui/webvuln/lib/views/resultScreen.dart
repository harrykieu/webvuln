// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webvuln/items/custom_dropdown.dart';
import 'package:webvuln/items/lineChart.dart';
import 'package:webvuln/items/newSubmitButton.dart';
import 'package:webvuln/items/pieGraph.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:webvuln/items/tables.dart';

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
    List<Widget> table_errors = [
      TableXSS(),TableSQli()
    ];
    bool isVisibled = true;
    List<String> error = ['All', 'XSS', 'SQLi', 'LFI', 'RCE'];
    String _selectedModule = 'All';
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
              CustomDropdownButton(
                  selectedItem: _selectedModule,
                  items: error,
                  onItemSelected: (item) {
                    if (item == 'All') {
                      setState(() {
                        isVisibled = true;
                        _selectedModule = item;
                      });
                    } else {
                      setState(() {
                        isVisibled = false;
                        _selectedModule = item;
                      });
                    }
                  }),
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
                      ),
                      table_errors[0]
                    ],
                  )),
              // Graph line and pie chart
              Visibility(
                visible: isVisibled,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [containerPieChart(), lineChart()],
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

  Container container(double screenWidth, {required Widget child}) {
    return Container(
        width: screenWidth - (0.13 * screenWidth),
        height: 550,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        padding: EdgeInsets.all(20),
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
