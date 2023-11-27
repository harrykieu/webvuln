import 'package:flutter/material.dart';
import 'package:webvuln/items/newSubmitButton.dart';
import 'package:webvuln/service/api.dart';
import 'package:google_fonts/google_fonts.dart';
import '../items/submitButton.dart';
import '../items/input.dart';
import 'package:data_table_2/data_table_2.dart';

// TODO: Dropdown change screen
class resourceScreen extends StatefulWidget {
  const resourceScreen({super.key});

  @override
  State<resourceScreen> createState() => _resourceScreenState();
}

class _resourceScreenState extends State<resourceScreen> {
  late String state = '/fileResource';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _vulnTypeController = TextEditingController();
    final TextEditingController _typeController = TextEditingController();
    final TextEditingController _valueController = TextEditingController();
    final TextEditingController _actionController = TextEditingController();
    final TextEditingController _vulnTypeSearchController =
        TextEditingController();
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width *
        (1 - 0.13); // 0.13 is width of sidebar
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // dropdown
          SizedBox(
            width: 200,
            height: 50,
            child: DropdownButtonFormField<String>(
                focusColor: Colors.white,
                icon: const Icon(Icons.arrow_drop_down),
                dropdownColor: Colors.white,
                value: state,
                items: const [
                  DropdownMenuItem(
                      value: '/fileResource', child: Text('File Resource')),
                  DropdownMenuItem(
                      value: '/normalResource', child: Text('Normal Resource'))
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
                  print(state);
                }),
          ),
          //table
          Container(
            width: screenWidth,
            height: screenHeight / 2,
            margin:
                const EdgeInsetsDirectional.only(start: 40, end: 40, top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black38),
              color: Colors.white12,
            ),
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
                    Width: screenWidth/5,
                      controller: _vulnTypeController,
                      content: "Vulnerability Type"),
                  boxInput(
                    Width: screenWidth/5,
                    controller: _typeController, content: "Type"),
                  GradientButton(
                      horizontalMargin: 50,
                      onPressed: () {
                        print("Pressed");
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
                  child: DataTable2(columnSpacing: 10, columns: const [
                    DataColumn2(
                        label: Text('Vulnerability'), size: ColumnSize.S),
                    DataColumn2(
                        label: Text('Resource Type'), size: ColumnSize.S),
                    DataColumn2(label: Text('Value'), size: ColumnSize.L),
                    DataColumn2(
                        label: Text('Created Date'), size: ColumnSize.S),
                    DataColumn2(label: Text('Edited Date'), size: ColumnSize.S),
                  ], rows: const [
                    // test
                    DataRow(cells: [
                      DataCell(Text('SQL Injection')),
                      DataCell(Text('File Resource')),
                      DataCell(Text('"../../../../../etc/passwd"')),
                      DataCell(Text('2021-10-10')),
                      DataCell(Text('2021-10-10'))
                    ]),
                    DataRow(cells: [
                      DataCell(Text('SQL Injection')),
                      DataCell(Text('File Resource')),
                      DataCell(Text('"../../../../../etc/passwd"')),
                      DataCell(Text('2021-10-10')),
                      DataCell(Text('2021-10-10'))
                    ]),
                    DataRow(cells: [
                      DataCell(Text('SQL Injection')),
                      DataCell(Text('File Resource')),
                      DataCell(Text('"../../../../../etc/passwd"')),
                      DataCell(Text('2021-10-10')),
                      DataCell(Text('2021-10-10'))
                    ]),
                    DataRow(cells: [
                      DataCell(Text('SQL Injection')),
                      DataCell(Text('File Resource')),
                      DataCell(Text('"../../../../../etc/passwd"')),
                      DataCell(Text('2021-10-10')),
                      DataCell(Text('2021-10-10'))
                    ]),
                    DataRow(cells: [
                      DataCell(Text('SQL Injection')),
                      DataCell(Text('File Resource')),
                      DataCell(Text('"../../../../../etc/passwd"')),
                      DataCell(Text('2021-10-10')),
                      DataCell(Text('2021-10-10'))
                    ]),
                    DataRow(cells: [
                      DataCell(Text('SQL Injection')),
                      DataCell(Text('File Resource')),
                      DataCell(Text('"../../../../../etc/passwd"')),
                      DataCell(Text('2021-10-10')),
                      DataCell(Text('2021-10-10'))
                    ]),
                    DataRow(cells: [
                      DataCell(Text('SQL Injection')),
                      DataCell(Text('File Resource')),
                      DataCell(Text('"../../../../../etc/passwd"')),
                      DataCell(Text('2021-10-10')),
                      DataCell(Text('2021-10-10'))
                    ]),
                    DataRow(cells: [
                      DataCell(Text('SQL Injection')),
                      DataCell(Text('File Resource')),
                      DataCell(Text('"../../../../../etc/passwd"')),
                      DataCell(Text('2021-10-10')),
                      DataCell(Text('2021-10-10'))
                    ]),
                  ])),
            ]),
          ),

          // search box
          Container(
            width: screenWidth,
            height: screenHeight / 2 - 100 - 50,
            margin: const EdgeInsetsDirectional.symmetric(
                horizontal: 40, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black38),
              color: Colors.white12,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsetsDirectional.only(start: 40),
                          child: Text("Vulnerability type:",
                              style: GoogleFonts.montserrat(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        boxInput1(
                            controller: _actionController,
                            content: "Type here...")
                      ]),
                  const Divider(
                      color: Colors.black,
                      thickness: 0.2,
                      indent: 40,
                      endIndent: 40),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsetsDirectional.only(start: 40),
                          child: Text("Resource type:",
                              style: GoogleFonts.montserrat(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        boxInput1(
                            controller: _actionController,
                            content: "Type here...")
                      ]),
                  const Divider(
                      color: Colors.black,
                      thickness: 0.2,
                      indent: 40,
                      endIndent: 40),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsetsDirectional.only(start: 40),
                          child: Text("Value:",
                              style: GoogleFonts.montserrat(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        boxInput1(
                            controller: _actionController,
                            content: "Type here...")
                      ]),
                  GradientButton(
                      onPressed: () {
                        print("Send");
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
          ),
        ],
      ),
    );
  }

  Container boxInput(
      {required TextEditingController controller, required String content,required double Width}) {
    return Container(
      width: Width,
      height: 50,
      margin:
          const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 20),
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
      margin:
          const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 20),
      child: inputUser(
        controller: controller,
        hintName: content,
        underIcon: const Icon(Icons.text_fields),
      ),
    );
  }
}
