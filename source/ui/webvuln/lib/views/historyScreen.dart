// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:webvuln/items/table_history.dart';
import 'scan_screen.dart';
import 'package:webvuln/service/api.dart';
import '../items/submitButton.dart';
import '../items/input.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

class historyScreen extends StatefulWidget {
  const historyScreen({super.key});

  @override
  State<historyScreen> createState() => _historyScreenState();
}

class _historyScreenState extends State<historyScreen> {
  @override
  final TextEditingController _historyURLController = TextEditingController();
  final TextEditingController _dateScanController = TextEditingController();
  final List<Map<String, String>> data = [
    {
      "no": "1",
      "Vuln": "XSS error",
      "Des": "https://www.google.com.vn/intl/vi/about.html",
      "date/time": "11-11-23/12:52:34 AM"
    },
    {
      "no": "1",
      "Vuln": "XSS error",
      "Des": "https://www.google.com.vn/intl/vi/about.html",
      "date/time": "11-11-23/12:52:34 AM"
    }
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Widget inputData_datetime = Container(
      width: 400,
      height: 55,
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          gradient: LinearGradient(colors: [
            Color(0xFF2400FF),
            Color(0xFF0075FF),
            Color(0xFF710883)
          ])),
      child: inputUser(
        controller: _dateScanController,
        hintName: 'Date & Time',
        underIcon: const Icon(Icons.search_rounded),
      ),
    );
    Widget inputData_url = Container(
      width: 400,
      height: 55,
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          gradient: LinearGradient(colors: [
            Color(0xFF2400FF),
            Color(0xFF0075FF),
            Color(0xFF710883)
          ])),
      child: inputUser(
        controller: _historyURLController,
        hintName: 'Paste URL here ',
        underIcon: const Icon(Icons.search_rounded),
      ),
    );
    List<Widget> historyTable = [
      Stack(
        children: [
          Container(
            width: double.infinity,
            height: height - 150,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                        width: double.infinity,
                        height: height - 300,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFFDEEDFF), Colors.white]),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: SortableTable()),
                  ],
                )
              ],
            ),
          ),
          Positioned(
              top: height - 210,
              right: 20,
              child: Container(
                width: 150,
                child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Colors.white,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.picture_as_pdf,
                        color: Colors.grey,
                        size: 30,
                      ),
                      Text(
                        'PDF',
                        style: GoogleFonts.montserrat(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      const Icon(Icons.download)
                    ],
                  ),
                ),
              ))
        ],
      ),
      Container(
        width: double.infinity,
        height: height - 150,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        color: Colors.black,
      )
    ];

    return Scaffold(
      drawer: null,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "History",
            style: GoogleFonts.montserrat(
                fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 3),
                    blurRadius: 10,
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                inputData_datetime,
                inputData_url,
                Container(
                  width: 200,
                  height: 50,
                  child: FloatingActionButton(
                    onPressed: () {
                      showDialog(
                          barrierDismissible: false,
                          barrierColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shadowColor: Colors.black38,
                              title: const Text('Sort by'),
                              content: Container(
                                width: 100,
                                height: 100,
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    TextButton(
                                        onPressed: () {},
                                        child: const Text('Number')),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Text('Vulnerabilities')),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Text('Date/Time')),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Đóng popup
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          });
                    },
                    child: const Text('Sort by'),
                  ),
                ),
                submitButton(
                  onPressed: () {
                    postHistory(
                      nameURL: _historyURLController.text,
                      datetime: _dateScanController.text,
                    );
                  },
                  childButton: const Icon(
                    Icons.search_sharp,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          historyTable[0]
        ],
      ),
    );
  }
}
