import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ini/ini.dart';
import 'package:webvuln/items/input.dart';
import 'package:file_picker/file_picker.dart';

class SettingProvider extends ChangeNotifier {
  bool _change = false;
  // bool get change => _change;

  changeTheme() {
    _change = !_change;
    notifyListeners();
  }
}

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final TextEditingController _databaseController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.87;
    double height = MediaQuery.of(context).size.height - 200;
    Config config = Config.fromStrings(File("config.ini").readAsLinesSync());
    String state = 'PDF';
    List<DropdownMenuItem<String>> dropdownValue = [
      const DropdownMenuItem(value: 'PDF', child: Text('PDF')),
      const DropdownMenuItem(value: 'XML', child: Text('XML')),
      const DropdownMenuItem(value: 'JSON', child: Text('JSON')),
    ];

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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.dns),
                Text(
                  "Database URI",
                  style: GoogleFonts.montserrat(
                      fontSize: 20, fontWeight: FontWeight.normal),
                ),
                boxInput(
                    controller: _databaseController,
                    content: config
                        .get('database', 'uri')
                        .toString()
                        .replaceAll('\'', '')),
                IconButton(
                    onPressed: () {
                      if (_databaseController.text != '') {
                        config.set('database', 'uri',
                            '\'${_databaseController.text}\'');
                        File('config.ini').writeAsStringSync(config.toString());
                        setState(() {});
                      }
                    },
                    icon: const Icon(
                      Icons.save,
                      color: Colors.black,
                    )),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.folder),
                Text(
                  "Default export location:",
                  style: GoogleFonts.montserrat(
                      fontSize: 20, fontWeight: FontWeight.normal),
                ),
                boxInput(
                    controller: _locationController,
                    content: config
                        .get('export', 'default_location')
                        .toString()
                        .replaceAll('\'', '')),
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
                IconButton(
                    onPressed: () {
                      if (_locationController.text != '') {
                        config.set('export', 'default_location',
                            '\'${_locationController.text}\'');
                        File('config.ini').writeAsStringSync(config.toString());
                        setState(() {});
                      }
                    },
                    icon: const Icon(
                      Icons.save,
                      color: Colors.black,
                    )),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.folder),
                Text(
                  "Default export type:",
                  style: GoogleFonts.montserrat(
                      fontSize: 20, fontWeight: FontWeight.normal),
                ),
                dropdownButton(state, dropdownValue)
              ],
            )
          ],
        ),
      ),
    );
  }

  Container dropdownButton(
      // TODO: save to ini
      String state,
      List<DropdownMenuItem<String>> dropdownValue) {
    return Container(
      margin: const EdgeInsetsDirectional.only(end: 40),
      width: 150,
      height: 40,
      child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            icon: Icon(
              Icons.filter_alt_outlined,
              size: 30,
              color: Colors.black,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: Colors.white)),
            contentPadding: EdgeInsetsDirectional.only(start: 15),
          ),
          focusColor: const Color(0xFFF0F0F0),
          style: GoogleFonts.montserrat(fontSize: 20, color: Colors.black),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
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

  ListTile listtile(BuildContext context,
      {required String title,
      required Widget trailing,
      required TextEditingController controller}) {
    return ListTile(
        title: Text(
          title,
          style: GoogleFonts.montserrat(
              fontSize: 20, fontWeight: FontWeight.normal),
        ),
        subtitle: Container(
            width: MediaQuery.of(context).size.width / 3,
            height: 80,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF4B55B6),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: ListTile(
              leading: Text(title,
                  style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white)),
              title: Theme(
                data:
                    Theme.of(context).copyWith(splashColor: Colors.transparent),
                child: TextField(
                  controller: controller,
                  autofocus: false,
                  style: const TextStyle(fontSize: 22.0, color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Type here...',
                    hintStyle: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      _locationController.text = value;
                    });
                  },
                ),
              ),
              trailing: trailing,
            )));
  }

  Container container(BuildContext context,
      {required double width, required double height, required Widget child}) {
    return Container(
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
      child: child,
    );
  }
}
