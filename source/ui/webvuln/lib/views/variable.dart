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
  static Widget content_general = const Column(
    children: [
      ListTile(
        leading: Icon(Icons.bug_report_outlined),
        title: Text('Injection:'),
        subtitle: Text('Description: Injection vulnerabilities occur when untrusted data is sent to an interpreter as part of a command or query, leading to unintended execution of commands.'),
      ),
      ListTile(
        leading: Icon(Icons.bug_report_outlined),
        title: Text('Broken Authentication:'),
        subtitle: Text('Description: This involves security flaws related to the authentication and session management functions, leading to unauthorized access and compromised user accounts.'),
      ),
      ListTile(
        leading: Icon(Icons.bug_report_outlined),
        title: Text('Sensitive Data Exposure:'),
        subtitle: Text('Description: In this scenario, applications fail to adequately protect sensitive information, leading to potential exposure of confidential data.'),
      ),
      ListTile(
        leading: Icon(Icons.bug_report_outlined),
        title: Text('XML External Entities (XXE):'),
        subtitle: Text('Description: XXE vulnerabilities occur when an application parses XML input that can contain external entities with malicious content, leading to various attacks'),
      )
    ],
  );
  static final List<Widget> content_vulnerabilities = [
    content_general,
    const ListTile(
      leading: Icon(Icons.bug_report_outlined),
      title: Text('XSS error:'),
    ),
    const ListTile(
      leading: Icon(Icons.bug_report_outlined),
      title: Text('SQL injection:'),
    ),
    const ListTile(
      leading: Icon(Icons.bug_report_outlined),
      title: Text('RCE error:'),
    ),
    const ListTile(
      leading: Icon(Icons.bug_report_outlined),
      title: Text('LFI error:'),
    ),
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
