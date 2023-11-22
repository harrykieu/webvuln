import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webvuln/service/api.dart';
import 'package:webvuln/views/loadingScreen.dart';
import '../items/submitButton.dart';
import '../items/input.dart';

class scan_screen extends StatefulWidget {
  const scan_screen({super.key});

  @override
  State<scan_screen> createState() => _scan_screenState();
}

class _scan_screenState extends State<scan_screen> {
  @override
  void initState() {
    setState(() {
      _numberModule = 0;
      // _isVisibled = true;
    });
    super.initState();
  }

  @override
  final TextEditingController urlController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Widget contentChild = Text(
    'Scan',
    style: GoogleFonts.montserrat(
        color: Colors.white, fontWeight: FontWeight.normal),
  );
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
  List<String> _valueSelected = [];
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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(height: 100,),

//Textbox SCAN URL
        container(
          margin: const EdgeInsets.only(left: 200,right: 200),
          Width: double.infinity,
          Height:200,
          decoration: BoxDecoration(color: Colors.transparent),
          child: ListTile(
            title: Text(
              'SCAN URL',
              style: GoogleFonts.montserrat(
                  fontSize: 100,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          )
        ),

// TextField Input url
        container(
          margin: const EdgeInsets.only(left: 200,right: 200),
          Width: double.infinity,
          Height: 100,
          decoration: BoxDecoration(color: Colors.transparent),
          child: inputUser(
            controller: urlController,
            hintName: 'Paste URL here',
            underIcon: const Padding(
                padding: EdgeInsets.all(10),
                child: Image(image: AssetImage('lib/assets/suffixIcon.png'))),
          )),

//Box Module scan 
        container(
          margin: const EdgeInsets.only(left: 50,right: 50),
          Width: double.infinity,
          child: boxModule(screenWidth,screenHeight), Height: screenHeight -600,decoration:const  BoxDecoration(color: Colors.white,boxShadow:[
          BoxShadow(
            color: Colors.black38,
            blurRadius: 10,
            offset: Offset(5, 5)
          )
        ],borderRadius: BorderRadius.all(Radius.circular(20)))),


//Button Scan URL
        submitButton(
          onPressed: () {
            // String result = postURL(nameURL: urlController.text, moduleNumber: _valueSelected) as String;
            Get.to(loadingScreen());
            if (postURL(
                    nameURL: urlController.text,
                    moduleNumber: _valueSelected).toString() ==
                "Failed post data" || postURL(nameURL: urlController.text, moduleNumber: _valueSelected).toString() == "Error") {
              setState(() {
              contentChild = const CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              );
            });
            } else{
              Get.to(loadingScreen());
            }
          },
          childButton: contentChild,
        ),
      ],
    );
  }

  Row boxModule(double screenWidth,double screenHeight) {
    return Row(
            children: [
              Container(
                  width: screenWidth / 8,
                  height: double.infinity,
                  margin: EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: SingleChildScrollView(
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
                                      _valueSelected.add(nameModule[index]);
                                    } else {
                                      _valueSelected.remove(nameModule[index]);
                                    }
                                    print(_valueSelected);
                                  });
                                },
                              ),
                              Text(nameModule[index]),
                            ],
                          );
                        },
                      ),
                    ),
                  )),
              const VerticalDivider(
                indent: 40,
                endIndent: 40,
                color: Color(0xFF021361),
                thickness: 2,
              ),
            container(
              margin: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
              Width: screenWidth - (screenWidth/2),
            child: SingleChildScrollView(
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
            ), Height: screenHeight/2.7, decoration:BoxDecoration(border: Border.all(color: Colors.transparent,width: 1)))
            ],
          );
  }

  Container container({required Widget child,required double Height,required BoxDecoration decoration,required double Width,required EdgeInsets margin}) {
    return Container(
          width:Width,
          height: Height,
          decoration: decoration ,
          margin: margin,
          child: child);
  }
}
// viet them ham nhan data tu backend de setState cho widget trong contentChild

// viết hàm truyền giá trị của 1 biến từ màn scan_screen sang màn main để màn main nhận định được _selectedIndex của nó chuyển thành 1 

