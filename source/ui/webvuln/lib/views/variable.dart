// constants.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Constants {
  static final List<String> content = [
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

  static final List<String> nameModule = [
    "ffuf",
    "dirsearch",
    "lfi",
    "sqli",
    "xss",
    "fileupload",
    "idor",
    "pathtraversal",
  ];

  static Widget buildInputUser({
    required TextEditingController controller,
    required String hintName,
    required Widget underIcon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintName,
        hintStyle: GoogleFonts.montserrat(
          fontSize: 20,
          color: Colors.grey[600],
        ),
        prefixIcon: underIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
      ),
    );
  }

  static Widget buildBoxModule({
    required double screenWidth,
    required List<bool> valueCheckbox,
    required Function(int) onChangedCheckbox,
    required int numberModule,
  }) {
    return Row(
      children: [
        Container(
          width: screenWidth / 8,
          height: double.infinity,
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            children: List.generate(
              nameModule.length,
              (index) {
                return Row(
                  children: [
                    Checkbox(
                      value: valueCheckbox[index],
                      onChanged: (value) {
                        onChangedCheckbox(index);
                      },
                    ),
                    Text(nameModule[index]),
                  ],
                );
              },
            ),
          ),
        ),
        const VerticalDivider(
          indent: 40,
          endIndent: 40,
          color: Color(0xFF021361),
          thickness: 2,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 200),
          width: 200,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
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
                    'Description',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(content[numberModule]),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
