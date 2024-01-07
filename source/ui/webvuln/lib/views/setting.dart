import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webvuln/items/gradient_button.dart';
import 'package:webvuln/variable.dart';

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
  final TextEditingController _fuff_location_Controller =
      TextEditingController();

  Future<void> _pickFolder({required TextEditingController controller}) async {
    String? directory = (await FilePicker.platform.getDirectoryPath());
    if (directory != null) {
      setState(() {
        controller.text = directory;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final setting = Provider.of<SettingProvider>(context, listen: false);
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            container(context,
                width: double.infinity,
                height: MediaQuery.of(context).size.height - 100,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 80,
                        padding: const EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4B55B6),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(
                                  0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                            leading: const Icon(
                              Icons.data_array,
                              color: Colors.white,
                              size: 20,
                            ),
                            title: Text(
                              "Theme",
                              style: GoogleFonts.montserrat(
                                  fontSize: 20, color: Colors.white),
                            ),
                            subtitle: Text(
                              "Change application theme",
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, color: Colors.white),
                            ),
                            trailing: ElevatedButton(
                                onPressed: () {
                                  setting.changeTheme();
                                  print(setting._change.toString());
                                },
                                child: const Text('change'))),
                      ),
                      Container(
                        width: double.infinity,
                        height: 80,
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4B55B6),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(
                                  0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.file_copy_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          title: Text(
                            "File format export:",
                            style: GoogleFonts.montserrat(
                                fontSize: 20, color: Colors.white),
                          ),
                          subtitle: Text(
                            "Default file format to export",
                            style: GoogleFonts.montserrat(
                                fontSize: 16, color: Colors.white),
                          ),
                          trailing: dropdownButton(state, dropdownValue),
                        ),
                      ),
                      listtile(context,
                          title: 'Database IP:             ',
                          trailing: IconButton(
                              onPressed: () {
                                print(_databaseController.text);
                              },
                              icon: const Icon(
                                Icons.save_as_outlined,
                                color: Colors.white,
                              )),
                          controller: _databaseController),
                      listtile(context,
                          title: 'Change export location:',
                          trailing: IconButton(
                              onPressed: () {
                                _pickFolder(controller: _locationController);
                              },
                              icon: const Icon(
                                Icons.folder,
                                color: Colors.white,
                              )),
                          controller: _locationController),
                      listtile(context,
                          title: 'Fuff location:            ',
                          trailing: IconButton(
                              onPressed: () {
                                _pickFolder(
                                    controller: _fuff_location_Controller);
                              },
                              icon: const Icon(
                                Icons.folder,
                                color: Colors.white,
                              )),
                          controller: _fuff_location_Controller),
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 5,
                      ),
                      GradientButton(
                          onPressed: () {
                            setState(() {
                              _databaseController.text =
                                  DotEnv().env['DATABASE_URI'].toString();
                            });
                            Constants(
                                directtoryDownload: _locationController.text,
                                fuffLocation: _fuff_location_Controller.text,
                                databaseIp: _databaseController.text);
                          },
                          child: Text(
                            'Save',
                            style: GoogleFonts.montserrat(
                                fontSize: 20, color: Colors.white),
                          ))
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Container dropdownButton(
      String state, List<DropdownMenuItem<String>> dropdownValue) {
    return Container(
      margin: const EdgeInsetsDirectional.only(end: 40),
      width: 150,
      height: 40,
      child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            icon: Icon(
              Icons.filter_alt_outlined,
              size: 30,
              color: Colors.white,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: Colors.white)),
            contentPadding: EdgeInsetsDirectional.only(start: 15),
          ),
          focusColor: const Color(0xFFF0F0F0),
          iconEnabledColor: Colors.white,
          style: GoogleFonts.montserrat(fontSize: 20, color: Colors.black),
          iconDisabledColor: Colors.white,
          icon: const Icon(Icons.arrow_drop_down),
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
