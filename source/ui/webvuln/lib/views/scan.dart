// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webvuln/items/gradient_button.dart';
import 'package:webvuln/service/api.dart';
import 'package:webvuln/views/loading.dart';
import 'package:webvuln/variable.dart';
import '../items/input.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final TextEditingController urlController = TextEditingController();
  bool _isVisible = false;
  int _numberModule = 0;

  @override
  void initState() {
    _numberModule = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width - 200;
    Get.testMode = true;
    return Column(
      children: [
        const SizedBox(height: 100),
        Container(
          margin: const EdgeInsets.only(left: 200, right: 200),
          width: double.infinity,
          height: 200,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: ListTile(
            title: Text(
              'WEBVULN',
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
              style: GoogleFonts.montserrat(
                fontSize: 100,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 200, right: 200),
          width: double.infinity,
          height: 100,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: inputUser(
            controller: urlController,
            hintName: 'Paste URL here to scan ...',
            underIcon: const Padding(
              padding: EdgeInsets.all(10),
              child: SizedBox(
                width: 10,
                height: 10,
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 50),
          width: double.infinity,
          height: screenHeight - 600,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black38, blurRadius: 10, offset: Offset(5, 5)),
            ],
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: boxModule(screenWidth, screenHeight),
        ),
        const SizedBox(height: 30),
        GradientButton(
          onPressed: () async {
            Navigator.of(context).push(
              MaterialPageRoute(builder: ((context) => const LoadingScreen()))
            );
            List<String> listURL = [urlController.text];
            try {
              final result = await postURL(
                nameURL: listURL,
                moduleNumber: Constants.valueSelected,
              );
              if (result == "Failed post data") {
                setState(() {
                  Constants.contentChild =
                      const CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  );
                });
              } else {
                Get.to(const LoadingScreen());
              }
            } catch (error) {
              print(error);
            }
          },
          child: const Icon(
            Icons.search_rounded,
            size: 45,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Row boxModule(double screenWidth, double screenHeight) {
    return Row(
      children: [
        Container(
          width: 150,
          height: double.infinity,
          margin: const EdgeInsets.all(40),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                Constants.nameModule.length,
                (index) => Row(
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
                          _isVisible = Constants.valueSelected.isNotEmpty;
                        });
                      },
                    ),
                    Text(
                      Constants.nameModule[index],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      style: GoogleFonts.montserrat(fontSize:14,fontWeight:FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const VerticalDivider(
          indent: 40,
          endIndent: 40,
          color: Color(0xFF021361),
          thickness: 2,
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            width: screenWidth,
            height: screenHeight / 2.7,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent, width: 1),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.document_scanner_rounded,
                      color: Color(0xFF1A35C3),
                    ),
                    title: Text(
                      'MODULE DESCRIPTION',
                      style: GoogleFonts.cabin(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: Column(
                      children: Constants.valueSelected
                          .map((selectedModule) => ListTile(
                                title: Text(
                                    Constants.content[Constants.nameModule
                                        .indexOf(selectedModule)],
                                    overflow: TextOverflow.fade,
                                    maxLines: 2,
                                    softWrap: false,
                                    style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
