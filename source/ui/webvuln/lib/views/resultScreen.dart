import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:webvuln/items/infoTableError.dart';
import 'package:webvuln/main.dart';
import 'package:webvuln/items/drawer.dart';
import 'package:get/get.dart';
import 'package:webvuln/items/categoryButton.dart';
import '../items/pieGraph.dart';

class resultScreen extends StatefulWidget {
  const resultScreen({super.key});

  @override
  State<resultScreen> createState() => _resultScreenState();
}

class _resultScreenState extends State<resultScreen> {
  @override
  
  Widget build(BuildContext context) {
    bool _isVisibled = true;
    double screenWidth = MediaQuery.of(context).size.width;
    final TextStyle textStyle = GoogleFonts.montserrat(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.black);
      List<DataColumn> dataColumns = [
        DataColumn(
            label: Text(
          'Percent',
          style: textStyle,
        )),
        DataColumn(label: Text('Error',style: textStyle,)),
      ];
      List<DataRow> dataRows = [
        DataRow(cells: [DataCell(Text("20%")), DataCell(Text("SQl Injection"))]),
        DataRow(cells: [
          DataCell(Text('50%')),
          DataCell(Text('XSS error')),
        ]),
        DataRow(cells: [
          DataCell(Text('30%')),
          DataCell(Text('LFI error')),
        ]),
        DataRow(cells: [DataCell(Text('30%')), DataCell(Text('RCE error'))])
      ];

    Get.testMode = true;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Back",
            style: textStyle,
            textAlign: TextAlign.center,
          ),
          leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsetsDirectional.symmetric(horizontal: 60),
            child: Column(children: [
              ListTile(
                title: Text(
                  'List Vulnerabilities',
                  style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
              categoryButton(),
              SizedBox(
                height: 10,
              ),
              ListTile(
                title: Text('Graphs',
                    style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
              ),
              Row(
                children: [
                  pieGraph(),
                  Visibility(
                    visible: screenWidth > 1200,
                    child: Container(
                        width: 400,
                        height: 300,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xFFD9D9D9),
                        ),
                        child: DataTable(columns: dataColumns, rows: dataRows)),
                  )
                ],
              )
              // infoTableError()
            ]),
          ),
        ));
  }
}
