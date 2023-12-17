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
    "Module scan fuff:\n Fuzzing is the automatic process of giving random input to an application to look for any errors or any unexpected behavior. But finding hidden directories and files on a web server can also be categorized under fuzzing.",
    "Module scan dirsearch:\n Dirsearch tool is a Python language-based tool, which is command-line only. Dirsearch lights when it comes to recursive scanning, so for every directory it identifies, it will go back through and crawl the directory for some additional directories.",
    "Module scan lfi:\n Local File Inclusion is an attack technique in which attackers trick a web application into either running or exposing files on a web server. LFI attacks can expose sensitive information, and in severe cases, they can lead to cross-site scripting (XSS) and remote code execution. LFI is listed as one of the OWASP Top 10 web application vulnerabilities.",
    "Module scan sqli:\n SQL injection (SQLi) is a web security vulnerability that allows an attacker to interfere with the queries that an application makes to its database. This can allow an attacker to view data that they are not normally able to retrieve. This might include data that belongs to other users, or any other data that the application can access. In many cases, an attacker can modify or delete this data, causing persistent changes to the application's content or behavior.",
    "Module scan xss:\n Cross-site scripting (also known as XSS) is a web security vulnerability that allows an attacker to compromise the interactions that users have with a vulnerable application. It allows an attacker to circumvent the same origin policy, which is designed to segregate different websites from each other. Cross-site scripting vulnerabilities normally allow an attacker to masquerade as a victim user, to carry out any actions that the user is able to perform, and to access any of the user's data. If the victim user has privileged access within the application, then the attacker might be able to gain full control over all of the application's functionality and data ",
    "Module scan fileupload:\n Description 6",
    "Module scan idor:\n Description 7",
    "Module scan path_traversal:\n Description 8",
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
