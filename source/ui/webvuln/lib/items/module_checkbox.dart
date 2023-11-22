import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class module_checkbox extends StatefulWidget {
  module_checkbox({super.key, required List<String> valueSelect});
  final List<String> valueSelect = [];
  @override
  State<module_checkbox> createState() => _module_checkboxState();
}

class _module_checkboxState extends State<module_checkbox> {
  @override
  List<String> content = [
    // "",
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
  List<bool> _valueCheckbox = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  int _numberModule = 0;
  List<String> nameModule = [
    "ffuf",
    "dirsearch",
    "lfi",
    "sqli",
    "xss",
    "fileupload",
    "idor",
    "pathtraversal",
  ];

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
            width: screenWidth / 8,
            height: double.infinity,
            margin: EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              children: List.generate(
                nameModule.length,
                (index) {
                  return Row(
                    children: [
                      Checkbox(
                        value: _valueCheckbox[index],
                        onChanged: (value) {
                          setState(() {
                            _valueCheckbox[index] = value!;
                            _numberModule = index;
                            if (value) {
                              widget.valueSelect.add(nameModule[index]);
                            } else {
                              widget.valueSelect.remove(nameModule[index]);
                            }
                            print(widget.valueSelect);
                          });
                        },
                      ),
                      Text(nameModule[index]),
                    ],
                  );
                },
              ),
            )),
        const VerticalDivider(
          indent: 40,
          endIndent: 40,
          color: Color(0xFF021361),
          thickness: 2,
        ),
        Container(
          width: screenWidth / 3,
          height: double.infinity,
          margin: EdgeInsetsDirectional.all(10),
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.document_scanner_rounded,
                  color: Color(0xFF1A35C3),
                ),
                title: Text(
                  'Description',
                  style: GoogleFonts.montserrat(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text(content[_numberModule]),
              )
            ],
          ),
        )
      ],
    );
  }
}
