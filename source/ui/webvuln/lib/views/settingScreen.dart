import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webvuln/items/input.dart';

class settingScreen extends StatefulWidget {
  const settingScreen({super.key});

  @override
  State<settingScreen> createState() => _settingScreenState();
}

class _settingScreenState extends State<settingScreen> {
  @override
  final List<String> items = ['PDF', 'Log'];
  Widget build(BuildContext context) {
    final _controller = ValueNotifier<bool>(false);
    final TextEditingController databaseIpController = TextEditingController();
    String _selectedValue = 'PDF';
    return Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        appBar: AppBar(
            title: ListTile(
          title: Text('Settings',
              style: GoogleFonts.montserrat(
                  fontSize: 30, fontWeight: FontWeight.bold)),
        )),
        body: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            margin: const EdgeInsets.all(40),
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 15,
                    spreadRadius: -7,
                  )
                ]),



//----------------------------------------------------------------
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Database',
                    style: GoogleFonts.montserrat(
                        fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color(0xFF4B55B6),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        'Database IP',
                        style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Container(
                        width: 300,
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: inputUser(
                            controller: databaseIpController,
                            hintName: 'Enter database IP',
                            underIcon: const Icon(Icons.data_array)),
                      )
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    'File exports',
                    style: GoogleFonts.montserrat(
                        fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color(0xFF4B55B6),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Change default export',
                            style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Container(
                            width: 300,
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.white
                            ),
                            child: Text('C:/Users/Admin/Computer',style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),),
                          ),
                          ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(
                                  maximumSize: const Size(150, 50),
                                  backgroundColor: const Color(0xFF000852).withAlpha(230)
                                ), child: Text('Browse',style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),),)
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'File export location',
                            style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Container(
                            width: 300,
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.white
                            ),
                            child: DropdownButton2(items:const [
                              DropdownMenuItem<String>(value: "PDF",child:Text("Option 1")),
                              DropdownMenuItem<String>(value: "DOC",child:Text("Option 2")),
                            ],
                            value: _selectedValue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
