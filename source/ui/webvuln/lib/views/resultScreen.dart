import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webvuln/main.dart';
import 'package:webvuln/items/drawer.dart';
import 'package:get/get.dart';
import 'package:webvuln/items/categoryButton.dart';

class resultScreen extends StatefulWidget {
  const resultScreen({super.key});

  @override
  State<resultScreen> createState() => _resultScreenState();
}

class _resultScreenState extends State<resultScreen> {
  @override
  Widget build(BuildContext context) {
    Get.testMode = true;
    return Scaffold(
      appBar:AppBar(
        title: Text("Back",style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back)),
      ) ,
      body: Container(
        margin: EdgeInsetsDirectional.symmetric(horizontal: 60),
        child: Column(
          children: [
            ListTile(
              title: Text('List Vulnerabilities',style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),),
            categoryButton()
          ]
        ),
      )
    );
  }
}
