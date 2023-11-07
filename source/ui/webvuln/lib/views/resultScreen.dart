import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:webvuln/items/infoTableXSSError.dart';
import 'package:webvuln/main.dart';
import 'package:webvuln/items/drawer.dart';
import 'package:get/get.dart';
// import 'package:webvuln/items/categoryButton.dart';
import '../items/pieGraph.dart';

class resultScreen extends StatefulWidget {
  const resultScreen({super.key});

  @override
  State<resultScreen> createState() => _resultScreenState();
}

class _resultScreenState extends State<resultScreen> {
  late Widget table;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    table = tableSQLerror();
  }
  @override
  Widget build(BuildContext context) {
    bool _isVisibled = true;
    double screenWidth = MediaQuery.of(context).size.width;
    final TextStyle textStyle = GoogleFonts.montserrat(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black);

    //information for column table details
    List<DataColumn> dataColumns = [
      DataColumn(
          label: Text(
        'Percent',
        style: textStyle,
      )),
      DataColumn(
          label: Text(
        'Error',
        style: textStyle,
      )),
    ];

    //information for row table details
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
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.question_mark_rounded))
          ],
          leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsetsDirectional.symmetric(horizontal: 60),
            child: Column(children: [
              //main component for screen result
              /*component table error */
              ListTile(
                title: Text(
                  'List Vulnerabilities',
                  style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
              Container(
                width: double.infinity,
                height: 100,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 200,
                      height: 50,
                      // padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      child: ElevatedButton(onPressed: (){
                        setState(() {
                          table = tableXSSError();
                        });
                      }, child: Text('XSS error',style:GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black)),
                      style:ButtonStyle(
                        backgroundColor: MaterialStateProperty<>.all(
                          LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blue, Colors.green],
                          ) as Linear,
                          )
                      ), )
                    ),
                    Container(
                      width: 200,
                      height: 50,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      child: ElevatedButton(onPressed: (){
                        setState(() {
                          table = tableSQLerror();
                        });
                      }, child: Text('SQL injection',style:GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black)), )
                    ),
                  ],
                ) ,
              ),
              table,
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

              //part for piechart and details
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
              // infoTableXSSError()
            ]),
          ),
        ));
  }
}

class tableXSSError extends StatefulWidget {
  const tableXSSError({super.key});

  @override
  State<tableXSSError> createState() => _tableXSSErrorState();
}

class _tableXSSErrorState extends State<tableXSSError> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    List<DataColumn> dataColumns = [
      DataColumn(label: Text("Serverity",style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold))),
      DataColumn(label: Text("Type",style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold))),
      DataColumn(label: Text('Vulnerabilities',style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold)))
    ];
    final List<Map<String, dynamic>> data = [
        {'Serverity': Icons.warning_rounded, 'Type': 'XSS error', 'Vulnerabilities': 'google.com'},
        {'Serverity':Icons.warning_rounded, 'Type': 'XSS error', 'Vulnerabilities': 'google.com'},
        {'Serverity': Icons.warning_rounded, 'Type': 'XSS error', 'Vulnerabilities': 'google.com'},
        {'Serverity': Icons.warning_rounded, 'Type': 'XSS error', 'Vulnerabilities': 'google.com'},
        {'Serverity': Icons.warning_rounded, 'Type': 'XSS error', 'Vulnerabilities': 'google.com'},
      ];
    return Container(
      width: screenWidth - 500,
      height: 500,
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 2,
            offset: Offset(0, 4)
          )
        ]
      ),
      child: DataTable(columns: dataColumns, rows:data.map((item) =>
        DataRow(cells: [
          DataCell(Icon(item['Serverity'])),
          DataCell(Text(item['Type'])),
          DataCell(Text(item['Vulnerabilities']))
        ]) ).toList() ),
    );
  }
}

class tableSQLerror extends StatefulWidget {
  const tableSQLerror({super.key});

  @override
  State<tableSQLerror> createState() => _tableSQLerrorState();
}

class _tableSQLerrorState extends State<tableSQLerror> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final List<DataColumn> dataColumns =[
      DataColumn(label: Text('Serverity',style: GoogleFonts.montserrat(fontSize: 24,fontWeight: FontWeight.bold))),
      DataColumn(label: Text('Type',style: GoogleFonts.montserrat(fontSize: 24,fontWeight: FontWeight.bold))),
      DataColumn(label: Text('Vulnerabilities',style: GoogleFonts.montserrat(fontSize: 24,fontWeight: FontWeight.bold)))
    ];
    final List<Map<String,dynamic>> dataRows =[
      {'Serverity':Icons.warning_rounded,'Type':'SQL Injection','Vulnerabilities':'wikipedia.com'},
      {'Serverity':Icons.warning_rounded,'Type':'SQL Injection','Vulnerabilities':'wikipedia.com'},
      {'Serverity':Icons.warning_rounded,'Type':'SQL Injection','Vulnerabilities':'wikipedia.com'},
      {'Serverity':Icons.warning_rounded,'Type':'SQL Injection','Vulnerabilities':'wikipedia.com'},
      {'Serverity':Icons.warning_rounded,'Type':'SQL Injection','Vulnerabilities':'wikipedia.com'}
    ];
    return Container(
      width: screenWidth - 500,
      height: 500,
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(color: Colors.black45,offset: Offset(0, 4),blurRadius: 2)
        ]
      ),
      child: DataTable(columns:dataColumns,rows: dataRows.map((item) => DataRow(cells: [
        DataCell(Icon(item['Serverity'])),
        DataCell(Text(item['Type'])),
        DataCell(Text(item['Vulnerabilities']))
      ]) ).toList(),),
    );
  }
}
