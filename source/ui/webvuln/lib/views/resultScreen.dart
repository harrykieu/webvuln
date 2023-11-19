import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webvuln/items/lineChart.dart';
import 'package:webvuln/items/pieGraph.dart';
import 'package:webvuln/service/api.dart';
import 'package:webvuln/views/resourcesScreen.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:webvuln/views/resultScreen.dart';
import '../items/submitButton.dart';
import '../items/input.dart';
// import 'package:webvuln/items/categoryButton.dart';
import 'package:easy_loader/easy_loader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
import 'package:decorated_dropdownbutton/decorated_dropdownbutton.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';

class resultScreen extends StatefulWidget {
  const resultScreen({super.key});

  @override
  State<resultScreen> createState() => _resultScreenState();
}

class _resultScreenState extends State<resultScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), bottomLeft: Radius.circular(30))),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      // maximumSize: Size(200, 80),
                      minimumSize: const Size(100, 80)),
                  child: const Row(
                    children: [Icon(Icons.arrow_back), Text('Back')],
                  )),
            ),
            const listVulnerabilities(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const containerPieChart(),
                lineChart()
              ],
            ),
            Container(
              width:width - 100,
              height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 30),
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
                ]
              ),
              child:Column(
                children: [
                  ListTile(
                    title: Row(
                      children: [
                        Image(image: AssetImage('lib/assets/Folders_light.png')),
                        Text('  Description',style: GoogleFonts.montserrat(fontSize: 24,fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text('SQL injection, also known as SQLI, is a common attack vector that uses malicious SQL code for backend database manipulation to access information that was not intended to be displayed',style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.normal),),
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

  // Column table = tableXSS();

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Column table = tableXSS();
    return Container(
      width: width - 100,
      height: 500,
      margin: const EdgeInsets.symmetric(vertical: 30,horizontal: 10),
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
                const Text('   List vulnerabilities'),
                Container(
                  width: 100,
                  height: 50,
                  margin: EdgeInsetsDirectional.only(start: width - 650),
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
                )
              ],
            ),
          ),
          Stack(
            children: [
              Container(
              width: double.infinity,
              height: 400,
              margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              padding:
                  EdgeInsetsDirectional.symmetric(horizontal: 60, vertical: 20),
              decoration: BoxDecoration(
                  color: Color(0xFFDEEDFF),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: SingleChildScrollView(
                child: tableXSS(),
              )),
          Positioned(
            top: 355,
            right: 40,
            child: ElevatedButton(onPressed: (){}, child: Text('Details...'),style: ElevatedButton.styleFrom(
              minimumSize: Size(150, 50),
              maximumSize: Size(150, 50),
              backgroundColor: Colors.white
            ),))
            ],
          )
        ],
      ),
    );
  }


  Column tableXSS() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              headersTable[0],
              style: GoogleFonts.montserrat(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              headersTable[1],
              style: GoogleFonts.montserrat(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              headersTable[2],
              style: GoogleFonts.montserrat(
                  fontSize: 24, fontWeight: FontWeight.bold),
            )
          ],
        ),
        rowTable(nameError: rowsTableXSS[1], vuln: rowsTableXSS[2]),
        rowTable(nameError: rowsTableXSS[1], vuln: rowsTableXSS[2]),
        rowTable(nameError: rowsTableXSS[1], vuln: rowsTableXSS[2]),
        rowTable(nameError: rowsTableXSS[1], vuln: rowsTableXSS[2]),
        rowTable(nameError: rowsTableXSS[1], vuln: rowsTableXSS[2])
      ],
    );
  }

  Column tableSQL() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              headersTable[0],
              style: GoogleFonts.montserrat(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              headersTable[1],
              style: GoogleFonts.montserrat(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              headersTable[2],
              style: GoogleFonts.montserrat(
                  fontSize: 24, fontWeight: FontWeight.bold),
            )
          ],
        ),
        rowTable(nameError: rowsTableSQL[0], vuln: rowsTableSQL[1]),
        rowTable(nameError: rowsTableSQL[0], vuln: rowsTableSQL[1]),
        rowTable(nameError: rowsTableSQL[0], vuln: rowsTableSQL[1]),
        rowTable(nameError: rowsTableSQL[0], vuln: rowsTableSQL[1])
      ],
    );
  }

  Row rowTable({required String nameError, required String vuln}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(
          Icons.warning_amber_rounded,
          size: 50,
          color: Colors.red,
        ),
        Text(
          nameError,
          style: GoogleFonts.montserrat(
              fontSize: 20, fontWeight: FontWeight.normal),
        ),
        Text(
          vuln,
          style: GoogleFonts.montserrat(
              fontSize: 20, fontWeight: FontWeight.normal),
        )
      ],
    );
  }
}
