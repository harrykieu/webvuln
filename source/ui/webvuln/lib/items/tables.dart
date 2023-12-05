import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:webvuln/items/newSubmitButton.dart';
import 'package:webvuln/views/detail_screen.dart';

class tableXSS extends StatefulWidget {
  const tableXSS({super.key});
  @override
  State<tableXSS> createState() => _tableXSSState();
}

class _tableXSSState extends State<tableXSS> {
  //textstyle
  TextStyle text_style_title = GoogleFonts.montserrat(
      fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold);
  TextStyle text_style_bold = GoogleFonts.montserrat(
      fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold);
  TextStyle text_style_normal = GoogleFonts.montserrat(
      fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal);
  TextStyle text_style_normal_white = GoogleFonts.montserrat(
      fontSize: 20, color: Colors.white, fontWeight: FontWeight.normal);
  TextStyle text_style_code = GoogleFonts.ubuntu(
      fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal);
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            width: double.infinity,
            height: 400,
            margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 60, vertical: 20),
            decoration: const BoxDecoration(
                color: Color(0xFFDEEDFF),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: SingleChildScrollView(
              child: DataTable(columns: [
                DataColumn(
                    label: Row(
                  children: [
                    Text(
                      'Serverity',
                      style: text_style_bold,
                    ),
                    tool_tip(content: 'Info about serverity')
                  ],
                )),
                DataColumn(
                    label: Row(
                  children: [
                    Text(
                      'Type',
                      style: text_style_bold,
                    ),
                    tool_tip(content: 'Info about Type error')
                  ],
                )),
                DataColumn(
                    label: Row(
                  children: [
                    Text(
                      'Description',
                      style: text_style_bold,
                    ),
                    tool_tip(content: 'Info about description')
                  ],
                ))
              ], rows: [
                DataRow(cells: [
                  const DataCell(Icon(
                    Icons.warning_amber,
                    color: Colors.amber,
                    size: 30,
                  )),
                  DataCell(Text(
                    "XSS",
                    style: text_style_normal,
                  )),
                  DataCell(Text(
                    '"https://www.google.com.vn/intl/vi/about.html"',
                    style: text_style_code,
                  ))
                ]),
                DataRow(cells: [
                  const DataCell(Icon(
                    Icons.warning_amber,
                    color: Colors.amber,
                    size: 30,
                  )),
                  DataCell(Text(
                    'XSS',
                    style: text_style_normal,
                  )),
                  DataCell(Text(
                    '"https://www.google.com.vn/intl/vi/about.html"',
                    style: text_style_code,
                  ))
                ]),
                DataRow(cells: [
                  const DataCell(Icon(
                    Icons.warning_amber,
                    color: Colors.amber,
                    size: 30,
                  )),
                  DataCell(Text(
                    'XSS',
                    style: text_style_normal,
                  )),
                  DataCell(Text(
                    '"https://www.google.com.vn/intl/vi/about.html"',
                    style: text_style_code,
                  ))
                ]),
                DataRow(cells: [
                  const DataCell(Icon(
                    Icons.warning_amber,
                    color: Colors.amber,
                    size: 30,
                  )),
                  DataCell(Text(
                    'XSS',
                    style: text_style_normal,
                  )),
                  DataCell(Text(
                    '"https://www.google.com.vn/intl/vi/about.html"',
                    style: text_style_code,
                  ))
                ]),
                DataRow(cells: [
                  const DataCell(Icon(
                    Icons.warning_amber,
                    color: Colors.amber,
                    size: 30,
                  )),
                  DataCell(Text(
                    'XSS',
                    style: text_style_normal,
                  )),
                  DataCell(Text(
                    '"https://www.google.com.vn/intl/vi/about.html"',
                    style: text_style_code,
                  ))
                ]),
                DataRow(cells: [
                  const DataCell(Icon(
                    Icons.warning_amber,
                    color: Colors.amber,
                    size: 30,
                  )),
                  DataCell(Text(
                    'XSS',
                    style: text_style_normal,
                  )),
                  DataCell(Text(
                    '"https://www.google.com.vn/intl/vi/about.html"',
                    style: text_style_code,
                  ))
                ])
              ]),
            )),
        Positioned(
            top: 340,
            right: 35,
            child: GradientButton(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              onPressed: () {
                Get.to(const detail_screen());
              },
              child: const Icon(
                Icons.more_horiz,
                color: Colors.white,
                size: 20,
              ),
            ))
      ],
    );
    ;
  }

  JustTheTooltip tool_tip({required String content}) {
    return JustTheTooltip(
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            content,
          ),
        ),
        child: const Icon(
          Icons.info_outline,
          color: Colors.black,
          size: 16,
        ));
  }
}
