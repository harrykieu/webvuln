// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webvuln/service/api.dart';
import 'package:webvuln/items/drawer.dart';
import 'package:webvuln/views/resourcesScreen.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:webvuln/views/resultScreen.dart';
import 'package:webvuln/items/progressBar.dart';
import '../items/submitButton.dart';
import '../items/input.dart';
// import 'package:webvuln/items/categoryButton.dart';
import 'package:easy_loader/easy_loader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class scanScreen extends StatefulWidget {
  const scanScreen({super.key});

  @override
  State<scanScreen> createState() => _scanScreenState();
}

class _scanScreenState extends State<scanScreen> {
  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  final TextEditingController urlController = TextEditingController();
  final _moduleController = TextEditingController();
  // final _historyURLController = TextEditingController();
  // final _dateScanController = TextEditingController();
  final _checkboxController = GroupController();
  Widget contentChild = Text(
    'Scan',
    style: GoogleFonts.montserrat(
        color: Colors.white, fontWeight: FontWeight.normal),
  );
  String buttonContent = 'Scan';
  bool isLoading = false;
  String notice = "";
  String contentContainer = "";
  List<String> content = [
    "Module scan 1:\n Description 1",
    "Module scan 2:\n Description 2",
    "Module scan 3:\n Description 3",
    "Module scan 4:\n Description 4"
  ];
  int _numberModule = 0;
  String _value = "";
  List<String> value = [
    "Module scan 1",
    "Module scan 2",
    "Module scan 3",
    "Module scan 4"
  ];
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFDCE8F6),
        body: Column(
          children: [
            // send scan URL and number module to backend
            Container(
              margin:
                  const EdgeInsets.only(top: 200, left: 80, right: 80, bottom: 10),
              child: Text(
                'Scan URL',
                style: GoogleFonts.montserrat(
                    fontSize: 70, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: 800,
              height: 1,
              color: Colors.black,
              margin: const EdgeInsetsDirectional.only(bottom: 40),
            ),
            Container(
              margin: const EdgeInsetsDirectional.symmetric(horizontal: 100),
              // height: 100,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(0, 2),
                  blurRadius: 10,
                )
              ]),
              child: inputUser(
                controller: urlController,
                hintName: 'URL',
              ),
            ),

            // tu day den dong 150
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 100, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(0, 2),
                        blurRadius: 5,
                      )
                    ]),
                child: SimpleGroupedCheckbox(
                  controller: _checkboxController,
                  itemsTitle: const [
                    'Module scan 1',
                    'Module scan 2',
                    'Module scan 3',
                    'Module scan 4'
                  ],
                  values: const [1, 2, 3, 4],
                  onItemSelected: (values) {
                    _moduleController.text = values.toString();
                    setState(() {
                      contentContainer = content[values - 1];
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 100, vertical: 10),
              child: Container(
                width: double.infinity,
                height: 100,
                // margin: EdgeInsetsDirectional.symmetric(horizontal: ),
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(0, 2),
                        blurRadius: 5,
                      )
                    ]),
                child: Text(
                  contentContainer,
                  style: GoogleFonts.montserrat(
                      fontSize: 20, fontWeight: FontWeight.normal),
                ),
              ),
            ),
            submitButton(
              // urlController: urlController,
              // moduleController: _moduleController,
              onPressed: () {
                postURL(
                    nameURL: urlController.text,
                    moduleNumber: int.parse(_moduleController.text));
                // Get.to(resultScreen());
                setState(() {
                  contentChild = const CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  );
                });
                
              },
              childButton: contentChild,
            ),
          ],
        ));
  }
}
// viet them ham nhan data tu backend de setState cho widget trong contentChild

// viết hàm truyền giá trị của 1 biến từ màn scanScreen sang màn main để màn main nhận định được _selectedIndex của nó chuyển thành 1 

