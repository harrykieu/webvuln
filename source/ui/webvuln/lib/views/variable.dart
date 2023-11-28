// constants.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  static Widget contentChild = Text(
    'Scan',
    style: GoogleFonts.montserrat(
        color: Colors.white, fontWeight: FontWeight.normal),
  );
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
  static List<bool> valueCheckbox = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  static List<String> valueSelected = [];
  static int numberModule = 0;
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
}
