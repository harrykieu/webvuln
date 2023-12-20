import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:filepicker_windows/filepicker_windows.dart';

class settingScreen extends StatefulWidget {
  const settingScreen({super.key});

  @override
  State<settingScreen> createState() => _settingScreenState();
}

class _settingScreenState extends State<settingScreen> {
  @override
  TextEditingController _databaseController = TextEditingController();
  TextEditingController _formatController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _fuff_location_Controller = TextEditingController();
  Future<void> _getLocationFolder() async {
    final file = OpenFilePicker()
    ..filterSpecification = {
      'Word Document (*.doc)': '*.doc',
      'Web Page (*.htm; *.html)': '*.htm;*.html',
      'Text Document (*.txt)': '*.txt',
      'All Files': '*.*'
    }
    ..defaultFilterIndex = 0
    ..defaultExtension = 'doc'
    ..title = 'Select a document';

  final result = file.getFile();
  if (result != null) {
    print(result.path);
  }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
          title: const ListTile(
        leading: Icon(Icons.settings),
        title: Text("Settings"),
      )),
      body: Column(
        children: [
          container(context,
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 100,
              child: Column(
                children: [
                  listtile(context,
                      title: 'Database IP:             ',
                      trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.save_as_outlined,
                            color: Colors.white,
                          )),
                      controller: _databaseController),
                  listtile(context,
                      title: 'Format data export:',
                      trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.save_as_outlined,
                            color: Colors.white,
                          )),
                      controller: _formatController),
                  listtile(context,
                      title: 'Change export location:',
                      trailing: IconButton(
                          onPressed: _getLocationFolder,
                          icon: const Icon(
                            Icons.folder,
                            color: Colors.white,
                          )),
                      controller: _locationController),
                  listtile(context,
                      title: 'Fuff location:            ',
                      trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.folder,
                            color: Colors.white,
                          )),
                      controller: _fuff_location_Controller)
                ],
              ))
        ],
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
