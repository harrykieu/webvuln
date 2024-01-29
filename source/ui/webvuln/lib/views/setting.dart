import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ini/ini.dart';
import 'package:webvuln/items/input.dart';
import 'package:file_picker/file_picker.dart';


class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late Config config;
  final TextEditingController _databaseController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  late String state;
  List<DropdownMenuItem<String>> dropdownValue = [
    const DropdownMenuItem(key: Key('PDF'), value: 'PDF', child: Text('PDF')),
    const DropdownMenuItem(key: Key('XML'), value: 'XML', child: Text('XML')),
    const DropdownMenuItem(
        key: Key('JSON'), value: 'JSON', child: Text('JSON')),
  ];

  @override
  void initState() {
    super.initState();
    config = Config.fromStrings(File("config.ini").readAsLinesSync());
    _databaseController.text =
        config.get('database', 'uri').toString().replaceAll('\'', '');
    _locationController.text = config
        .get('export', 'default_location')
        .toString()
        .replaceAll('\'', '');
    state =
        config.get('export', 'default_type').toString().replaceAll('\'', '');
  }

  @override
  void dispose() {
    _databaseController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void saveConfig(
      TextEditingController controller, String section, String configKey) {
    if (controller.text != '') {
      config.set(section, configKey, '\'${controller.text}\'');
      File('config.ini').writeAsStringSync(config.toString());
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.87;
    double height = MediaQuery.of(context).size.height - 50;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
          title: ListTile(
        leading: const Icon(Icons.settings),
        title: Text(
          "SETTINGS",
          style:
              GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      )),
      body: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 2), // changes position of shadow
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: width,
              height: 50,
              margin: const EdgeInsetsDirectional.symmetric(
                  horizontal: 40, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ListTile(
                      leading: const Icon(Icons.dns),
                      title: Text("Database URI",
                          style: GoogleFonts.montserrat(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(
                    width: width - 800,
                    height: 40,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                        ),
                        suffixIcon: Icon(Icons.text_fields),
                      ),
                      controller: _databaseController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                      onPressed: () {
                        saveConfig(_databaseController, 'database', 'uri');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.greenAccent,
                            content: Text('Save config success', style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.normal,color:Colors.black)),
                            action: SnackBarAction(
                              label: 'OK',
                              textColor: Colors.black,
                              onPressed: () {
                                // Code to be executed when the user clicks on the action
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.save,
                        color: Colors.black,
                      )),
                ],
              ),
            ),
            Container(
              width: width,
              height: 50,
              margin: const EdgeInsetsDirectional.symmetric(
                  horizontal: 40, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ListTile(
                      leading: const Icon(Icons.folder),
                      title: Text("Default export location",
                          style: GoogleFonts.montserrat(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(
                    width: width - 850,
                    height: 40,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                        ),
                        suffixIcon: Icon(Icons.text_fields),
                      ),
                      controller: _locationController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                      onPressed: () {
                        FilePicker.platform.getDirectoryPath().then((value) {
                          setState(() {
                            _locationController.text =
                                value!.replaceAll('\\', '\\\\');
                          });
                        });
                      },
                      icon: const Icon(Icons.folder_open)),
                  const SizedBox(width: 10),
                  IconButton(
                      onPressed: () {
                        saveConfig(
                            _locationController, 'export', 'default_location');
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Row(
                                    children: [
                                      Icon(Icons.check_circle),
                                      SizedBox(width: 10),
                                      Text('Success')
                                    ],
                                  ),
                                  content:
                                      const Text('Save config successfully!'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'))
                                  ],
                                ));
                      },
                      icon: const Icon(
                        Icons.save,
                        color: Colors.black,
                      )),
                ],
              ),
            ),
            Container(
              width: width,
              height: 50,
              margin: const EdgeInsetsDirectional.symmetric(
                  horizontal: 40, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ListTile(
                      leading: const Icon(Icons.file_open),
                      title: Text("Default export type",
                          style: GoogleFonts.montserrat(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(
                    width: width - 800,
                    height: 40,
                    child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.0),
                            )),
                        focusColor: const Color(0xFFF0F0F0),
                        style: GoogleFonts.montserrat(
                            fontSize: 20, color: Colors.black),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.black),
                        dropdownColor: Colors.white,
                        value: state,
                        items: dropdownValue,
                        onSaved: (v) {
                          setState(() {
                            state = v!;
                          });
                        },
                        onChanged: (v) {
                          setState(() {
                            state = v!;
                          });
                        }),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                      onPressed: () {
                        config.set('export', 'default_type', '\'$state\'');
                        File('config.ini').writeAsStringSync(config.toString());
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Row(
                                    children: [
                                      Icon(Icons.check_circle),
                                      SizedBox(width: 10),
                                      Text('Success')
                                    ],
                                  ),
                                  content:
                                      const Text('Save config successfully!'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'))
                                  ],
                                ));
                      },
                      icon: const Icon(
                        Icons.save,
                        color: Colors.black,
                      )),
                ],
              ),
            ),
            SizedBox(height: height - 300),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'About',
                    style: GoogleFonts.montserrat(
                        fontSize: 20, fontWeight: FontWeight.normal),
                  ),
                  IconButton(
                      onPressed: () {
                        showAboutDialog(
                            context: context,
                            applicationIcon: Image.asset(
                              'lib/assets/logo.png',
                              width: 75,
                              height: 75,
                            ),
                            applicationName: 'WebVuln',
                            applicationVersion: '1.0.0',
                            children: [
                              const Text(
                                'WebVuln is a web vulnerability scanner that helps you to scan vulnerabilities in your web application.',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Text('This project is developed by:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const Text(
                                  'Kieu Huy Hai,\nVu Duc Hieu,\nBui Cong Hoang,\nDoan Tri Tien,\nLe Trong Tan')
                            ]);
                      },
                      icon: const Icon(Icons.help_outline)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container boxInput(
      {required TextEditingController controller, required String content}) {
    return Container(
      width: 950,
      height: 50,
      margin:
          const EdgeInsetsDirectional.symmetric(horizontal: 40, vertical: 10),
      child: inputUser(
        controller: controller,
        hintName: content,
        underIcon: const Icon(Icons.text_fields),
      ),
    );
  }
}
