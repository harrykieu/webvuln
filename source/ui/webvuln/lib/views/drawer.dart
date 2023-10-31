import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:webvuln/views/resultScreen.dart';
import 'package:webvuln/views/scanScreen.dart';

class drawer extends StatefulWidget {
  const drawer({super.key});

  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GetMaterialApp(
      home: Container(
      width: screenWidth * 0.15,
      height: double.infinity,
      color: const Color(0xFF080848),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Image.asset('lib/assets/logo.png'),
          SizedBox(
            height: 10,
          ),
          Text(
            'WEB VULN',
            style: GoogleFonts.montserrat(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          button_box(),
          SizedBox(height: screenHeight - 550),
          FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.settings),
            tooltip: 'Settings',
            backgroundColor: Color(0xFF4C4FAB),
          )
        ],
      ),
    ),
    );
  }

  Container button_box() {
    return Container(
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          // spacing: 20.0,
          children: [
            button(
                name_button: 'Scan',
                pathimage: 'lib/assets/scanner.png',
                onPressed: () {
                  Get.to(scanScreen());
                }),
            const SizedBox(height: 20.0),
            button(
                name_button: 'Result',
                pathimage: 'lib/assets/result.png',
                onPressed: () {
                  Get.to(resultScreen());
                }),
            const SizedBox(height: 20.0),
            button(
                name_button: 'History',
                pathimage: 'lib/assets/history.png',
                onPressed: () {})
          ],
        ),
      ),
    );
  }

  ElevatedButton button(
      {required String name_button,
      required String pathimage,
      required Function() onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Image.asset(pathimage),
          const SizedBox(
            width: 10,
          ),
          Text(
            name_button,
            style: GoogleFonts.montserrat(color: Colors.white),
          )
        ],
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.hovered)) {
          return Color(0xFF4C4FAB);
        }
        return Color(0xFF080848);
      })),
    );
  }
}
