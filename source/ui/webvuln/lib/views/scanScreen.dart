// ignore_for_file: file_names, camel_case_types

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webvuln/items/newSubmitButton.dart';
import 'package:webvuln/service/api.dart';
import 'package:webvuln/views/loadingScreen.dart';
import 'package:webvuln/views/variable.dart';
import '../items/input.dart';

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
      // _isVisibled = true;
    });
    super.initState();
  }

  final TextEditingController urlController = TextEditingController();
  Widget contentChild = Text(
    'Scan',
    style: GoogleFonts.montserrat(
        color: Colors.white, fontWeight: FontWeight.normal),
  );
  bool _isVisibled = false;
  int _numberModule = 0;
  String dataReceive = '';

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width - 200;
    return Column(
      children: [
        const SizedBox(
          height: 100,
        ),

        //Textbox SCAN URL
        Container(
            margin: const EdgeInsets.only(left: 200, right: 200),
            width: double.infinity,
            height: 200,
            decoration: const BoxDecoration(color: Colors.transparent),
            child: ListTile(
              title: Text(
                'SCAN URL',
                style: GoogleFonts.montserrat(
                    fontSize: 100,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            )),

        // TextField Input url
        Container(
            margin: const EdgeInsets.only(left: 200, right: 200),
            width: double.infinity,
            height: 100,
            decoration: const BoxDecoration(color: Colors.transparent),
            child:
                // Constants.buildInputUser(
                //   controller: urlController,
                //    hintName: 'Paste URL here',
                //    underIcon:const Padding(padding: EdgeInsets.all(10),child: Image(image: AssetImage('lib/assets/suffixIcon.png')),),
                // )
                inputUser(
              controller: urlController,
              hintName: 'Paste URL here',
              underIcon: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Image(image: AssetImage('lib/assets/suffixIcon.png'))),
            )),

        //Box Module scan
        Container(
            margin: const EdgeInsets.only(left: 50, right: 50),
            width: double.infinity,
            height: screenHeight - 600,
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38,
                      blurRadius: 10,
                      offset: Offset(5, 5))
                ],
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: boxModule(screenWidth, screenHeight)),
        const SizedBox(
          height: 30,
        ),

        //Button Scan URL
        GradientButton(
          onPressed: () {
            // String result = postURL(nameURL: urlController.text, moduleNumber: Constants.valueSelected) as String;
            Get.to(const loadingScreen());
            if (postURL(
                            nameURL: urlController.text,
                            moduleNumber: Constants.valueSelected)
                        .toString() ==
                    "Failed post data" ||
                postURL(
                            nameURL: urlController.text,
                            moduleNumber: Constants.valueSelected)
                        .toString() ==
                    "Error") {
              setState(() {
                Constants.contentChild =
                    const CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                );
              });
            } else {
              Get.to(const loadingScreen());
            }
          }, child: Text('Scan',style:GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white) ,))
      ],
    );
  }

  Row boxModule(double screenWidth, double screenHeight) {
    return Row(
      children: [
        // group checkbox module button
        Container(
            width: screenWidth / 8,
            height: double.infinity,
            margin: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  Constants.nameModule.length,
                  (index) {
                    return Row(
                      children: [
                        Checkbox(
                          activeColor: const Color.fromARGB(255, 11, 58, 96),
                          value: Constants.valueCheckbox[index],
                          onChanged: (value) {
                            setState(() {
                              Constants.valueCheckbox[index] = value!;
                              _numberModule = index;
                              if (value) {
                                Constants.valueSelected
                                    .add(Constants.nameModule[index]);
                              } else {
                                Constants.valueSelected
                                    .remove(Constants.nameModule[index]);
                              }
                              if (Constants.valueSelected.length == 0) {
                                _isVisibled = false;
                              }else{
                                _isVisibled = true;
                              }
                              print(_numberModule);
                              print(Constants.valueSelected);
                            });
                          },
                        ),
                        Text(Constants.nameModule[index]),
                      ],
                    );
                  },
                ),
              ),
            )),
        // divide line between the button and description
        const VerticalDivider(
          indent: 40,
          endIndent: 40,
          color: Color(0xFF021361),
          thickness: 2,
        ),
        // description
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            width: screenWidth - (screenWidth / 2),
            height: screenHeight / 2.7,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent, width: 1)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.document_scanner_rounded,
                      color: Color(0xFF1A35C3),
                    ),
                    title: Text(
                      'Description',
                      style: GoogleFonts.montserrat(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Visibility(
                    visible: _isVisibled,
                    child: ListTile(
                      title: Text(Constants.content[_numberModule]),
                    ),
                  )
                ],
              ),
            ))
      ],
    );
  }
}
// viet them ham nhan data tu backend de setState cho widget trong contentChild

// viết hàm truyền giá trị của 1 biến từ màn scanScreen sang màn main để màn main nhận định được _selectedIndex của nó chuyển thành 1
