// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webvuln/items/module_checkbox.dart';
import 'package:webvuln/main.dart';
import 'package:webvuln/service/api.dart';
import 'package:webvuln/views/loadingScreen.dart';
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
      // _isVisibled = true;
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
  List<String> content = [
    // "",
    "Module scan 1:\n SQL injection is a type of cyberattack that targets the application's database layer.",
    "Module scan 2:\n Cross-Site Scripting (XSS) is a type of security vulnerability commonly found in web applications.",
    "Module scan 3:\n LFI stands for Local File Inclusion, which is a type of security vulnerability that occurs when an application includes files on a server without properly validating user input",
    "Module scan 4:\n Description 4",
    "Module scan 5:\n dagsjdadgkasgd ",
    "Module scan 6:\n dagsjdadgkasgd ",
    "Module scan 7:\n dagsjdadgkasgd ",
    "Module scan 8:\n dagsjdadgkasgd ",
    "Module scan 9:\n dagsjdadgkasgd "
  ];
  List<bool> _valueCheckbox = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<String> _valueSelected = [];
  int _numberModule = 0;
  List<String> nameModule = [
   "ffuf",
    "dirsearch",
    "lfi",
    "sqli",
    "xss",
    "fileupload",
    "idor",
    "pathtraversal",
  ];

  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
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
                    child: Column(
                      children: List.generate(
                        nameModule.length,
                        (index) {
                          return Row(
                            children: [
                              Checkbox(
                                value: _valueCheckbox[index],
                                onChanged: (value) {
                                  setState(() {
                                    _valueCheckbox[index] = value!;
                                    _numberModule = index;
                                    if (value) {
                                      _valueSelected.add(nameModule[index]);
                                    } else {
                                      _valueSelected.remove(nameModule[index]);
                                    }
                                    print(_valueSelected);
                                  });
                                },
                              ),
                              Text(nameModule[index]),
                            ],
                          );
                        },
                      ),
                    )),
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
            )),
        submitButton(
          // urlController: urlController,
          // moduleController: _moduleController,
          onPressed: () {
            postURL(
                nameURL: urlController.text,
                moduleNumber: _valueSelected);
            Get.to(loadingScreen());
            setState(() {
              contentChild = const CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              );
            });
            // Navigator.push(context,
            //   MaterialPageRoute(builder: (BuildContext context) => mainScreen(changeScreen: 1,)));
          },
          childButton: contentChild,
        ),
      ],
    );
  }

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

