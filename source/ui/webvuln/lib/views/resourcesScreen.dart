import 'package:flutter/material.dart';
import 'package:webvuln/items/newSubmitButton.dart';
import 'package:webvuln/service/api.dart';
import 'package:google_fonts/google_fonts.dart';
import '../items/submitButton.dart';
import '../items/input.dart';
import 'package:data_table_2/data_table_2.dart';

class resourceScreen extends StatefulWidget {
  const resourceScreen({super.key});

  @override
  State<resourceScreen> createState() => _resourceScreenState();
}

class _resourceScreenState extends State<resourceScreen> {
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
    String selectedText = '/fileResource';
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            child: DropdownButtonFormField<String>(
                focusColor: Colors.white,
                icon: const Icon(Icons.arrow_drop_down),
                dropdownColor: Colors.white,
                value: selectedText,
                items: const [
                  DropdownMenuItem(
                      value: '/fileResource', child: Text('File Resource')),
                  DropdownMenuItem(
                      value: '/normalResource', child: Text('Normal Resource'))
                ],
                onSaved: (v) {
                  setState(() {
                    selectedText = v!;
                  });
                },
                onChanged: (v) {
                  setState(() {
                    selectedText = v!;
                  });
                  print(selectedText);
                }),
          ),
          //table
          Container(
            width: screenWidth,
            height: screenHeight / 2,
            margin: const EdgeInsetsDirectional.symmetric(
                horizontal: 40, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black38),
              color: Colors.white12,
            ),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  boxInput(
                      controller: _vulnTypeController,
                      content: "Vulnerability Type"),
                  boxInput(controller: _typeController, content: "Type"),
                  GradientButton(
                      horizontalMargin: 40,
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
                  // calculate height of table using other element's height
                  // (need to find efficient way)
                  height: screenHeight / 2 - 50 - 20 - 20 - 10,
                  width: screenWidth,
                  margin: const EdgeInsetsDirectional.symmetric(horizontal: 40),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: Colors.white),
                  child: DataTable2(columnSpacing: 10, columns: const [
                    DataColumn2(
                      label: Text('ID'),
                      size: ColumnSize.S,
                    ),
                    DataColumn(
                      label: Text('Name'),
                    ),
                    DataColumn(
                      label: Text('Code'),
                    ),
                    DataColumn(
                      label: Text('Quantity'),
                    ),
                    DataColumn(
                      label: Text('Amount'),
                    ),
                  ], rows: const [
                    // generate 6 more rows
                    DataRow(cells: [
                      DataCell(Text('1')),
                      DataCell(Text('Arshik')),
                      DataCell(Text('5644645')),
                      DataCell(Text('3')),
                      DataCell(Text('265\$')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('2')),
                      DataCell(Text('Arshik')),
                      DataCell(Text('5644645')),
                      DataCell(Text('3')),
                      DataCell(Text('265\$')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('3')),
                      DataCell(Text('Arshik')),
                      DataCell(Text('5644645')),
                      DataCell(Text('3')),
                      DataCell(Text('265\$')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('4')),
                      DataCell(Text('Arshik')),
                      DataCell(Text('5644645')),
                      DataCell(Text('3')),
                      DataCell(Text('265\$')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('5')),
                      DataCell(Text('Arshik')),
                      DataCell(Text('5644645')),
                      DataCell(Text('3')),
                      DataCell(Text('265\$')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('6')),
                      DataCell(Text('Arshik')),
                      DataCell(Text('5644645')),
                      DataCell(Text('3')),
                      DataCell(Text('265\$')),
                    ])
                  ])),
            ]),
          ),

          // search box
          Container(
            width: screenWidth,
            height: screenHeight / 4,
            margin: const EdgeInsetsDirectional.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black38),
              color: Colors.white12,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  boxInput(
                      controller: _actionController, content: "Enter action"),
                  boxInput(controller: _typeController, content: "Enter type"),
                  boxInput(
                      controller: _valueController, content: "Enter value"),
                  boxInput(
                      controller: _vulnTypeController,
                      content: "Enter vulnerability type"),
                ],
              ),
            ),
          ),
          GradientButton(
            onPressed: () {
              postResources(
                  vulnType: _valueController.text,
                  action: _actionController.text,
                  resType: _typeController.text,
                  value: _valueController.text);
            },
            borderRadius: BorderRadius.circular(10),
            child: const Text(
              'Find',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Container boxInput(
      {required TextEditingController controller, required String content}) {
    return Container(
      width: 300,
      height: 50,
      margin:
          const EdgeInsetsDirectional.symmetric(horizontal: 40, vertical: 20),
      child: inputUser(
        controller: controller,
        hintName: content,
        underIcon: const Icon(Icons.text_fields),
      ),
    );
  }
}
