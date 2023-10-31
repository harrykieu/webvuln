import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webvuln/service/api.dart';
import 'package:webvuln/views/drawer.dart';
import 'package:webvuln/views/resourcesScreen.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:webvuln/views/resultScreen.dart';

class scanScreen extends StatefulWidget {
  const scanScreen({super.key});

  @override
  State<scanScreen> createState() => _scanScreenState();
}

class _scanScreenState extends State<scanScreen> {
  @override
  void initState() {
    setState(() {
      
    });
    super.initState();
  }

  @override
  final TextEditingController urlController = TextEditingController();
  final _moduleController = TextEditingController();
  final _historyURLController = TextEditingController();
  final _dateScanController = TextEditingController();
  final _checkboxController = GroupController();
  final bool isLoading = false;
  Widget progressCircular = CircularProgressIndicator.adaptive();
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
        backgroundColor: Color(0xFFDCE8F6),
        body: Column(
          children: [
            // send scan URL and number module to backend
            Container(
              margin:
                  EdgeInsets.only(top: 200, left: 80, right: 80, bottom: 10),
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
              margin: EdgeInsetsDirectional.only(bottom: 40),
            ),
            Container(
              margin: EdgeInsetsDirectional.symmetric(horizontal: 100),
              // height: 100,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(0, 2),
                  blurRadius: 10,
                )
              ]),
              child: inputUser(
                controller: urlController,
                hintName: 'URL',
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 100, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(0, 2),
                        blurRadius: 5,
                      )
                    ]),
                child: SimpleGroupedCheckbox(
                  controller: _checkboxController,
                  itemsTitle: [
                    'Module scan 1',
                    'Module scan 2',
                    'Module scan 3',
                    'Module scan 4'
                  ],
                  values: [1, 2, 3, 4],
                  onItemSelected: (values) {
                    _moduleController.text = values.toString();
                    print(values);
                    setState(() {
                      contentContainer = content[values - 1];
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 100, vertical: 10),
              child: Container(
                width: double.infinity,
                height: 100,
                // margin: EdgeInsetsDirectional.symmetric(horizontal: ),
                padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(0, 2),
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
                Get.to(resultScreen());
              },
              title: 'Scan',
            ),
            Container(
              width: 50,
              height: 50,
              child: progressCircular,
            ),
            SizedBox(
              width: 100,
              height: 30,
            ),
          ],
        ));
  }
}

class submitButton extends StatelessWidget {
  const submitButton(
      {super.key,
      // required TextEditingController moduleController,
      required this.onPressed,
      required this.title});

  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Text(title),
    );
  }
}

class inputUser extends StatelessWidget {
  const inputUser({
    super.key,
    required this.controller,
    required this.hintName,
  });

  final TextEditingController controller;
  final String hintName;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: 'URL',
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      controller: controller,
    );
  }
}
