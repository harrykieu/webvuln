import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:webvuln/items/infoTableXSSError.dart';
import 'package:webvuln/main.dart';
import 'package:get/get.dart';
// import 'package:webvuln/items/categoryButton.dart';
import '../items/pieGraph.dart';
import 'scanScreen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class resultScreen extends StatefulWidget {
  const resultScreen({super.key});

  @override
  State<resultScreen> createState() => _resultScreenState();
}

class _resultScreenState extends State<resultScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: 150,
        leading: ElevatedButton(onPressed: (){},
        style: ElevatedButton.styleFrom(
          padding:const EdgeInsets.all(20),
          minimumSize:const Size(100, 80),
          maximumSize: const Size(100, 80)
        ),
         child: Row(
          children: [
            const Icon(Icons.arrow_back),
            Text('Back',style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold),)
          ],
        ))
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            listVulnerabilities()
          ],
        ),
      ),
    );
  }
}
//bang list vulnerabilities
class listVulnerabilities extends StatefulWidget {
  const listVulnerabilities({super.key});

  @override
  State<listVulnerabilities> createState() => _listVulnerabilitiesState();
}

class _listVulnerabilitiesState extends State<listVulnerabilities> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 500,
      child:const Column(
        children: [
          ListTile(title: Row(
            children: [
              Image(image: AssetImage('lib/assets/list.png'))
            ],
          ),)
        ],
      ) ,
    );
  }
}