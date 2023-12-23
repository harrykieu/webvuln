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
    "FFUF: Fast web fuzzer written in Go",
    "Dirsearch: Web path scanner with file fuzzing capabilities",
    "LFI: Module to scan Local File Inclusion",
    "SQLi: Module to scan SQL Injection",
    "XSS: Module to scan Cross-Site Scripting",
    "File Upload: Module to scan File Upload",
    "IDOR: Module to scan Insecure Direct Object References",
    "Path Traversal: Module to scan Path Traversal",
  ];
  static Widget vulnDesc = const Column(
    children: [
      ListTile(
        leading: Icon(Icons.bug_report_outlined),
        title: Text('SQL Injection:'),
        subtitle: Text(
            'SQL injection is a web security vulnerability that allows an attacker to interfere with the queries that an application makes to its database. It generally allows an attacker to view data that they are not normally able to retrieve. This might include data belonging to other users, or any other data that the application itself is able to access. In many cases, an attacker can modify or delete this data, causing persistent changes to the application\'s content or behavior.'),
      ),
      ListTile(
        leading: Icon(Icons.bug_report_outlined),
        title: Text('Cross-Site Scripting (XSS):'),
        subtitle: Text(
            'Cross-site scripting (also known as XSS) is a web security vulnerability that allows an attacker to compromise the interactions that users have with a vulnerable application. It allows an attacker to circumvent the same origin policy, which is designed to segregate different websites from each other. Cross-site scripting vulnerabilities normally allow an attacker to masquerade as a victim user, to carry out any actions that the user is able to perform, and to access any of the user\'s data. If the victim user has privileged access within the application, then the attacker might be able to gain full control over all of the application\'s functionality and data.'),
      ),
      ListTile(
        leading: Icon(Icons.bug_report_outlined),
        title: Text('Local File Inclusion (LFI):'),
        subtitle: Text(
            'Local File Inclusion (LFI) is an attack technique used to exploit web applications that dynamically reference external files or the webserver itself by manipulating the input parameters of the application.'),
      ),
      ListTile(
        leading: Icon(Icons.bug_report_outlined),
        title: Text('Path Traversal:'),
        subtitle: Text(
            'Path Traversal is an attack which allows attackers access to restricted directories and files, and it might grant them unauthorized read and write access to the file system, or even let them execute arbitrary code on the server.'),
      ),
      ListTile(
        leading: Icon(Icons.bug_report_outlined),
        title: Text('File Upload:'),
        subtitle: Text(
            'File Upload vulnerabilities are a common problem in web applications that allow users to upload files to a server. These vulnerabilities can be used to upload malicious files (such as PHP files) that can then be executed by the server. This may allow an attacker to gain access to the server hosting the application.'),
      ),
      ListTile(
        leading: Icon(Icons.bug_report_outlined),
        title: Text('IDOR (Insecure Direct Object References):'),
        subtitle: Text(
            'IDOR vulnerabilities occur when an application provides direct access to objects based on user-supplied input. As a result of this vulnerability attackers can bypass authorization and access resources in the system directly, for example database records or files.'),
      ),
    ],
  );
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
