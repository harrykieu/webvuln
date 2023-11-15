// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webvuln/service/api.dart';
import 'package:webvuln/views/resourcesScreen.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:webvuln/views/resultScreen.dart';
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
    setState(() {
      _numberModule = 0;
      _isVisibled = true;
    });
    super.initState();
  }

  @override
  final TextEditingController urlController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  Widget contentChild = Text(
    'Scan',
    style: GoogleFonts.montserrat(
        color: Colors.white, fontWeight: FontWeight.normal),
  );
  // String buttonContent = 'Scan';
  List<String> content = [
    "Module scan 1:\n SQL injection is a type of cyberattack that targets the application's database layer.",
    "Module scan 2:\n Cross-Site Scripting (XSS) is a type of security vulnerability commonly found in web applications.",
    "Module scan 3:\n LFI stands for Local File Inclusion, which is a type of security vulnerability that occurs when an application includes files on a server without properly validating user input",
    "Module scan 4:\n Description 4"
  ];
  int _numberModule = 0;
  bool _isVisibled = true;


  List<String> value = [
    "Module scan 1",
    "Module scan 2",
    "Module scan 3",
    "Module scan 4",
    "Module scan 5"
  ];
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        // send scan URL and number module to backend
        Container(
            margin: const EdgeInsets.only(top: 100, left: 200),
            child: ListTile(
              title: Text(
                'SCAN URL',
                style: GoogleFonts.montserrat(
                    fontSize: 100,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            )),
        Container(
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 200),
          width: double.infinity,
          // height: 200,
          // padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(0, 2),
              blurRadius: 10,
            ),
          ], borderRadius: BorderRadius.all(Radius.circular(40))),
          child: inputUser(
            controller: urlController,
            hintName: 'Paste URL here',
            underIcon: const Padding(
                padding: EdgeInsets.all(10),
                child: Image(image: AssetImage('lib/assets/suffixIcon.png'))),
          ),
        ),
        Container(
          width: double.infinity,
          height: screenHeight - 600,
          margin:
              EdgeInsetsDirectional.symmetric(horizontal: 200, vertical: 30),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 2), blurRadius: 4)
              ]),
          child: Row(
            children: [
              Container(
                width: screenWidth / 8,
                height: double.infinity,
                margin: EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Scrollbar(
                    controller: _scrollController,
                    child: ListView(
                      // itemExtent: 5,
                      controller: _scrollController,
                      children: [
                        module(),
                        buttonError(
                            name: value[0],
                            onPressed: () {
                              setState(() {
                                _numberModule = 0;
                              });
                            }),
                        buttonError(
                            name: value[1],
                            onPressed: () {
                              setState(() {
                                _numberModule = 1;
                              });
                            }),
                        buttonError(
                            name: value[2],
                            onPressed: () {
                              setState(() {
                                _numberModule = 2;
                              });
                            }),
                        buttonError(
                            name: value[3],
                            onPressed: () {
                              setState(() {
                                _numberModule = 3;
                              });
                            }),
                        // buttonError(name: value[4]),
                      ],
                    )),
              ),
              const VerticalDivider(
                indent: 40,
                endIndent: 40,
                color: Color(0xFF021361),
                thickness: 2,
              ),
              Container(
                width: screenWidth / 3,
                height: double.infinity,
                margin: EdgeInsetsDirectional.all(10),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.document_scanner_rounded,
                        color: Color(0xFF1A35C3),
                      ),
                      title: Text(
                        'Description',
                        style: GoogleFonts.montserrat(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      title: Text(content[_numberModule]),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        submitButton(
          // urlController: urlController,
          // moduleController: _moduleController,
          onPressed: () {
            postURL(
                nameURL: urlController.text, moduleNumber: _numberModule + 1);
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
    );
  }

  Container buttonError(
          {required String name,
          required Function() onPressed}) =>
      Container(
          width: 200,
          height: 50,
          margin: EdgeInsetsDirectional.all(10),
          decoration: BoxDecoration(
              // color: bgButton,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              border: Border.all(color: Colors.black)),
          child: TextButton(
              onPressed: onPressed,
              // style: ,
              child: Text(name,
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Color(0xFF2B425C),
                      fontWeight: FontWeight.w600))));
  Visibility module() => Visibility(
          child: Container(
        width: 200,
        height: 50,
        padding: EdgeInsets.all(10),
        decoration: const BoxDecoration(
            // border:Border.all(color: ),
            gradient: LinearGradient(colors: [
              Color(0xFF6147FF),
              Color(0xFF408BFC),
              Color(0xFFAE73DD)
            ]),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Text(
          'Module scan ',
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ));
}
// viet them ham nhan data tu backend de setState cho widget trong contentChild

// viết hàm truyền giá trị của 1 biến từ màn scanScreen sang màn main để màn main nhận định được _selectedIndex của nó chuyển thành 1 

