import 'package:flutter/material.dart';
import 'package:webvuln/service/api.dart';
import 'scan_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../items/submitButton.dart';
import '../items/input.dart';

class resourceScreen extends StatefulWidget {
  const resourceScreen({super.key});

  @override
  State<resourceScreen> createState() => _resourceScreenState();
}

class _resourceScreenState extends State<resourceScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _vulnTypeController = TextEditingController();
    final TextEditingController _typeController = TextEditingController();
    final TextEditingController _valueController = TextEditingController();
    final TextEditingController _actionController = TextEditingController();
    final TextEditingController _vulnTypeSearchController = TextEditingController();

    return Scaffold(
      body: Column(
        children: [
          Text('Resources',style: GoogleFonts.montserrat(fontSize: 30,fontWeight: FontWeight.bold)),
          Row(
            children: [
              boxInput(
                  controller: _vulnTypeController,
                  content: 'Enter vulnerability type:'),
              boxInput(controller: _actionController, content: 'Enter action'),
            ],
          ),
          Row(
            children: [
              boxInput(controller: _typeController, content: 'Enter Type:'),
              boxInput(controller: _valueController, content: 'Enter Value:'),
            ],
          ),
          submitButton(
                  onPressed: () {
                    postResources(
                        vulnType: _valueController.text,
                        action: _actionController.text,
                        resType: _typeController.text,
                        value: _valueController.text);
                  },
                  childButton: Text('get data to resource'),),
          Row(
            children: [
              boxInput(controller:_vulnTypeSearchController , content: 'Enter vulnerability Type to search')
            ],
          )
        ],
      ),
    );
  }

  Container boxInput(
      {required TextEditingController controller, required String content}) {
    return Container(
      width: 400,
      height:200,
      margin: EdgeInsetsDirectional.symmetric(horizontal: 10),
      child: inputUser(controller: controller, hintName: content,underIcon: Icon(Icons.text_fields),),
    );
  }
}
